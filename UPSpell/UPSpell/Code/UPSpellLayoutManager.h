//
//  UPSpellLayoutManager.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import <UpKit/UPMacros.h>

#if __cplusplus

#import <vector>

namespace UP {

class SpellLayoutManager {
public:
    enum class AspectMode {
        Canonical,
        WiderThanCanonical,
        TallerThanCanonical
    };

    static constexpr CGFloat CanonicalCanvasWidth = 1000;
    static constexpr CGFloat CanonicalCanvasHeight = 500;
    static constexpr CGSize CanonicalCanvasSize = { CanonicalCanvasWidth, CanonicalCanvasHeight };
    static constexpr CGFloat CanonicalAspectRatio = CanonicalCanvasWidth / CanonicalCanvasHeight;

    static inline constexpr CGRect CanonicalControlsLayoutFrame = {   92,  22, 816,  84 };
    static inline constexpr CGRect CanonicalWordTrayFrame =       { 62.5, 133, 875, 182 };
    static inline constexpr CGRect CanonicalTilesLayoutFrame =    {  105, 350, 790, 116 };

    static inline constexpr CGSize CanonicalRoundControlButtonSize = { 84, 84 };
    static inline constexpr CGRect CanonicalRoundControlButtonPauseFrame = { 0, 0, 84, 84 };

    SpellLayoutManager() {}

    void set_canvas_frame(const CGRect &canvas_frame);
    CGRect canvas_frame() const { return m_canvas_frame; }
    
    AspectMode aspect_mode() const { return m_aspect_mode; }
    CGFloat aspect_ratio() const { return m_aspect_ratio; }
    CGFloat aspect_scale() const { return m_aspect_scale; }

    UIEdgeInsets letterbox_insets() const { return m_letterbox_insets; }
    CGRect layout_frame() const { return m_layout_frame; }
    CGFloat layout_scale() const { return m_layout_scale; }

    CGRect controls_layout_frame() const { return m_controls_layout_frame; }
    CGRect word_tray_layout_frame() const { return m_word_tray_layout_frame; }
    CGRect tiles_layout_frame() const { return m_tiles_layout_frame; }

    CGRect controls_button_pause_layout_frame() const { return m_controls_button_pause_layout_frame; }


private:
    void set_aspect_mode(AspectMode aspect_mode) { m_aspect_mode = aspect_mode; }
    void set_aspect_ratio(CGFloat aspect_ratio) { m_aspect_ratio = aspect_ratio; }
    void set_aspect_scale(CGFloat aspect_scale) { m_aspect_scale = aspect_scale; }
    void set_letterbox_insets(UIEdgeInsets letterbox_insets) { m_letterbox_insets = letterbox_insets; }
    void set_layout_frame(CGRect layout_frame) { m_layout_frame = layout_frame; }
    void set_layout_scale(CGFloat layout_scale) { m_layout_scale = layout_scale; }
    void set_controls_layout_frame(CGRect controls_layout_frame) { m_controls_layout_frame = controls_layout_frame; }
    void set_word_tray_layout_frame(CGRect word_tray_layout_frame) { m_word_tray_layout_frame = word_tray_layout_frame; }
    void set_tiles_layout_frame(CGRect tiles_layout_frame) { m_tiles_layout_frame = tiles_layout_frame; }
    void set_controls_button_pause_layout_frame(CGRect controls_button_pause_layout_frame) {
        m_controls_button_pause_layout_frame = controls_button_pause_layout_frame;
    }

    void calculate();
    void calculate_controls_layout_frame();
    void calculate_word_tray_layout_frame();
    void calculate_tiles_layout_frame();
    void calculate_controls_button_pause_layout_frame();

    AspectMode m_aspect_mode = AspectMode::Canonical;
    CGFloat m_aspect_ratio = CanonicalAspectRatio;
    CGFloat m_aspect_scale = 1.0;
    CGRect m_canvas_frame = CGRectZero;
    CGRect m_layout_frame = CGRectZero;
    CGFloat m_layout_scale = 1.0;
    UIEdgeInsets m_letterbox_insets = UIEdgeInsetsZero;
    
    CGRect m_controls_layout_frame = CGRectZero;
    CGRect m_word_tray_layout_frame = CGRectZero;
    CGRect m_tiles_layout_frame = CGRectZero;

    CGRect m_controls_button_pause_layout_frame = CGRectZero;
};

}  // namespace UP

#endif  // __cplusplus
