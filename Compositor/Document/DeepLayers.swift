import AppKit

/// 16-bit layers in 8-bit documents. A layer whose `ImportedImage` carries `deep` keeps its pixels at 16 bits a
/// channel; its `image` is a dithered 8-bit copy that the canvas, thumbnails and every tool keep using unchanged.
/// Operations that understand 16-bit pixels read `deep` and make a new one; any other operation makes a new
/// `ImportedImage` without it, and the layer is simply 8-bit from then on (like text, rasterized).
nonisolated enum DeepLayer {
    /// The one layout 16-bit pixels are kept in: sRGB, premultiplied RGBA, native-endian 16-bit, rows packed
    /// (`width × 8` bytes), top-left origin like `BrushRaster`.
    static func context(width: Int, height: Int) throws -> CGContext {
        guard let result = CGContext(data: nil, width: width, height: height, bitsPerComponent: 16, bytesPerRow: width * 8,
            space: CGColorSpace(name: CGColorSpace.sRGB)!,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder16Little.rawValue) else {
            throw ExportError.render
        }
        result.translateBy(x: 0, y: CGFloat(height))
        result.scaleBy(x: 1, y: -1)
        return result
    }

    /// `image` drawn into the 16-bit layout, whatever it came in as.
    static func canonical(_ image: CGImage) throws -> CGContext {
        let context = try context(width: image.width, height: image.height)
        BrushRaster.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height), mask: false, context: context)
        return context
    }

    /// `image` at 16 bits in the standard layout, as a layer keeps it.
    static func image(_ image: CGImage) throws -> CGImage {
        guard let result = try canonical(image).makeImage() else { throw ExportError.render }
        return result
    }

    /// The layer's 8-bit copy: rounded with a fine noise rather than straight down, so gradients don't step.
    static func dithered(_ deep: CGImage) throws -> CGImage {
        let wide = try canonical(deep)
        let target = try BrushRaster.context(width: deep.width, height: deep.height, mask: false)
        guard let source = wide.data, let pixels = target.data else { throw ExportError.render }
        dither_quantize16(source.assumingMemoryBound(to: UInt16.self), pixels.assumingMemoryBound(to: UInt8.self),
                          deep.width, deep.height, target.bytesPerRow)
        guard let result = target.makeImage() else { throw ExportError.render }
        return result
    }

    /// The whole layer at 16 bits, or nil for an 8-bit layer. A painted layer's 16-bit pixels are its raster's base;
    /// the strokes go over them as 8-bit patches (fresh paint has no more to it), so most of it keeps its precision
    /// and a stroke costs no more than on any layer.
    static func flattened(_ asset: ImportedImage) throws -> CGImage? {
        guard let deep = asset.deep else { return nil }
        guard let raster = asset.raster, let base = raster.base else { return deep }
        let width = raster.width, height = raster.height
        let whole = try context(width: width, height: height)
        BrushRaster.draw(deep, in: raster.baseRect, mask: false, context: whole)
        // Paint is wherever the layer's 8-bit pixels differ from its 8-bit base alone (`deep_take_painted`).
        let painted = try BrushRaster.copy(asset.image)
        let unpainted = try BrushRaster.context(width: width, height: height, mask: false)
        BrushRaster.draw(base, in: raster.baseRect, mask: false, context: unpainted)
        guard painted.width == width, painted.height == height, let wholeData = whole.data, let paintedData = painted.data,
              let unpaintedData = unpainted.data else { throw ExportError.render }
        deep_take_painted(wholeData.assumingMemoryBound(to: UInt16.self), whole.bytesPerRow,
                          paintedData.assumingMemoryBound(to: UInt8.self), unpaintedData.assumingMemoryBound(to: UInt8.self),
                          painted.bytesPerRow, width, height)
        guard let result = whole.makeImage() else { throw ExportError.render }
        return result
    }

    /// A layer asset for 16-bit pixels: the 16-bit image, its dithered 8-bit copy and a thumbnail of it.
    static func asset(_ deep: CGImage, name: String) throws -> ImportedImage {
        let deep = try image(deep)
        let image = try dithered(deep)
        return ImportedImage(image: image, thumbnail: try PixelAdjust.thumbnail(of: image), name: name, deep: deep)
    }

    /// Runs an 8-bit operation on a 16-bit image without losing its precision: on its rounded-down 8-bit values and on
    /// those one and four steps up, then reads the 16-bit result off between the three (`deep_merge`). The operation
    /// must return an image the size it was given.
    static func run(_ deep: CGImage, through operation: (CGImage) throws -> CGImage) throws -> CGImage {
        let width = deep.width, height = deep.height
        let source = try canonical(deep)
        guard let input = source.data else { throw ExportError.render }
        let results = try [0, 1, 4].map { step -> CGContext in
            let context = try BrushRaster.context(width: width, height: height, mask: false)
            guard let bytes = context.data else { throw ExportError.render }
            deep_split(input.assumingMemoryBound(to: UInt16.self), source.bytesPerRow, bytes.assumingMemoryBound(to: UInt8.self),
                       context.bytesPerRow, width, height, Int32(step))
            guard let image = context.makeImage() else { throw ExportError.render }
            let result = try operation(image)
            guard result.width == width, result.height == height else { throw ExportError.render }
            return try BrushRaster.copy(result)
        }
        let out = try context(width: width, height: height)
        guard let low = results[0].data, let near = results[1].data, let far = results[2].data, let outData = out.data else {
            throw ExportError.render
        }
        deep_merge(input.assumingMemoryBound(to: UInt16.self), source.bytesPerRow, low.assumingMemoryBound(to: UInt8.self),
                   near.assumingMemoryBound(to: UInt8.self), far.assumingMemoryBound(to: UInt8.self), results[0].bytesPerRow,
                   outData.assumingMemoryBound(to: UInt16.self), out.bytesPerRow, width, height)
        guard let result = out.makeImage() else { throw ExportError.render }
        return result
    }

    /// A color lookup (`cube`, `dimension`³ RGBA floats as Core Image's color cube) applied to 16-bit pixels, smoothly
    /// between its points. For operations whose channels mix (Hue/Saturation, Black & White, Color Balance, Gradient
    /// Map): `run` reads each channel's result off its own input, which they don't follow, and they came out banded.
    static func lookup(_ deep: CGImage, cube: Data, dimension: Int) throws -> CGImage {
        guard cube.count >= dimension * dimension * dimension * 4 * MemoryLayout<Float>.size else { throw ExportError.render }
        let context = try canonical(deep)
        guard let data = context.data else { throw ExportError.render }
        cube.withUnsafeBytes { raw in
            deep_cube_apply(data.assumingMemoryBound(to: UInt16.self), context.bytesPerRow, deep.width, deep.height,
                            raw.assumingMemoryBound(to: Float.self).baseAddress!, Int32(dimension))
        }
        guard let result = context.makeImage() else { throw ExportError.render }
        return result
    }

    /// A Core Image result rendered at 16 bits, as `PixelAdjust.render` renders one at 8.
    static func render(_ image: CIImage, width: Int, height: Int) throws -> CGImage {
        guard let result = PixelAdjust.ciContext.createCGImage(image, from: CGRect(x: 0, y: 0, width: width, height: height),
                format: .RGBA16, colorSpace: CGColorSpace(name: CGColorSpace.sRGB)!) else { throw ExportError.render }
        return result
    }

    /// `deep` placed at `inside` on a clear 16-bit grid `size` large: a layer padded out for a blur to spread into.
    static func padded(_ deep: CGImage, to size: CGSize, inside: CGRect) throws -> CGImage {
        let context = try context(width: Int(size.width), height: Int(size.height))
        BrushRaster.draw(deep, in: inside, mask: false, context: context)
        guard let result = context.makeImage() else { throw ExportError.render }
        return result
    }
}
