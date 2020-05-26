//
//  UPSpellLayout.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import <UpKit/UPFontMetrics.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMacros.h>

#import "UPSpellModel.h"
#import "UPSpellTypes.h"

#if __cplusplus

#import <array>
#import <unordered_map>

namespace UP {

using TilePointArray = std::array<CGPoint, UP::TileCount>;
using TileRectArray = std::array<CGRect, UP::TileCount>;

class SpellLayout {
public:
    enum class AspectMode {
        Canonical,
        WiderThanCanonical,
        TallerThanCanonical
    };

    static constexpr CGFloat CanonicalCanvasWidth = 1000;
    static constexpr CGFloat CanonicalCanvasMidX = CanonicalCanvasWidth / 2;
    static constexpr CGFloat CanonicalCanvasHeight = 500;
    static constexpr CGSize CanonicalCanvasSize = { CanonicalCanvasWidth, CanonicalCanvasHeight };
    static constexpr CGFloat CanonicalAspectRatio = CanonicalCanvasWidth / CanonicalCanvasHeight;

    static inline constexpr CGSize CanonicalRoundControlButtonSize = { 84, 84 };

    static inline constexpr CGFloat CanonicalGameInformationCapHeight = 57;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptCapHeight = 39;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptBaselineAdjustment = 27;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptKerning = 1;
    static inline constexpr CGFloat CanonicalGameTimeLabelWidth =  180;
    static inline constexpr CGPoint CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC =  { -30, 91.7 };
    static inline constexpr CGPoint CanonicalGameScoreLabelRightAlignedBaselinePointRelativeToTDC = {  30, 91.7 };
    static inline constexpr CGFloat CanonicalGameScoreLabelWidth =  175;

    static inline constexpr CGSize CanonicalTileSize = { 100, 120 };
    static inline constexpr CGRect CanonicalTileFrame = { 0, 0, up_size_width(CanonicalTileSize), up_size_height(CanonicalTileSize) };
    static inline constexpr CGFloat CanonicalTileStrokeWidth = 3;
    static inline constexpr CGFloat CanonicalTileGap = 15;
    static inline constexpr CGFloat CanonicalTilesLayoutWidth = up_size_width(CanonicalTileSize) * 7 + (CanonicalTileGap * 6);

    static inline constexpr CGRect CanonicalControlsLayoutFrame = {   92,  22, 816,  84 };
    static inline constexpr CGRect CanonicalWordTrayFrame =       { 62.5, 133, 875, 182 };
    static inline constexpr CGRect CanonicalWordTrayMaskFrame =   { 62.5, 143, 875, 420 };
    static inline constexpr CGRect CanonicalTilesLayoutFrame =    {    0, 348, CanonicalTilesLayoutWidth, 120 };

    static inline constexpr CGFloat CanonicalWordTrayMaskXOffset = 10;
    static inline constexpr CGFloat CanonicalWordTrayShakeAmount = 30;

    static SpellLayout &create_instance() {
        g_instance = new SpellLayout();
        return *g_instance;
    }

    static SpellLayout &instance() {
        return *g_instance;
    }

    void calculate();

    void set_screen_bounds(CGRect screen_bounds) { m_screen_bounds = screen_bounds; }
    CGRect screen_bounds() const { return m_screen_bounds; }

    void set_screen_scale(CGFloat screen_scale) { m_screen_scale = screen_scale; }
    CGFloat screen_scale() const { return m_screen_scale; }

    void set_canvas_frame(CGRect canvas_frame) { m_canvas_frame = canvas_frame; }
    CGRect canvas_frame() const { return m_canvas_frame; }
    
    AspectMode aspect_mode() const { return m_aspect_mode; }
    CGFloat aspect_ratio() const { return m_aspect_ratio; }
    CGFloat aspect_scale() const { return m_aspect_scale; }

    UIEdgeInsets letterbox_insets() const { return m_letterbox_insets; }
    CGRect layout_frame() const { return m_layout_frame; }
    CGFloat layout_scale() const { return m_layout_scale; }

    CGRect controls_layout_frame() const { return m_controls_layout_frame; }
    CGRect word_tray_layout_frame() const { return m_word_tray_layout_frame; }
    CGRect player_tray_layout_frame() const { return m_player_tray_layout_frame; }

    CGRect word_tray_mask_frame() const { return m_word_tray_mask_frame; }

    CGSize tile_size() const { return m_tile_size; }
    CGFloat tile_stroke_width() const { return m_tile_stroke_width; }
    UIBezierPath *tile_stroke_path() const { return m_tile_stroke_path; }

    CGFloat word_tray_shake_amount() const { return m_word_tray_shake_amount; }

    CGRect controls_button_pause_frame() const { return m_controls_button_pause_frame; }
    CGRect controls_button_trash_frame() const { return m_controls_button_trash_frame; }

    const FontMetrics &game_information_font_metrics() const { return m_game_information_font_metrics; }
    const FontMetrics &game_information_superscript_font_metrics() const { return m_game_information_superscript_font_metrics; }
    CGRect game_time_label_frame() const { return m_game_time_label_frame; }
    CGRect game_score_label_frame() const { return m_game_score_label_frame; }

    const TileRectArray &player_tray_tile_frames() const { return m_player_tray_tile_frames; }
    const TilePointArray &player_tray_tile_centers() const { return m_player_tray_tile_centers; }

    const TileRectArray &word_tray_tile_frames(size_t word_length) const {
        ASSERT(word_length > 0);
        ASSERT_IDX_END(word_length);
        return m_word_tray_tile_frames[word_length - 1];
    }
    const TilePointArray &word_tray_tile_centers(size_t word_length) const {
        ASSERT(word_length > 0);
        ASSERT_IDX_END(word_length);
        return m_word_tray_tile_centers[word_length - 1];
    }

    const TileRectArray &prefill_tile_frames() const { return m_prefill_tile_frames; }
    const TilePointArray &prefill_tile_centers() const { return m_prefill_tile_centers; }

    const TileRectArray &score_tile_frames() const { return m_score_tile_frames; }
    const TilePointArray &score_tile_centers() const { return m_score_tile_centers; }

private:
    SpellLayout() {}

    UP_STATIC_INLINE SpellLayout *g_instance;
    
    void set_aspect_mode(AspectMode aspect_mode) { m_aspect_mode = aspect_mode; }
    void set_aspect_ratio(CGFloat aspect_ratio) { m_aspect_ratio = aspect_ratio; }
    void set_aspect_scale(CGFloat aspect_scale) { m_aspect_scale = aspect_scale; }
    void set_letterbox_insets(UIEdgeInsets letterbox_insets) { m_letterbox_insets = letterbox_insets; }
    void set_layout_frame(CGRect layout_frame) { m_layout_frame = layout_frame; }
    void set_layout_scale(CGFloat layout_scale) { m_layout_scale = layout_scale; }
    void set_controls_layout_frame(CGRect controls_layout_frame) { m_controls_layout_frame = controls_layout_frame; }
    void set_word_tray_layout_frame(CGRect word_tray_layout_frame) { m_word_tray_layout_frame = word_tray_layout_frame; }
    void set_word_tray_mask_frame(CGRect word_tray_mask_frame) { m_word_tray_mask_frame = word_tray_mask_frame; }
    void set_player_tray_layout_frame(CGRect player_tray_layout_frame) { m_player_tray_layout_frame = player_tray_layout_frame; }
    void set_tile_size(CGSize tile_size) { m_tile_size = tile_size; }
    void set_tile_stroke_width(CGFloat tile_stroke_width) { m_tile_stroke_width = tile_stroke_width; }
    void set_word_tray_shake_amount(CGFloat word_tray_shake_amount) { m_word_tray_shake_amount = word_tray_shake_amount; }
    void set_controls_button_pause_frame(CGRect controls_button_pause_frame) {
        m_controls_button_pause_frame = controls_button_pause_frame;
    }
    void set_controls_button_trash_frame(CGRect controls_button_trash_frame) {
        m_controls_button_trash_frame = controls_button_trash_frame;
    }
    void set_game_information_font_metrics(const FontMetrics &game_information_font_metrics) {
        m_game_information_font_metrics = game_information_font_metrics;
    }
    void set_game_information_superscript_font_metrics(const FontMetrics &game_information_superscript_font_metrics) {
        m_game_information_superscript_font_metrics = game_information_superscript_font_metrics;
    }
    void set_game_time_label_frame(CGRect game_time_label_frame) {
        m_game_time_label_frame = game_time_label_frame;
    }
    void set_game_score_label_frame(CGRect game_score_label_frame) {
        m_game_score_label_frame = game_score_label_frame;
    }

    void calculate_controls_layout_frame();
    void calculate_word_tray_layout_frame();
    void calculate_player_tray_layout_frame();
    void calculate_tile_size();
    void calculate_tile_stroke_width();
    void calculate_word_tray_mask_frame();
    void calculate_word_tray_shake_amount();
    void calculate_word_tray_tile_frames();
    void calculate_player_tray_tile_frames();
    void calculate_prefill_tile_frames();
    void calculate_score_tile_frames();
    void calculate_controls_button_pause_frame();
    void calculate_controls_button_trash_frame();
    void calculate_game_information_font_metrics();
    void calculate_game_information_superscript_font_metrics();
    void calculate_game_time_label_frame();
    void calculate_game_score_label_frame();

    CGRect m_screen_bounds = CGRectZero;
    CGFloat m_screen_scale = 2.0;
    AspectMode m_aspect_mode = AspectMode::Canonical;
    CGFloat m_aspect_ratio = CanonicalAspectRatio;
    CGFloat m_aspect_scale = 1.0;

    CGRect m_canvas_frame = CGRectZero;
    CGRect m_layout_frame = CGRectZero;
    CGFloat m_layout_scale = 1.0;
    UIEdgeInsets m_letterbox_insets = UIEdgeInsetsZero;

    CGRect m_controls_layout_frame = CGRectZero;
    CGRect m_word_tray_layout_frame = CGRectZero;
    CGRect m_player_tray_layout_frame = CGRectZero;

    CGRect m_word_tray_mask_frame = CGRectZero;

    CGSize m_tile_size;
    CGFloat m_tile_stroke_width = 0.0;
    UIBezierPath *m_tile_stroke_path = nil;

    CGFloat m_word_tray_shake_amount;

    CGRect m_controls_button_pause_frame = CGRectZero;
    CGRect m_controls_button_trash_frame = CGRectZero;

    FontMetrics m_game_information_font_metrics;
    FontMetrics m_game_information_superscript_font_metrics;

    CGRect m_game_time_label_frame = CGRectZero;
    CGRect m_game_score_label_frame = CGRectZero;

    TileRectArray m_player_tray_tile_frames;
    TilePointArray m_player_tray_tile_centers;
    std::array<TileRectArray, TileCount> m_word_tray_tile_frames;
    std::array<TilePointArray, TileCount> m_word_tray_tile_centers;
    TileRectArray m_prefill_tile_frames;
    TilePointArray m_prefill_tile_centers;
    TileRectArray m_score_tile_frames;
    TilePointArray m_score_tile_centers;
};

}  // namespace UP

#endif  // __cplusplus
