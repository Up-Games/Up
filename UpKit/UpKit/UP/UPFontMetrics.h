//
//  UPFontMetrics.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_FONT_METRICS_H
#define UP_FONT_METRICS_H

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

#import <UPKit/UPMacros.h>
#import <UPKit/UPStringTools.h>

#if __cplusplus

#import <string>
#import <string_view>

namespace UP {

class FontMetrics {
public:
    FontMetrics() {}
    FontMetrics(NSString *fontName, CGFloat point_size = 1) {
        UIFont *font = [UIFont fontWithName:fontName size:point_size];
        if (!font) {
            return;
        }
        m_font_name = cpp_str(fontName);
        m_point_size = point_size;
        m_ascender = font.ascender;
        m_descender = font.descender;
        m_cap_height = font.capHeight;
        m_x_height = font.xHeight;
        m_line_height = font.lineHeight;
    }

    std::string font_name() const { return m_font_name; }
    std::string_view font_name_view() const { return std::string_view(m_font_name); }

    CGFloat point_size() const { return m_point_size; }
    CGFloat ascender() const { return m_ascender; }
    CGFloat descender() const { return m_descender; }
    CGFloat cap_height() const { return m_cap_height; }
    CGFloat x_height() const { return m_x_height; }
    CGFloat line_height() const { return m_line_height; }

private:
    std::string m_font_name;
    CGFloat m_point_size = 0;
    CGFloat m_ascender = 0;
    CGFloat m_descender = 0;
    CGFloat m_cap_height = 0;
    CGFloat m_x_height = 0;
    CGFloat m_line_height = 0;
};

UP_STATIC_INLINE bool operator==(const FontMetrics &a, const FontMetrics &b) {
    return a.font_name_view() == b.font_name_view();
}

UP_STATIC_INLINE bool operator!=(const FontMetrics &a, const FontMetrics &b) {
    return !(a == b);
}

UP_STATIC_INLINE bool operator<(const FontMetrics &a, const FontMetrics &b) {
    return a.font_name_view() < b.font_name_view();
}

}  // namespace UP

namespace std {
    template<> struct hash<UP::FontMetrics> {
        std::size_t operator()(const UP::FontMetrics &m) const noexcept {
            return std::hash<std::string_view>{}(m.font_name_view());
        }
    };
}  // namespace std

#endif  // __cplusplus

#endif  // UP_FONT_METRICS_H
