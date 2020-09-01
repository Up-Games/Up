//
//  UPColor.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#include <UpKit/UPMath.h>
#include <UpKit/UPTypes.h>

namespace UP {

class HSVF;
class RGBF;

UP_STATIC_CONST UPUnit UPUnitRecip255 = 1.0 / 255.0;
UP_STATIC_CONST UPUnit up_from_255(uint8_t _u) { return _u * UPUnitRecip255; }
UP_STATIC_CONST uint8_t up_to_255(UPUnit _u) { return static_cast<uint8_t>(_u * 255); }

class Color8 {
public:
    constexpr Color8() {}
    constexpr Color8(uint32_t pixel) : m_pixel(pixel) {}
    constexpr Color8(uint8_t ch1, uint8_t ch2, uint8_t ch3, uint8_t ch4) : m_pixel(pack_pixel(ch1, ch2, ch3, ch4)) {}
    
    static constexpr uint8_t mask_channel_1(uint32_t pixel) {
        constexpr uint32_t mask = 0x000000f;
        return uint8_t(pixel & mask);
    }
    static constexpr uint8_t mask_channel_2(uint32_t pixel) {
        constexpr uint32_t mask = 0x0000f00;
        return uint8_t((pixel & mask) >> 8);
    }
    static constexpr uint8_t mask_channel_3(uint32_t pixel) {
        constexpr uint32_t mask = 0x00f0000;
        return uint8_t((pixel & mask) >> 16);
    }
    static constexpr uint8_t mask_channel_4(uint32_t pixel) {
        constexpr uint32_t mask = 0xff000000;
        return uint8_t((pixel & mask) >> 24);
    }
    static constexpr uint32_t pack_pixel(uint8_t ch1, uint8_t ch2, uint8_t ch3, uint8_t ch4) {
        return static_cast<uint32_t>(ch1 | (ch2 << 8) | (ch3 << 16) | (ch4 << 24));
    }
    static constexpr uint32_t pack_premultiplied_pixel(uint8_t ch1, uint8_t ch2, uint8_t ch3, UPFloat alpha) {
        return static_cast<uint32_t>(up_to_255(ch1 * alpha) | (up_to_255(ch2 * alpha) << 8) | (up_to_255(ch3 * alpha) << 16) | (up_to_255(alpha) << 24));
    }
    
    uint32_t pixel() const { return m_pixel; }
    
private:
    uint32_t m_pixel = 0;
};

class RGB8 : public Color8 {
public:
    constexpr RGB8() {}
    constexpr RGB8(uint32_t pixel) : Color8(pixel) {}
    constexpr RGB8(uint8_t ch1, uint8_t ch2, uint8_t ch3, uint8_t ch4) : Color8(ch1, ch2, ch3, ch4) {}
    
    uint8_t red() const { return Color8::mask_channel_1(pixel()); }
    uint8_t green() const { return Color8::mask_channel_2(pixel()); }
    uint8_t blue() const { return Color8::mask_channel_3(pixel()); }
    uint8_t alpha() const { return Color8::mask_channel_4(pixel()); }
};

class ColorF {
public:
    constexpr ColorF() {}
    
    constexpr ColorF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) :
    m_ch1(ch1), m_ch2(ch2), m_ch3(ch3), m_ch4(ch4) {}
    
    constexpr ColorF(const Color8 &c) :
    m_ch1(up_from_255(Color8::mask_channel_1(c.pixel()))),
    m_ch2(up_from_255(Color8::mask_channel_2(c.pixel()))),
    m_ch3(up_from_255(Color8::mask_channel_3(c.pixel()))),
    m_ch4(up_from_255(Color8::mask_channel_4(c.pixel()))) {}
    
    UPFloat channel_1() const { return m_ch1; }
    UPFloat channel_2() const { return m_ch2; }
    UPFloat channel_3() const { return m_ch3; }
    UPFloat channel_4() const { return m_ch4; }
    
private:
    UPFloat m_ch1 = 0;
    UPFloat m_ch2 = 0;
    UPFloat m_ch3 = 0;
    UPFloat m_ch4 = 0;
};

class RGBF : public ColorF {
public:
    constexpr RGBF() {}
    constexpr RGBF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr RGBF(const RGB8 &c) : ColorF(c) {}
    constexpr RGBF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    static RGBF make(uint8_t r, uint8_t g, uint8_t b, UPFloat a) {
        return RGBF(up_from_255(r), up_from_255(g), up_from_255(b), a);
    }
    
    UPFloat red() const { return channel_1(); }
    UPFloat green() const { return channel_2(); }
    UPFloat blue() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

class HSLF : public ColorF {
public:
    constexpr HSLF() {}
    constexpr HSLF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr HSLF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    UPFloat hue() const { return channel_1(); }
    UPFloat saturation() const { return channel_2(); }
    UPFloat luminance() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

class HSVF : public ColorF {
public:
    constexpr HSVF() {}
    constexpr HSVF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr HSVF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    UPFloat hue() const { return channel_1(); }
    UPFloat saturation() const { return channel_2(); }
    UPFloat value() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

class LABF : public ColorF {
public:
    constexpr LABF() {}
    constexpr LABF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr LABF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    UPFloat lightness() const { return channel_1(); }
    UPFloat a_green_red() const { return channel_2(); }
    UPFloat b_blue_yellow() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

class XYZF : public ColorF {
public:
    constexpr XYZF() {}
    constexpr XYZF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr XYZF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    UPFloat x() const { return channel_1(); }
    UPFloat y() const { return channel_2(); }
    UPFloat z() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

class LCHF : public ColorF {
public:
    constexpr LCHF() {}
    constexpr LCHF(UPFloat ch1, UPFloat ch2, UPFloat ch3, UPFloat ch4) : ColorF(ch1, ch2, ch3, ch4) {}
    constexpr LCHF(const ColorF &c) : ColorF(c.channel_1(), c.channel_2(), c.channel_3(), c.channel_4()) {}
    
    UPFloat hue() const { return channel_1(); }
    UPFloat chroma() const { return channel_2(); }
    UPFloat lightness() const { return channel_3(); }
    UPFloat alpha() const { return channel_4(); }
};

static constexpr UPFloat LAB_Xn = 0.950470;
static constexpr UPFloat LAB_Yn = 1.0;
static constexpr UPFloat LAB_Zn = 1.088830;

static constexpr UPFloat LAB_t0 = 4.0 / 29.0;
static constexpr UPFloat LAB_t1 = 6.0 / 29.0;
static constexpr UPFloat LAB_t2 = 3.0 * LAB_t1 * LAB_t1;
static constexpr UPFloat LAB_t3 = LAB_t1 * LAB_t1 * LAB_t1;

UP_STATIC_CONSTEXPR UPFloat to_xyzf(UPFloat c)
{
    return (c <= 0.04045) ? (c / 12.92) : (pow((c + 0.055) / 1.055, 2.4));
}

UP_STATIC_CONSTEXPR UPFloat xyz_lab(UPFloat c)
{
    return (c > LAB_t3) ? (pow(c, 1.0 / 3.0)) : (c / LAB_t2 + LAB_t0);
}

UP_STATIC_CONSTEXPR UPFloat rgb_xyz(UPFloat c)
{
    return (c <= 0.04045) ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4);
};

UP_STATIC_CONSTEXPR XYZF to_xyzf(const RGBF &c)
{
    UPFloat r = to_xyzf(c.red());
    UPFloat g = to_xyzf(c.green());
    UPFloat b = to_xyzf(c.blue());
    UPFloat x = xyz_lab((0.4124564 * r + 0.3575761 * g + 0.1804375 * b) / LAB_Xn);
    UPFloat y = xyz_lab((0.2126729 * r + 0.7151522 * g + 0.0721750 * b) / LAB_Yn);
    UPFloat z = xyz_lab((0.0193339 * r + 0.1191920 * g + 0.9503041 * b) / LAB_Zn);
    return XYZF(x, y, z, c.alpha());
}

UP_STATIC_INLINE LABF to_labf(const RGBF &c)
{
    XYZF xyz = to_xyzf(c);
    UPFloat x = xyz.x();
    UPFloat y = xyz.y();
    UPFloat z = xyz.z();
    UPFloat l = 116.0 * y - 16.0;
    UPFloat a = 500.0 * (x - y);
    UPFloat b = 200.0 * (y - z);
    return LABF(l < 0 ? 0 : l, a, b, c.alpha());
}

UP_STATIC_INLINE LCHF to_lchf(const LABF &in_c)
{
    UPFloat l = in_c.lightness();
    UPFloat a = in_c.a_green_red();
    UPFloat b = in_c.b_blue_yellow();
    UPFloat c = sqrt(a * a + b * b);
    UPFloat h = (atan2(b, a) * RAD2DEG + 360);
    if (h > 360) {
        h -= 360;
    }
    else if (h < 0) {
        h += 360;
    }
    return LCHF(h, c, l, in_c.alpha());
}

UP_STATIC_INLINE LCHF to_lchf(const RGBF &c)
{
    return to_lchf(to_labf(c));
}

UP_STATIC_INLINE LABF to_labf(const LCHF &in_c)
{
    UPFloat h = isnan(in_c.hue()) ? 0 : in_c.hue();
    UPFloat c = in_c.chroma();
    UPFloat l = in_c.lightness();
    
    h *= DEG2RAD;
    
    return LABF(l, cos(h) * c, sin(h) * c, in_c.alpha());
}

UP_STATIC_CONSTEXPR UPFloat xyz_rgb(UPFloat c)
{
    return (c <= 0.00304 ? 12.92 * c : 1.055 * pow(c, 1.0 / 2.4) - 0.055);
}

UP_STATIC_CONSTEXPR UPFloat lab_xyz(UPFloat c)
{
    return c > LAB_t1 ? c * c * c : LAB_t2 * (c - LAB_t0);
};

UP_STATIC_INLINE RGBF to_rgbf(const LABF &c)
{
    UPFloat l = c.lightness();
    UPFloat a = c.a_green_red();
    UPFloat b = c.b_blue_yellow();
    
    UPFloat y = (l + 16) / 116.0;
    UPFloat x = isnan(a) ? y : y + a / 500.0;
    UPFloat z = isnan(b) ? y : y - b / 200.0;
    
    y = LAB_Yn * lab_xyz(y);
    x = LAB_Xn * lab_xyz(x);
    z = LAB_Zn * lab_xyz(z);
    
    UPFloat red = xyz_rgb(3.2404542 * x - 1.5371385 * y - 0.4985314 * z);
    UPFloat green = xyz_rgb(-0.9692660 * x + 1.8760108 * y + 0.0415560 * z);
    UPFloat blue = xyz_rgb(0.0556434 * x - 0.2040259 * y + 1.0572252 * z);
    
    red = UPClampUnitZeroToOne(red);
    green = UPClampUnitZeroToOne(green);
    blue = UPClampUnitZeroToOne(blue);
    
    return RGBF(red, green, blue, c.alpha());
}

UP_STATIC_INLINE RGBF to_rgbf(const LCHF &c)
{
    return to_rgbf(to_labf(c));
}

UP_STATIC_INLINE HSVF to_hsvf(const RGBF &c)
{
    UPFloat r = c.red();
    UPFloat g = c.green();
    UPFloat b = c.blue();
    UPFloat min = UPMultiMinT(UPFloat, r, g, b);
    UPFloat max = UPMultiMaxT(UPFloat, r, g, b);
    UPFloat delta = max - min;
    UPFloat h = 0;
    UPFloat s = 0;
    UPFloat v = max;
    
    if (max == 0) {
        h = nanf("q");
        s = 0;
    }
    else {
        s = delta / max;
        if (r == max) {
            h = (g - b) / delta;
        }
        else if (g == max) {
            h = 2 + (b - r) / delta;
        }
        else if (b == max) {
            h = 4 + (r - g) / delta;
        }
        h *= 60;
        if (h < 0) {
            h += 360;
        }
    }
    
    return HSVF(h, s, v, c.alpha());
}

UP_STATIC_INLINE RGBF to_rgbf(const HSVF &c)
{
    UPFloat h = c.hue();
    UPFloat s = c.saturation();
    UPFloat v = c.value();
    
    UPFloat r = 0;
    UPFloat g = 0;
    UPFloat b = 0;
    
    if (s == 0.0) {
        r = g = b = v;
    }
    else {
        if (h == 360) {
            h = 0;
        }
        else if (h > 360) {
            h -= 360;
        }
        else if (h < 0) {
            h += 360;
        }
        h /= 60;
        
        int i = (int)floor(h);
        UPFloat f = h - i;
        UPFloat p = v * (1 - s);
        UPFloat q = v * (1 - s * f);
        UPFloat t = v * (1 - s * (1 - f));
        
        switch (i) {
            case 0: {
                r = v;
                g = t;
                b = p;
                break;
            }
            case 1: {
                r = q;
                g = v;
                b = p;
                break;
            }
            case 2: {
                r = p;
                g = v;
                b = t;
                break;
            }
            case 3: {
                r = p;
                g = q;
                b = v;
                break;
            }
            case 4: {
                r = t;
                g = p;
                b = v;
                break;
            }
            case 5: {
                r = v;
                g = p;
                b = q;
                break;
            }
        }
    }
    return RGBF(r, g, b, c.alpha());
}

UP_STATIC_INLINE HSLF to_hslf(const RGBF &c) {
    UPFloat r = c.red();
    UPFloat g = c.green();
    UPFloat b = c.blue();
    UPFloat min = UPMultiMinT(UPFloat, r, g, b);
    UPFloat max = UPMultiMaxT(UPFloat, r, g, b);
    UPFloat h = 0;
    UPFloat s = 0;
    UPFloat l = (max + min) / 2;
    
    if (max == min) {
        s = 0;
        h = nanf("q");
    }
    else {
        s = l < 0.5 ? (max - min) / (max + min) : (max - min) / (2 - max - min);
    }
    
    if (r == max) {
        h = (g - b) / (max - min);
    }
    else if (g == max) {
        h = 2 + (b - r) / (max - min);
    }
    else if (b == max) {
        h = 4 + (r - g) / (max - min);
    }
    
    h *= 60;
    if (h < 0) {
        h += 360;
    }
    
    return HSLF(h, s, l, c.alpha());
}

UP_STATIC_INLINE RGBF to_rgbf(const HSLF &c)
{
    UPFloat h = isnan(c.hue()) ? 0 : c.hue();
    UPFloat s = c.saturation();
    UPFloat l = c.luminance();
    
    UPFloat r = 0;
    UPFloat g = 0;
    UPFloat b = 0;
    
    if (c.saturation() == 0) {
        r = g = b = c.luminance();
    }
    else {
        UPFloat t3[3] = { 0, 0, 0 };
        UPFloat cr[3] = { 0, 0, 0 };
        UPFloat t2 = l < 0.5 ? l * (1 + s) : l+s-l*s;
        UPFloat t1 = 2 * l - t2;
        UPFloat h_ = h / 360.0;
        t3[0] = h_ + 1.0/3.0;
        t3[1] = h_;
        t3[2] = h_ - 1.0/3.0;
        for (int i = 0; i < 3; i++) {
            if (t3[i] < 0) {
                t3[i] += 1;
            }
            if (t3[i] > 1) {
                t3[i] -= 1;
            }
            if (6 * t3[i] < 1) {
                cr[i] = t1 + (t2 - t1) * 6 * t3[i];
            }
            else if (2 * t3[i] < 1) {
                cr[i] = t2;
            }
            else if (3 * t3[i] < 2) {
                cr[i] = t1 + (t2 - t1) * ((2.0 / 3.0) - t3[i]) * 6;
            }
            else {
                cr[i] = t1;
            }
        }
        r = cr[0];
        g = cr[1];
        b = cr[2];
    }
    
    return RGBF(r, g, b, c.alpha());
}

UP_STATIC_INLINE RGB8 to_rgb8(const RGBF &c)
{
    return RGB8(up_to_255(c.red()), up_to_255(c.green()), up_to_255(c.blue()), up_to_255(c.alpha()));
}

UP_STATIC_INLINE RGB8 to_rgb8(const HSVF &c)
{
    return to_rgb8(to_rgbf(c));
}

UP_STATIC_INLINE RGB8 to_rgb8(const HSLF &c)
{
    return to_rgb8(to_rgbf(c));
}

UP_STATIC_INLINE RGB8 to_rgb8(const LCHF &c)
{
    return to_rgb8(to_rgbf(c));
}

//
// The blend functions offer a crossfade/linear interpolation that animates smoothly from one color to another.
//
UP_STATIC_INLINE UPFloat blend(UPFloat dst, UPFloat dst_alpha, UPFloat dst_fraction, UPFloat src, UPFloat src_fraction)
{
    return ((dst * dst_alpha * dst_fraction) + (src * src_fraction));
}

UP_STATIC_INLINE RGBF blend(const RGBF &dst, const RGBF &src, UPFloat src_fraction)
{
    RGBF result;
    
    if (up_is_fuzzy_zero(src_fraction)) {
        result = dst;
    }
    else if (up_is_fuzzy_one(src_fraction)) {
        result = src;
    }
    else {
        UPFloat dst_fraction = (UPUnitOne - src_fraction);
        UPFloat ra = (dst.alpha() * dst_fraction) + (src.alpha() * src_fraction);
        if (!up_is_fuzzy_zero(ra)) {
            UPFloat rr = blend(dst.red(), dst.alpha(), dst_fraction, src.red(), src_fraction);
            UPFloat rg = blend(dst.green(), dst.alpha(), dst_fraction, src.green(), src_fraction);
            UPFloat rb = blend(dst.blue(), dst.alpha(), dst_fraction, src.blue(), src_fraction);
            result = RGBF(rr, rg, rb, ra);
        }
    }
    
    return result;
}

UP_STATIC_INLINE UPFloat mix_channel(UPFloat a, UPFloat b, UPFloat fraction)
{
    return a + (fraction * (b - a));
}

UP_STATIC_INLINE RGBF mix_rgb(const RGBF &c0, const RGBF &c1, UPFloat fraction)
{
    UPFloat r = mix_channel(c0.red(), c1.red(), fraction);
    UPFloat g = mix_channel(c0.green(), c1.green(), fraction);
    UPFloat b = mix_channel(c0.blue(), c1.blue(), fraction);
    UPFloat a = mix_channel(c0.alpha(), c1.alpha(), fraction);
    return RGBF(r, g, b, a);
}

UP_STATIC_INLINE ColorF mix_hue(const ColorF &c0, const ColorF &c1, UPFloat fraction)
{
    UPFloat hue0 = c0.channel_1();
    UPFloat hue1 = c1.channel_1();
    
    UPFloat sat0 = c0.channel_2();
    UPFloat sat1 = c1.channel_2();
    
    UPFloat lbv0 = c0.channel_3();
    UPFloat lbv1 = c1.channel_3();
    
    UPFloat hue = 0;
    UPFloat sat = 0;
    UPFloat lbv = 0;
    
    bool got_sat = false;
    
    if (!isnan(hue0) && !isnan(hue1)) {
        UPFloat dh = 0;
        if (hue1 > hue0 && hue1 - hue0 > 180) {
            dh = hue1 - (hue0 + 360);
        }
        else if (hue1 < hue0 && hue0 - hue1 > 180) {
            dh = hue1 + 360 - hue0;
        }
        else {
            dh = hue1 - hue0;
        }
        hue = hue0 + fraction * dh;
    }
    else if (!isnan(hue0)) {
        hue = hue0;
        if (lbv1 == 1 || lbv1 == 0) {
            sat = sat0;
            got_sat = true;
        }
    }
    else if (!isnan(hue1)) {
        hue = hue1;
        if (lbv0 == 1 || lbv0 == 0) {
            sat = sat1;
            got_sat = true;
        }
    }
    else {
        hue = nanf("q");
    }
    
    if (!got_sat) {
        sat = sat0 + (fraction * (sat1 - sat0));
    }
    lbv = lbv0 + (fraction * (lbv1 - lbv0));
    
    UPFloat alpha = (c0.channel_4() * (1.0 - fraction) + (c1.channel_4() * fraction));
    
    return ColorF(hue, sat, lbv, alpha);
}

UP_STATIC_INLINE UPFloat mix_lightness(UPFloat color, UPFloat lightness)
{
    if (lightness < 0) {
        return mix_channel(0.0, color, lightness + 1);
    }
    else if (lightness > 0) {
        return mix_channel(color, 1.0, lightness);
    }
    else {
        return color;
    }
}

}  // namespace UP
