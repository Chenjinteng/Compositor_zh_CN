import AppKit
import ImageIO
import Testing
import UniformTypeIdentifiers
@testable import Compositor

/// 16-bit layers in 8-bit documents (`DeepLayer`): imported 16-bit images keep their precision through Levels,
/// filters, saving and 16-bit export, while every tool keeps working on their dithered 8-bit copy.
@MainActor
struct DeepLayerTests {
    static let width = 256, height = 8

    /// A 16-bit PNG of a gray ramp four 8-bit steps wide (100 to 104), so it holds about 256 distinct 16-bit values
    /// but only five 8-bit ones.
    private func ramp16() throws -> URL {
        let context = try DeepLayer.context(width: Self.width, height: Self.height)
        let pixels = try #require(context.data).assumingMemoryBound(to: UInt16.self)
        for y in 0..<Self.height {
            for x in 0..<Self.width {
                let value = UInt16(((100 + 4 * Double(x) / Double(Self.width - 1)) / 255 * 65535).rounded())
                let i = (y * Self.width + x) * 4
                pixels[i] = value; pixels[i + 1] = value; pixels[i + 2] = value; pixels[i + 3] = 65535
            }
        }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".png")
        let destination = try #require(CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil))
        CGImageDestinationAddImage(destination, try #require(context.makeImage()), nil)
        #expect(CGImageDestinationFinalize(destination))
        return url
    }

    /// The red channel of a row, at 16 bits.
    private func row(_ image: CGImage, _ y: Int = 4) throws -> [Int] {
        let context = try DeepLayer.canonical(image)
        let pixels = try #require(context.data).assumingMemoryBound(to: UInt16.self)
        return (0..<image.width).map { Int(pixels[(y * image.width + $0) * 4]) }
    }

    private func importedSession() async throws -> (EditorSession, URL) {
        let url = try ramp16()
        let session = EditorSession()
        await session.importImages([url])
        return (session, url)
    }

    @Test func sixteenBitImportsBecomeSixteenBitLayers() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let asset = try #require(session.activeLayer?.asset)
        let deep = try #require(asset.deep, "the layer keeps its 16-bit pixels")
        #expect(deep.bitsPerComponent == 16 && asset.image.bitsPerComponent == 8)
        #expect(Set(try row(deep)).count > 200, "the ramp's fine steps are all there")
        #expect(session.activeLayer?.depthLabel == "16-Bits")
    }

    /// Levels stretching the ramp's four steps across the whole range: the 16-bit layer comes out a smooth ramp,
    /// where 8 bits could only make five flat bands of it.
    @Test func levelsKeepsSixteenBitPrecision() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.beginLevels()
        var settings = LevelsSettings()
        settings.ranges[0].black = 100
        settings.ranges[0].white = 104
        session.updateLevels(settings, preview: true)
        await session.commitLevels()
        let deep = try #require(session.activeLayer?.asset?.deep, "Levels kept the layer 16-bit")
        let values = try row(deep)
        #expect(Set(values).count > 150, "a smooth ramp, not bands: \(Set(values).count) distinct values")
        // Ideally 0 at the left, 65535 at the right, straight between; allow a couple of 8-bit steps either way.
        let worst = values.enumerated().map { abs(Double($1) - Double($0) / Double(Self.width - 1) * 65535) }.max() ?? 0
        #expect(worst < 3 * 257, "follows the stretched ramp: worst \(worst / 257) steps off")
    }

    /// Levels halving the output range: each 8-bit step moves the result by only half a step, so read one step
    /// apart, runs of the ramp would come out flat. Read four apart (`deep_merge`), it stays a fine ramp. Within half a
    /// step of exact, not closer: the 8-bit operation rounds its own results, which the 16-bit one is read off.
    @Test func compressingToneChangesStaySmooth() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.beginLevels()
        var settings = LevelsSettings()
        settings.ranges[0].outputWhite = 127.5
        session.updateLevels(settings, preview: true)
        await session.commitLevels()
        let values = try row(try #require(session.activeLayer?.asset?.deep))
        #expect(Set(values).count > 200, "\(Set(values).count) distinct values")
        var worst = 0.0
        for (x, value) in values.enumerated() {
            let level = 100 + 4 * Double(x) / Double(Self.width - 1)
            let exact = level / 2 / 255 * 65535
            worst = max(worst, abs(Double(value) - exact))
        }
        #expect(worst < 257 * 0.6, "within half a step of exact: \(worst / 257) steps off")
    }

    @Test func filtersKeepSixteenBitPixels() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.beginFilter(.gaussianBlur)
        session.updateFilter(FilterSettings(radius: 2), preview: true)
        await session.commitFilter()
        let asset = try #require(session.activeLayer?.asset)
        let deep = try #require(asset.deep, "the blurred layer is still 16-bit")
        #expect(deep.width == asset.image.width && deep.height == asset.image.height)
    }

    @Test func savingAndReopeningKeepsTheSixteenBitPixels() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let id = try #require(session.activeLayer?.id)
        let before = try #require(session.activeLayer?.asset?.deep)
        let project = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".comp")
        defer { try? FileManager.default.removeItem(at: project) }
        let snapshot = try #require(session.projectSnapshot())
        #expect(snapshot.manifest.version == 12)
        try await ProjectStore.shared.save(snapshot, to: project)
        let loaded = try await ProjectStore.shared.load(from: project)
        let after = try #require(loaded.images[id]?.deep, "reopened as a 16-bit layer")
        #expect(try row(after) == row(before), "pixel for pixel")
    }

    @Test func sixteenBitExportKeepsThePrecision() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let snapshot = try #require(session.projectSnapshot())
        let deep = try await ImageExporter.shared.render(snapshot, sixteenBit: true).image
        #expect(deep.bitsPerComponent == 16)
        #expect(Set(try row(deep)).count > 200)
        let flat = try await ImageExporter.shared.render(snapshot).image
        #expect(flat.bitsPerComponent == 8, "an ordinary export is unchanged")
    }

    @Test func hueSaturationKeepsSixteenBitPixels() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        var settings = HueSaturationSettings()
        settings.adjustments[.master] = RangeAdjustment(hue: 0, saturation: 0, lightness: 20)
        session.beginHueSaturation()
        session.updateHueSaturation(settings, preview: true)
        await session.hueSaturationTask?.value
        await session.commitHueSaturation()
        let deep = try #require(session.activeLayer?.asset?.deep, "Hue/Saturation kept the layer 16-bit")
        #expect(Set(try row(deep)).count > 200, "still a fine ramp")
    }

    @Test func imageSizeResamplesAtSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let result = try await ImageResizer.shared.resize(try #require(session.projectSnapshot()),
            to: ImageSizeOptions(width: Self.width * 2, height: Self.height * 2, resolution: 72))
        session.applyImageSize(result)
        let deep = try #require(session.activeLayer?.asset?.deep, "the resized layer is still 16-bit")
        #expect(deep.width == Self.width * 2 && deep.bitsPerComponent == 16)
        #expect(Set(try row(deep, 8)).count > 300, "the doubled ramp has finer steps, not copied 8-bit ones")
    }

    /// Flip, crop and rotating the canvas change only the layer's transform: its 16-bit pixels are untouched.
    @Test func flippingAndRotatingKeepSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.flipCanvas(horizontally: true)
        session.rotateCanvas(clockwise: true)
        #expect(session.activeLayer?.asset?.deep != nil)
    }

    /// Painting lays its strokes over the 16-bit pixels as 8-bit patches: the layer stays 16-bit, the unpainted part
    /// keeps every fine step, and saving writes the whole of it at 16 bits.
    @Test func paintingKeepsTheRestSixteenBit() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let id = try #require(session.activeLayer?.id)
        session.selectTool(.brush)
        session.brushSettings = BrushSettings(diameter: 6, hardness: 1, red: 1, green: 0, blue: 0)
        session.beginBrush(at: CGPoint(x: 10, y: 4))
        session.continueBrush(at: CGPoint(x: 20, y: 4))
        await session.finishBrush()
        let asset = try #require(session.activeLayer?.asset)
        #expect(asset.raster != nil && asset.deep != nil, "painted, and still 16-bit")
        #expect(session.activeLayer?.depthLabel == "16-Bits")
        let whole = try #require(try DeepLayer.flattened(asset))
        let values = try row(whole)
        #expect(values[15] > values[200], "the stroke is in: red painted at the left")
        #expect(Set(values[64...]).count > 150, "and the rest keeps its fine steps")
        let project = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".comp")
        defer { try? FileManager.default.removeItem(at: project) }
        try await ProjectStore.shared.save(try #require(session.projectSnapshot()), to: project)
        let reopened = try #require(try await ProjectStore.shared.load(from: project).images[id]?.deep)
        #expect(try row(reopened) == values, "saved whole, at 16 bits")
    }

    @Test func invertKeepsSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let before = try row(try #require(session.activeLayer?.asset?.deep))
        await session.invertPixels()
        let after = try row(try #require(session.activeLayer?.asset?.deep, "Invert kept the layer 16-bit"))
        #expect(Set(after).count > 200)
        #expect(abs(after[128] - (65535 - before[128])) < 257, "inverted: \(after[128]) from \(before[128])")
    }

    /// Delete inside a selection (like Fill, Gradient and Move Pixels) commits through `BrushCommit`: the layer stays
    /// 16-bit and the rest keeps its steps.
    @Test func clearingASelectionKeepsSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.setSelection(DocumentSelection(path: CGPath(rect: CGRect(x: 0, y: 0, width: 32, height: Self.height), transform: nil),
                                               antialiased: false, feather: 0), name: "Left")
        await session.clearSelectedPixels()
        let whole = try #require(try session.activeLayer?.asset.flatMap { try DeepLayer.flattened($0) })
        let values = try row(whole)
        #expect(whole.width == Self.width - 32, "the cleared edge is trimmed away")
        #expect(Set(values).count > 150, "the rest keeps its fine steps")
    }

    /// Cmd-T on a selection lifts it into a floating layer and drops it back: both stay 16-bit.
    @Test func floatingSelectionsKeepSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let source = try #require(session.activeLayer?.id)
        session.setSelection(DocumentSelection(path: CGPath(rect: CGRect(x: 64, y: 0, width: 128, height: Self.height), transform: nil),
                                               antialiased: false, feather: 0), name: "Middle")
        await session.beginSelectionTransform()
        #expect(session.activeLayer?.asset?.deep != nil, "the floating selection is 16-bit")
        session.commitTransform()
        let layer = try #require(session.document?.layers.first { $0.id == source })
        let whole = try #require(try layer.asset.flatMap { try DeepLayer.flattened($0) }, "dropped back into a 16-bit layer")
        #expect(Set(try row(whole)[64..<192]).count > 100, "the moved pixels kept their fine steps")
    }

    @Test func mergingKeepsSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.addBlankLayer()
        session.selectTool(.brush)
        session.brushSettings = BrushSettings(diameter: 4, hardness: 1, red: 1, green: 0, blue: 0)
        session.beginBrush(at: CGPoint(x: 10, y: 4))
        session.continueBrush(at: CGPoint(x: 14, y: 4))
        await session.finishBrush()
        session.mergeLayers()
        #expect(session.document?.layers.count == 1)
        let deep = try #require(session.activeLayer?.asset?.deep, "the merged layer is 16-bit")
        #expect(Set(try row(deep)[64...]).count > 150, "and keeps the 16-bit layer's fine steps")
    }

    @Test func distortKeepsSixteenBits() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.selectTool(.move)
        session.beginTransform(persistent: false)
        session.beginDistort()
        let w = CGFloat(Self.width), h = CGFloat(Self.height)
        session.previewCorners([CGPoint(x: 0, y: 0), CGPoint(x: w, y: 0), CGPoint(x: w - 20, y: h), CGPoint(x: 20, y: h)])
        session.commitTransform()
        let deep = try #require(session.activeLayer?.asset?.deep, "the distorted layer is 16-bit")
        #expect(Set(try row(deep, 0)).count > 150)
    }

    /// The share of a row's pixels between `from` and `to` holding values 8 bits can't (not a multiple of 257).
    private func fineShare(_ values: [Int], _ from: Int, _ to: Int) -> Double {
        let part = values[from..<to]
        return Double(part.filter { $0 % 257 != 0 }.count) / Double(part.count)
    }

    /// Liquify, Smudge and the Blur tool paint at 16 bits into a 16-bit layer, so where they go stays smooth: at 8 bits
    /// every pixel they touched would be a whole 8-bit step (and a smooth ramp would band).
    @Test(arguments: [BlurToolMode.liquify, .smudge, .blur])
    func blurToolModesKeepSixteenBits(mode: BlurToolMode) async throws {
        guard GPUCanvasRenderer.shared != nil || mode == .blur else { return }
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.selectTool(.blur)
        session.blurMode = mode
        session.brushSettings = BrushSettings(diameter: 8, hardness: 0.5, red: 0, green: 0, blue: 0)
        session.beginBrush(at: CGPoint(x: 80, y: 4))
        for x in stride(from: 84.0, through: 170, by: 4) { session.continueBrush(at: CGPoint(x: x, y: 4)) }
        await session.finishBrush()
        let asset = try #require(session.activeLayer?.asset)
        let deep = try #require(try DeepLayer.flattened(asset), "\(mode) kept the layer 16-bit")
        let share = fineShare(try row(deep), 90, 160)
        #expect(share > 0.8, "\(mode): \(Int(share * 100))% of the stroke's pixels finer than 8 bits")
    }

    /// Dither's result is a few levels by design; read between three runs it came out in colors. It rasterizes.
    @Test func ditherRasterizes() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.beginFilter(.dither)
        session.updateFilter(FilterSettings(), preview: true)
        await session.commitFilter()
        #expect(session.activeLayer?.asset?.deep == nil)
    }

    /// An adjustment layer over a 16-bit layer, on its own or clipped to it, works at 16 bits in a 16-bit export: a
    /// steep Levels comes out a smooth ramp, not bands.
    @Test(arguments: [false, true])
    func adjustmentLayersExportAtSixteenBits(clipped: Bool) async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        session.addAdjustment(.levels)
        let id = try #require(session.activeLayerID)
        var adjustment = try #require(session.activeLayer?.adjustment)
        adjustment.levels.ranges[0].black = 100
        adjustment.levels.ranges[0].white = 104
        session.updateAdjustment(id, value: adjustment)
        session.adjustmentEditingID = nil
        if clipped { session.toggleClippingMask(id) }
        #expect((session.activeLayer?.maskSourceID != nil) == clipped)
        let snapshot = try #require(session.projectSnapshot())
        let values = try row(try await ImageExporter.shared.render(snapshot, sixteenBit: true).image)
        #expect(Set(values).count > 150, "\(Set(values).count) distinct values")
        #expect(values.first! < 3 * 257 && values.last! > 65535 - 3 * 257)
    }

    /// A version-11 project can't carry 16-bit pixels: older builds would misread them.
    @Test func olderVersionsCannotHoldSixteenBitImages() async throws {
        let (session, url) = try await importedSession()
        defer { try? FileManager.default.removeItem(at: url) }
        let project = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".comp")
        defer { try? FileManager.default.removeItem(at: project) }
        try await ProjectStore.shared.save(try #require(session.projectSnapshot()), to: project)
        let manifest = project.appendingPathComponent("manifest.json")
        let text = try String(contentsOf: manifest, encoding: .utf8).replacingOccurrences(of: "\"version\" : 12", with: "\"version\" : 11")
        try text.write(to: manifest, atomically: true, encoding: .utf8)
        await #expect(throws: (any Error).self) { try await ProjectStore.shared.load(from: project) }
    }
}
