#include "DeepPixels.h"
#include <dispatch/dispatch.h>
#include <math.h>
#include <stdlib.h>

// Runs `body` over rows split into a few bands a core, all at once.
static void deep_rows(size_t height, void (^body)(size_t first, size_t last)) {
    size_t bands = height < 64 ? 1 : 32, size = (height + bands - 1) / bands;
    dispatch_apply(bands, DISPATCH_APPLY_AUTO, ^(size_t band) {
        size_t first = band * size, last = first + size < height ? first + size : height;
        if (first < last) body(first, last);
    });
}

static inline long deep_alpha8(uint16_t alpha) { return lroundf((float)alpha * (255.0f / 65535.0f)); }

// A channel's 8-bit value rounded down, kept within the pixel's alpha (premultiplied colors never pass it).
static inline long deep_down(uint16_t value, long alpha) {
    long down = (long)floorf((float)value * (255.0f / 65535.0f));
    return down > alpha ? alpha : down;
}

void deep_split(const uint16_t *deep, size_t deepStride, uint8_t *out, size_t stride, size_t width, size_t height,
                int step) {
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            const uint16_t *in = (const uint16_t *)((const uint8_t *)deep + y * deepStride);
            uint8_t *o = out + y * stride;
            for (size_t x = 0; x < width; ++x) {
                const uint16_t *p = in + x * 4;
                long alpha = deep_alpha8(p[3]);
                for (int c = 0; c < 3; ++c) {
                    long value = deep_down(p[c], alpha) + step;
                    o[x * 4 + c] = (uint8_t)(value > alpha ? alpha : value);
                }
                o[x * 4 + 3] = (uint8_t)alpha;
            }
        }
    });
}

void deep_merge(const uint16_t *deep, size_t deepStride, const uint8_t *lowResult, const uint8_t *nearResult,
                const uint8_t *farResult, size_t stride, uint16_t *out, size_t outStride, size_t width, size_t height) {
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            const uint16_t *in = (const uint16_t *)((const uint8_t *)deep + y * deepStride);
            const uint8_t *lo = lowResult + y * stride, *ne = nearResult + y * stride, *fa = farResult + y * stride;
            uint16_t *o = (uint16_t *)((uint8_t *)out + y * outStride);
            for (size_t x = 0; x < width; ++x) {
                const uint16_t *p = in + x * 4;
                long alpha = deep_alpha8(p[3]);
                float outAlpha = (float)lo[x * 4 + 3] * 257.0f;
                for (int c = 0; c < 3; ++c) {
                    long down = deep_down(p[c], alpha);
                    // How far past `low` the color is, in 8-bit steps (under one), and the real gaps to `near` and
                    // `far`, which alpha may have shortened.
                    float past = fminf(1, fmaxf(0, (float)p[c] * (255.0f / 65535.0f) - (float)down));
                    long nearGap = (down + 1 > alpha ? alpha : down + 1) - down;
                    long farGap = (down + 4 > alpha ? alpha : down + 4) - down;
                    float l = lo[x * 4 + c], change = (float)ne[x * 4 + c] - l;
                    float value = l;
                    if (nearGap > 0 && (fabsf(change) >= 2 || farGap == nearGap)) value = l + change * past;
                    else if (farGap > 0) value = l + ((float)fa[x * 4 + c] - l) / (float)farGap * past;
                    float scaled = value * 257.0f;
                    o[x * 4 + c] = (uint16_t)lroundf(scaled < 0 ? 0 : scaled > outAlpha ? outAlpha : scaled);
                }
                o[x * 4 + 3] = (uint16_t)lroundf(outAlpha);
            }
        }
    });
}

void deep_take_painted(uint16_t *deep, size_t deepStride, const uint8_t *painted, const uint8_t *base, size_t stride,
                       size_t width, size_t height) {
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            uint16_t *d = (uint16_t *)((uint8_t *)deep + y * deepStride);
            const uint8_t *p = painted + y * stride, *b = base + y * stride;
            for (size_t x = 0; x < width * 4; x += 4) {
                if (p[x] == b[x] && p[x + 1] == b[x + 1] && p[x + 2] == b[x + 2] && p[x + 3] == b[x + 3]) continue;
                for (int c = 0; c < 4; ++c) d[x + c] = (uint16_t)(p[x + c] * 257);
            }
        }
    });
}

void deep_extract_alpha(uint16_t *rgba, size_t stride, uint16_t *alpha, size_t width, size_t height) {
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            uint16_t *p = (uint16_t *)((uint8_t *)rgba + y * stride);
            for (size_t x = 0; x < width; ++x, p += 4) {
                uint32_t a = p[3];
                alpha[y * width + x] = (uint16_t)a;
                for (int c = 0; c < 3; ++c) {
                    uint32_t v = a ? (p[c] * 65535u + a / 2) / a : 0;
                    p[c] = (uint16_t)(v > 65535 ? 65535 : v);
                }
                p[3] = 65535;
            }
        }
    });
}

void deep_restore_alpha(uint16_t *rgba, size_t stride, const uint16_t *alpha, size_t width, size_t height) {
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            uint16_t *p = (uint16_t *)((uint8_t *)rgba + y * stride);
            for (size_t x = 0; x < width; ++x, p += 4) {
                uint32_t a = alpha[y * width + x];
                for (int c = 0; c < 3; ++c) p[c] = (uint16_t)((p[c] * a + 32767u) / 65535u);
                p[3] = (uint16_t)a;
            }
        }
    });
}

void deep_cube_apply(uint16_t *pixels, size_t stride, size_t width, size_t height, const float *cube, int dimension) {
    const float scale = (dimension - 1) / 65535.0f;
    const size_t dy = dimension, dz = (size_t)dimension * dimension;
    const size_t sx = 4, sy = dy * 4, sz = dz * 4;
    deep_rows(height, ^(size_t first, size_t last) {
        for (size_t y = first; y < last; ++y) {
            uint16_t *p = (uint16_t *)((uint8_t *)pixels + y * stride);
            for (size_t x = 0; x < width; ++x, p += 4) {
                float alpha = p[3];
                if (!alpha) continue;
                float fraction[3];
                int lo[3];
                for (int channel = 0; channel < 3; ++channel) {
                    float position = fminf(65535, p[channel] * 65535.0f / alpha) * scale;
                    lo[channel] = (int)position;
                    if (lo[channel] > dimension - 2) lo[channel] = dimension - 2;
                    fraction[channel] = position - lo[channel];
                }
                const float *base = cube + ((size_t)lo[0] + lo[1] * dy + lo[2] * dz) * 4;
                for (int channel = 0; channel < 3; ++channel) {
                    const float *c = base + channel;
                    float x00 = c[0] + (c[sx] - c[0]) * fraction[0];
                    float x10 = c[sy] + (c[sy + sx] - c[sy]) * fraction[0];
                    float x01 = c[sz] + (c[sz + sx] - c[sz]) * fraction[0];
                    float x11 = c[sz + sy] + (c[sz + sy + sx] - c[sz + sy]) * fraction[0];
                    float y0 = x00 + (x10 - x00) * fraction[1];
                    float y1 = x01 + (x11 - x01) * fraction[1];
                    float result = y0 + (y1 - y0) * fraction[2];
                    p[channel] = (uint16_t)fminf(alpha, fmaxf(0, roundf(result * alpha)));
                }
            }
        }
    });
}
