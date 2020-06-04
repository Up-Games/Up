//
//  UPSpellLayout.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UPFontMetrics.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMacros.h>

#import "UPSpellModel.h"

#if __cplusplus

#import <array>
#import <map>
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

    enum class Role {
        None,
        PlayerTile1, PlayerTile2, PlayerTile3, PlayerTile4, PlayerTile5, PlayerTile6, PlayerTile7,
        WordTile1, WordTile2, WordTile3, WordTile4, WordTile5, WordTile6, WordTile7,
        WordTile1of1,
        WordTile1of2, WordTile2of2,
        WordTile1of3, WordTile2of3, WordTile3of3,
        WordTile1of4, WordTile2of4, WordTile3of4, WordTile4of4,
        WordTile1of5, WordTile2of5, WordTile3of5, WordTile4of5, WordTile5of5,
        WordTile1of6, WordTile2of6, WordTile3of6, WordTile4of6, WordTile5of6, WordTile6of6,
        WordTile1of7, WordTile2of7, WordTile3of7, WordTile4of7, WordTile5of7, WordTile6of7, WordTile7of7,
        WordTray,
        GameButtonLeft, GameButtonRight, GameTimer, GameScore,
        DialogMessageHigh, DialogMessageCenter, DialogNote,
        DialogButtonTopLeft, DialogButtonTopCenter, DialogButtonTopRight,
        DialogButtonDefaultResponse, DialogButtonAlternativeResponse,
    };

    enum class Spot {
        Default,
        OffTop,
        OffBottom,
        OffLeft,
        OffRight,
        TileSubmitted,
    };

    class Location {
    public:
        constexpr Location() {}
        constexpr Location(Role role, Spot spot = Spot::Default) : m_role(role), m_spot(spot) {}
        
        Role role() const { return m_role; }
        Spot spot() const { return m_spot; }

    private:
        Role m_role = Role::None;
        Spot m_spot = Spot::Default;
    };
    
    static constexpr CGFloat CanonicalCanvasWidth = 1000;
    static constexpr CGFloat CanonicalCanvasMidX = CanonicalCanvasWidth / 2;
    static constexpr CGFloat CanonicalCanvasHeight = 500;
    static constexpr CGSize CanonicalCanvasSize = { CanonicalCanvasWidth, CanonicalCanvasHeight };
    static constexpr CGFloat CanonicalAspectRatio = CanonicalCanvasWidth / CanonicalCanvasHeight;

    static inline constexpr CGSize CanonicalRoundButtonSize = { 84, 84 };
    static inline constexpr CGSize CanonicalTextButtonSize = { 188, 75 };

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

    static inline constexpr CGFloat CanonicalWordTrayStroke =      10;
    static inline constexpr CGFloat CanonicalWordTrayMaskXOffset = 10;
    static inline constexpr CGFloat CanonicalWordTrayShakeAmount = 30;

    static inline constexpr CGRect CanonicalDialogTopButtonsLayoutFrame =      {  80,  28,  840,  85 };
    static inline constexpr CGRect CanonicalDialogResponseButtonsLayoutFrame = { 257, 350,  480,  75 };
    static inline constexpr CGRect CanonicalDialogNoteLayoutFrame =            {   0, 385, 1000,  40 };

    
    static inline constexpr CGSize CanonicalDialogTitleSize =                          {  875, 182 };
    static inline constexpr CGRect CanonicalDialogPauseButtonsLayoutFrame =  { 257, 350,  480,  75 };
    static inline constexpr CGRect CanonicalDialogOverButtonsLayoutFrame =   {  80,  28,  840,  85 };
    static inline constexpr CGRect CanonicalDialogOverNoteLayoutFrame =      {   0, 385, 1000,  40 };
    static inline constexpr CGFloat CanonicalDialogOverNoteFontCapHeight = 26;
    static inline constexpr CGFloat CanonicalMenuButtonDismissedYOffset = -CanonicalTextButtonSize.height * 2;

    static inline constexpr CGFloat CanonicalGameViewMenuScale = 0.7;
    static inline constexpr CGFloat CanonicalOffscreenFrameFactor = 1.3;

    static SpellLayout &create_instance() {
        g_instance = new SpellLayout();
        return *g_instance;
    }

    static SpellLayout &instance() {
        return *g_instance;
    }

    void calculate();

    CGRect frame_for(const Location &);
    template <class ...Args> CGRect frame_for(Args... args) { return frame_for(Location(std::forward<Args>(args)...)); }

    CGPoint center_for(const Location &);
    template <class ...Args> CGPoint center_for(Args... args) { return center_for(Location(std::forward<Args>(args)...)); }

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

    CGRect controls_layout_frame() const { return m_game_controls_layout_frame; }
    CGRect word_tray_layout_frame() const { return m_word_tray_layout_frame; }
    CGRect player_tray_layout_frame() const { return m_player_tray_layout_frame; }

    CGRect word_tray_mask_frame() const { return m_word_tray_mask_frame; }

    CGSize tile_size() const { return m_tile_size; }
    CGFloat tile_stroke_width() const { return m_tile_stroke_width; }
    UIBezierPath *tile_stroke_path() const { return m_tile_stroke_path; }
    CGRect tile_drag_barrier_frame() const { return m_tile_drag_barrier_frame; }

    UIOffset word_tray_shake_offset() const { return m_word_tray_shake_offset; }
    UIOffset word_tray_tile_offset() const { return m_word_tray_tile_offset; }

    CGRect dialog_top_buttons_layout_frame() const { return m_dialog_top_buttons_layout_frame; }
    
    
    
    
    
    
    
    
    
    
    CGRect game_controls_left_button_frame() const { return m_game_controls_left_button_frame; }
    CGRect game_controls_right_button_frame() const { return m_game_controls_right_button_frame; }
    CGSize game_controls_button_charge_size() const { return m_game_controls_button_charge_size; }

    UIFont *game_information_font() const { return m_game_information_font; }
    const FontMetrics &game_information_font_metrics() const { return m_game_information_font_metrics; }
    UIFont *game_information_superscript_font() const { return m_game_information_superscript_font; }
    const FontMetrics &game_information_superscript_font_metrics() const { return m_game_information_superscript_font_metrics; }
    CGRect game_play_time_label_frame() const { return m_game_play_time_label_frame; }
    CGRect game_play_score_label_frame() const { return m_game_play_score_label_frame; }
    CGRect calculate_game_over_score_label_frame(NSString *) const;
    UIFont *game_note_font() const { return m_game_note_font; }
    const FontMetrics &game_note_font_metrics() const { return m_game_note_font_metrics; }

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

    CGFloat score_tile_center_y() const { return m_score_tile_center_y; }
    CGFloat score_tile_spring_down_offset_y() const { return m_score_tile_spring_down_offset_y; }

    CGRect dialog_title_layout_frame() const { return m_dialog_title_layout_frame; }
    CGFloat dialog_spring_dismiss_offset_y() const { return m_dialog_spring_dismiss_offset_y; }

    CGRect dialog_pause_title_layout_frame() const { return m_dialog_pause_title_layout_frame; }
    CGRect dialog_pause_buttons_layout_frame() const { return m_dialog_pause_buttons_layout_frame; }
    CGRect dialog_pause_button_quit_frame() const { return m_dialog_pause_button_quit_frame; }
    CGRect dialog_pause_button_resume_frame() const { return m_dialog_pause_button_resume_frame; }

    CGRect dialog_over_title_layout_frame() const { return m_dialog_over_title_layout_frame; };
    CGRect dialog_over_buttons_layout_frame() const { return m_dialog_over_buttons_layout_frame; };
    CGRect dialog_over_button_left_frame() const { return m_dialog_over_button_left_frame; };
    CGRect dialog_over_button_right_frame() const { return m_dialog_over_button_right_frame; };
    CGRect dialog_over_note_label_frame() const { return m_dialog_over_note_label_frame; };

    CGRect dialog_over_interstitial_title_layout_frame() const { return m_dialog_over_interstitial_title_layout_frame; }
    CGRect dialog_over_interstitial_button_left_frame() const { return m_dialog_over_interstitial_button_left_frame; }
    CGRect dialog_over_interstitial_button_right_frame() const { return m_dialog_over_interstitial_button_right_frame; }
    CGRect dialog_over_interstitial_note_label_frame() const { return m_dialog_over_interstitial_note_label_frame; }

    CGAffineTransform menu_game_view_transform() const { return m_menu_game_view_transform; }
    CGRect menu_title_layout_frame() const { return m_menu_title_layout_frame; }
    CGRect menu_title_dismissed_layout_frame() const { return m_menu_title_dismissed_layout_frame; }
    CGRect menu_buttons_layout_frame() const { return m_menu_buttons_layout_frame; }
    CGRect menu_button_left_layout_frame() const { return m_menu_button_left_layout_frame; }
    CGRect menu_button_center_layout_frame() const { return m_menu_button_center_layout_frame; }
    CGRect menu_button_right_layout_frame() const { return m_menu_button_right_layout_frame; }
    CGRect menu_button_left_dismissed_layout_frame() const { return m_menu_button_left_dismissed_layout_frame; }
    CGRect menu_button_center_dismissed_layout_frame() const { return m_menu_button_center_dismissed_layout_frame; }
    CGRect menu_button_right_dismissed_layout_frame() const { return m_menu_button_right_dismissed_layout_frame; }

private:
    
    SpellLayout() {}

    UP_STATIC_INLINE SpellLayout *g_instance;
    
    CGRect layout_aspect_rect(CGRect);
    
    void set_aspect_mode(AspectMode aspect_mode) { m_aspect_mode = aspect_mode; }
    void set_aspect_ratio(CGFloat f) { m_aspect_ratio = f; }
    void set_aspect_scale(CGFloat f) { m_aspect_scale = f; }
    void set_letterbox_insets(UIEdgeInsets insets) { m_letterbox_insets = insets; }
    void set_layout_frame(CGRect rect) { m_layout_frame = rect; }
    void set_layout_scale(CGFloat f) { m_layout_scale = f; }
    void set_controls_layout_frame(CGRect rect) { m_game_controls_layout_frame = rect; }
    void set_word_tray_layout_frame(CGRect rect) { m_word_tray_layout_frame = rect; }
    void set_word_tray_mask_frame(CGRect rect) { m_word_tray_mask_frame = rect; }
    void set_player_tray_layout_frame(CGRect rect) { m_player_tray_layout_frame = rect; }
    void set_tile_size(CGSize size) { m_tile_size = size; }
    void set_tile_stroke_width(CGFloat f) { m_tile_stroke_width = f; }
    void set_tile_drag_barrier_frame(CGRect rect) { m_tile_drag_barrier_frame = rect; }
    void set_word_tray_shake_offset(UIOffset offset) { m_word_tray_shake_offset = offset; }
    void set_dialog_top_buttons_layout_frame(CGRect rect) { m_dialog_top_buttons_layout_frame = rect; }
    
    
    
    
    
    
    
    
    void set_word_tray_tile_offset(UIOffset offset) { m_word_tray_tile_offset = offset; }
    void set_game_controls_left_button_frame(CGRect rect) { m_game_controls_left_button_frame = rect; }
    void set_game_controls_right_button_frame(CGRect rect) { m_game_controls_right_button_frame = rect; }
    void set_game_controls_button_charge_size(CGSize size) { m_game_controls_button_charge_size = size; }
    void set_game_information_font(UIFont *font) { m_game_information_font = font; }
    void set_game_information_font_metrics(const FontMetrics &metrics) { m_game_information_font_metrics = metrics; }
    void set_game_information_superscript_font(UIFont *font) { m_game_information_superscript_font = font; }
    void set_game_information_superscript_font_metrics(const FontMetrics &metrics) { m_game_information_superscript_font_metrics = metrics; }
    void set_game_note_font(UIFont *font) { m_game_note_font = font; }
    void set_game_note_font_metrics(const FontMetrics &metrics) { m_game_note_font_metrics = metrics; }
    void set_game_play_time_label_frame(CGRect rect) { m_game_play_time_label_frame = rect; }
    void set_game_play_score_label_frame(CGRect rect) { m_game_play_score_label_frame = rect; }
    void set_score_tile_spring_down_offset_y(CGFloat f) { m_score_tile_spring_down_offset_y = f; }
    void set_score_tile_center_y(CGFloat f) { m_score_tile_center_y = f; }
    void set_dialog_title_layout_frame(CGRect rect) { m_dialog_title_layout_frame = rect; }
    void set_dialog_spring_dismiss_offset_y(CGFloat f) { m_dialog_spring_dismiss_offset_y = f; }
    void set_dialog_pause_title_layout_frame(CGRect rect) { m_dialog_pause_title_layout_frame = rect; }
    void set_dialog_pause_buttons_layout_frame(CGRect rect) { m_dialog_pause_buttons_layout_frame = rect; }
    void set_dialog_pause_button_quit_frame(CGRect rect) { m_dialog_pause_button_quit_frame = rect; }
    void set_dialog_pause_button_resume_frame(CGRect rect) { m_dialog_pause_button_resume_frame = rect; }
    void set_dialog_over_title_layout_frame(CGRect rect) { m_dialog_over_title_layout_frame = rect; }
    void set_dialog_over_buttons_layout_frame(CGRect rect) { m_dialog_over_buttons_layout_frame = rect; }
    void set_dialog_over_button_left_frame(CGRect rect) { m_dialog_over_button_left_frame = rect; }
    void set_dialog_over_button_right_frame(CGRect rect) { m_dialog_over_button_right_frame = rect; }
    void set_dialog_over_note_label_frame(CGRect rect) { m_dialog_over_note_label_frame = rect; }
    void set_dialog_over_interstitial_title_layout_frame(CGRect rect) { m_dialog_over_interstitial_title_layout_frame = rect; }
    void set_dialog_over_interstitial_button_left_frame(CGRect rect) { m_dialog_over_interstitial_button_left_frame = rect; }
    void set_dialog_over_interstitial_button_right_frame(CGRect rect) { m_dialog_over_interstitial_button_right_frame = rect; }
    void set_dialog_over_interstitial_note_label_frame(CGRect rect) { m_dialog_over_interstitial_note_label_frame = rect; }
    void set_menu_game_view_transform(CGAffineTransform t) { m_menu_game_view_transform = t; }
    void set_menu_title_layout_frame(CGRect rect) { m_menu_title_layout_frame = rect; }
    void set_menu_title_dismissed_layout_frame(CGRect rect) { m_menu_title_dismissed_layout_frame = rect; }
    void set_menu_buttons_layout_frame(CGRect rect) { m_menu_buttons_layout_frame = rect; }
    void set_menu_button_left_layout_frame(CGRect rect) { m_menu_button_left_layout_frame = rect; }
    void set_menu_button_center_layout_frame(CGRect rect) { m_menu_button_center_layout_frame = rect; }
    void set_menu_button_right_layout_frame(CGRect rect) { m_menu_button_right_layout_frame = rect; }
    void set_menu_button_left_dismissed_layout_frame(CGRect rect) { m_menu_button_left_dismissed_layout_frame = rect; }
    void set_menu_button_center_dismissed_layout_frame(CGRect rect) { m_menu_button_center_dismissed_layout_frame = rect; }
    void set_menu_button_right_dismissed_layout_frame(CGRect rect) { m_menu_button_right_dismissed_layout_frame = rect; }

    void calculate_tile_size();
    void calculate_tile_stroke_width();
    void calculate_game_controls_layout_frame();
    void calculate_player_tray_layout_frame();
    void calculate_word_tray_layout_frame();
    void calculate_word_tray_mask_frame();
    void calculate_word_tray_shake_offset();
    void calculate_tile_drag_barrier_frame();
    void calculate_word_tray_tile_frames();
    void calculate_player_tray_tile_frames();
    
    void calculate_locations();
    void calculate_player_tile_locations();
    void calculate_word_tile_locations();
    void calculate_dialog_locations();

    void calculate_dialog_top_buttons_layout_frame();
    void calculate_and_set_locations(const Role role, const CGRect &frame);

    void calculate_prefill_tile_frames();
    void calculate_score_tile_spring_down_offset_y();
    void calculate_score_tile_center_y();
    void calculate_game_controls_left_button_frame();
    void calculate_game_controls_right_button_frame();
    void calculate_game_controls_button_charge_size();
    void calculate_game_information_font_metrics();
    void calculate_game_information_superscript_font_metrics();
    void calculate_game_note_font_metrics();
    void calculate_game_play_time_label_frame();
    void calculate_game_play_score_label_frame();
    void calculate_dialog_title_layout_frame();
    void calculate_dialog_spring_dismiss_offset_y();
    void calculate_dialog_pause_title_layout_frame();
    void calculate_dialog_pause_buttons_layout_frame();
    void calculate_dialog_pause_button_quit_frame();
    void calculate_dialog_pause_button_resume_frame();
    void calculate_dialog_over_title_layout_frame();
    void calculate_dialog_over_buttons_layout_frame();
    void calculate_dialog_over_button_left_frame();
    void calculate_dialog_over_button_right_frame();
    void calculate_dialog_over_note_label_frame();
    void calculate_dialog_over_interstitial_title_layout_frame();
    void calculate_dialog_over_interstitial_button_left_frame();
    void calculate_dialog_over_interstitial_button_right_frame();
    void calculate_dialog_over_interstitial_note_label_frame();
    void calculate_menu_game_view_transform();
    void calculate_menu_title_layout_frame();
    void calculate_menu_buttons_layout_frame();
    void calculate_menu_button_left_layout_frame();
    void calculate_menu_button_center_layout_frame();
    void calculate_menu_button_right_layout_frame();

    std::map<Location, CGRect> m_location_frames;

    CGRect m_screen_bounds = CGRectZero;
    CGFloat m_screen_scale = 2.0;
    AspectMode m_aspect_mode = AspectMode::Canonical;
    CGFloat m_aspect_ratio = CanonicalAspectRatio;
    CGFloat m_aspect_scale = 1.0;

    CGRect m_canvas_frame = CGRectZero;
    CGRect m_layout_frame = CGRectZero;
    CGFloat m_layout_scale = 1.0;
    UIEdgeInsets m_letterbox_insets = UIEdgeInsetsZero;

    CGSize m_tile_size = CGSizeZero;
    CGFloat m_tile_stroke_width = 0.0;
    UIBezierPath *m_tile_stroke_path = nil;
    
    CGRect m_game_controls_layout_frame = CGRectZero;
    CGRect m_player_tray_layout_frame = CGRectZero;
    CGRect m_word_tray_layout_frame = CGRectZero;
    CGRect m_word_tray_mask_frame = CGRectZero;
    UIOffset m_word_tray_shake_offset;
    CGRect m_tile_drag_barrier_frame = CGRectZero;

    TileRectArray m_player_tray_tile_frames;
    TilePointArray m_player_tray_tile_centers;
    std::array<TileRectArray, TileCount> m_word_tray_tile_frames;
    std::array<TilePointArray, TileCount> m_word_tray_tile_centers;

    CGRect m_dialog_top_buttons_layout_frame = CGRectZero;

    
    
    
    UIOffset m_word_tray_tile_offset;

    CGRect m_game_controls_left_button_frame = CGRectZero;
    CGRect m_game_controls_right_button_frame = CGRectZero;
    CGSize m_game_controls_button_charge_size = CGSizeZero;

    __strong UIFont *m_game_information_font;
    FontMetrics m_game_information_font_metrics;
    __strong UIFont *m_game_information_superscript_font;
   FontMetrics m_game_information_superscript_font_metrics;
    __strong UIFont *m_game_note_font;
    FontMetrics m_game_note_font_metrics;

    CGRect m_game_play_time_label_frame = CGRectZero;
    CGRect m_game_play_score_label_frame = CGRectZero;

    TileRectArray m_prefill_tile_frames;
    TilePointArray m_prefill_tile_centers;

    CGFloat m_score_tile_spring_down_offset_y = 0.0;
    CGFloat m_score_tile_center_y = 0.0;
    
    CGRect m_dialog_title_layout_frame;
    CGFloat m_dialog_spring_dismiss_offset_y;

    CGRect m_dialog_pause_title_layout_frame;
    CGRect m_dialog_pause_buttons_layout_frame;
    CGRect m_dialog_pause_button_quit_frame;
    CGRect m_dialog_pause_button_resume_frame;

    CGRect m_dialog_over_title_layout_frame;
    CGRect m_dialog_over_buttons_layout_frame;
    CGRect m_dialog_over_button_left_frame;
    CGRect m_dialog_over_button_right_frame;
    CGRect m_dialog_over_note_label_frame;

    CGRect m_dialog_over_interstitial_title_layout_frame;
    CGRect m_dialog_over_interstitial_button_left_frame;
    CGRect m_dialog_over_interstitial_button_right_frame;
    CGRect m_dialog_over_interstitial_note_label_frame;
    
    CGAffineTransform m_menu_game_view_transform;
    CGRect m_menu_title_layout_frame;
    CGRect m_menu_title_dismissed_layout_frame;
    CGRect m_menu_buttons_layout_frame;
    CGRect m_menu_button_left_layout_frame;
    CGRect m_menu_button_center_layout_frame;
    CGRect m_menu_button_right_layout_frame;
    CGRect m_menu_button_left_dismissed_layout_frame;
    CGRect m_menu_button_center_dismissed_layout_frame;
    CGRect m_menu_button_right_dismissed_layout_frame;
};

UP_STATIC_INLINE bool operator==(const SpellLayout::Location &a, const SpellLayout::Location &b) {
    return a.role() == b.role() && a.spot() == b.spot();
}

UP_STATIC_INLINE bool operator!=(const SpellLayout::Location &a, const SpellLayout::Location &b) {
    return !(a==b);
}

UP_STATIC_INLINE bool operator<(const SpellLayout::Location &a, const SpellLayout::Location &b) {
    return a.role() != b.role() ? a.role() < b.role() : a.spot() < b.spot();
}

SpellLayout::Role role_for(TilePosition pos);
template <class ...Args>
SpellLayout::Role role_for(Args... args) {
    return role_for(TilePosition(std::forward<Args>(args)...));
}

SpellLayout::Role role_in_word(TileIndex idx, size_t word_length);

}  // namespace UP

#endif  // __cplusplus
