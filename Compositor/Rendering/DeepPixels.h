#ifndef DeepPixels_h
#define DeepPixels_h
#include <stdint.h>
#include <stddef.h>
// 16-bit layers kept through 8-bit operations. A 16-bit color sits just above an 8-bit value, `low` (rounded down).
// An 8-bit operation is run on `low`, on `low` one step up (`near`) and on `low` four steps up (`far`), and the result
// at 16 bits is read off between them, by where the color fell past `low`:
//
// - where one step changes the result by two or more (the operation stretches tones there), between `low` and `near`:
//   exact wherever the operation is straight across one step, which is nearly everywhere, sharp bends included;
// - where it changes it by one or nothing (the operation holds or compresses tones there), its results being 8-bit
//   too say too little across one step, so the slope is read across four instead: to a quarter step, and those runs
//   don't come out flat.
//
// All buffers are premultiplied RGBA. 16-bit ones are native-endian uint16, 4 a pixel; 8-bit ones are 4 bytes a
// pixel. Strides are in bytes. Alpha is carried at 8 bits (it's coverage), so all three inputs share it.

// The 8-bit image `step` steps above a 16-bit one's rounded-down value (0 for `low` itself), kept within alpha.
void deep_split(const uint16_t *deep, size_t deepStride, uint8_t *out, size_t stride, size_t width, size_t height,
                int step);

// The 16-bit result from an operation's results on the three inputs (`deep_split` with steps 0, 1 and 4).
void deep_merge(const uint16_t *deep, size_t deepStride, const uint8_t *lowResult, const uint8_t *nearResult,
                const uint8_t *farResult, size_t stride, uint16_t *out, size_t outStride, size_t width, size_t height);

// A painted 16-bit layer made whole: where its 8-bit pixels (`painted`, the base with the strokes over it) differ from
// its 8-bit base alone (`base`), paint went there and its value is taken; elsewhere the 16-bit pixels in `deep` stay.
// The strokes' patches are whole tiles, untouched pixels included, so laying them over the 16-bit pixels outright
// would round everything they cover back to 8 bits.
void deep_take_painted(uint16_t *deep, size_t deepStride, const uint8_t *painted, const uint8_t *base, size_t stride,
                       size_t width, size_t height);

// A clipping stack's surface at 16 bits, as `layer_extract_alpha` and `layer_unpremultiply_opaque` do at 8: saves each
// pixel's alpha into `alpha` (`width` values a row) and makes the colors opaque, so the layers clipped to it blend at
// full coverage; `deep_restore_alpha` puts the alpha back.
void deep_extract_alpha(uint16_t *rgba, size_t stride, uint16_t *alpha, size_t width, size_t height);
void deep_restore_alpha(uint16_t *rgba, size_t stride, const uint16_t *alpha, size_t width, size_t height);

// A color lookup at 16 bits, as `cube_apply` at 8: `cube` is `dimension`³ RGBA floats, red fastest, as Core Image's
// color cube. Operations whose channels mix (Hue/Saturation, Black & White) go this way rather than through the three
// runs, which read each channel's result off that channel's own input alone.
void deep_cube_apply(uint16_t *pixels, size_t stride, size_t width, size_t height, const float *cube, int dimension);
#endif
