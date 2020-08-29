//
//  UPSpellLayout.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import <UpKit/UPAssertions.h>
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
        Screen,
        PlayerTile1, PlayerTile2, PlayerTile3, PlayerTile4, PlayerTile5, PlayerTile6, PlayerTile7,
        WordTile1of1,
        WordTile1of2, WordTile2of2,
        WordTile1of3, WordTile2of3, WordTile3of3,
        WordTile1of4, WordTile2of4, WordTile3of4, WordTile4of4,
        WordTile1of5, WordTile2of5, WordTile3of5, WordTile4of5, WordTile5of5,
        WordTile1of6, WordTile2of6, WordTile3of6, WordTile4of6, WordTile5of6, WordTile6of6,
        WordTile1of7, WordTile2of7, WordTile3of7, WordTile4of7, WordTile5of7, WordTile6of7, WordTile7of7,
        WordTray,
        ControlButtonLeft, ControlButtonRight,
        GameTimer, GameScore, GameShareButton,
        GameScoreGameOver1, GameScoreGameOver2, GameScoreGameOver3, GameScoreGameOver4,
        WordScore, WordScoreBonus,
        DialogMessageCenteredInWordTray, DialogMessageVerticallyCentered, DialogMessagePlay,
        DialogGameNote, DialogChallengeGameNote,
        DialogButtonTopLeft, DialogButtonTopCenter, DialogButtonTopRight,
        DialogButtonDefaultResponse, DialogButtonAlternativeResponse, DialogButtonCenterResponse,
        DialogHelpButton, DialogHelpTitle, DialogHelpText, DialogHelpOKButton,
        ChoiceBackLeft, ChoiceTitleLeft, ChoiceItem1Left, ChoiceItem2Left, ChoiceItem3Left, ChoiceItem4Left,
        ChoiceBackRight, ChoiceTitleRight, ChoiceItem1Right, ChoiceItem2Right, ChoiceItem3Right, ChoiceItem4Right,
        ChoiceBackCenter, ChoiceTitleCenter, ChoiceItem1Center, ChoiceItem2Center, ChoiceItem3Center, ChoiceGoButtonCenter, ChoiceItemTopCenter,
        ExtrasColorsDarkMode, ExtrasColorsStarkMode, ExtrasColorsQuarkMode, ExtrasColorsHueWheel, ExtrasColorsThemeRotor,
        ExtrasColorsHueStepMore, ExtrasColorsHueStepLess, ExtrasColorsDescription, ExtrasColorsExample,
        ExtrasColorsIconPrompt, ExtrasColorsIconButtonNope, ExtrasColorsIconButtonYep,
        ExtrasStatsHeader, ExtrasStatsTable,
        ExtrasRetryCheckbox, ExtrasRetryDescription,
        ExtrasSoundEffectsCheckbox, ExtrasSoundEffectsSlider, ExtrasSoundTunesCheckbox, ExtrasSoundTunesSlider, ExtrasSoundDescription,
        ExtrasShareHighScoreValue, ExtrasShareHighScoreDescription, ExtrasShareHighScoreButton,
        ExtrasShareLastGameValue, ExtrasShareLastGameDescription, ExtrasShareLastGameButton,
        ExtrasShareDescription, ExtrasShareLastGameHighScoreEqualDescription,
        ChallengePrompt, ChallengeScore,
        AboutGameDescription, AboutLexiconDescription, AboutThanksDescription,
        AboutPlayingGameView, AboutPlayingBottomPrompt,
        AboutPlayingTopLeftButtonClick, AboutPlayingTopRightButtonClick, AboutPlaying2xCallout,
        AboutLogo, AboutWordMark,
        HeroLogo, HeroWordMark,
    };

    enum class Spot {
        Default,
        OffTopNear,
        OffBottomNear,
        OffLeftNear,
        OffRightNear,
        OffTopFar,
        OffBottomFar,
        OffLeftFar,
        OffRightFar,
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

    static inline constexpr CGSize CanonicalRoundGameButtonSize =  { 84,  84 };
    static inline constexpr CGSize CanonicalRoundBackButtonSize =  { 64,  64 };
    static inline constexpr CGSize CanonicalRoundHelpButtonSize =  { 64,  64 };
    static inline constexpr CGSize CanonicalTextButtonSize =      { 188,  76 };
    static inline constexpr CGSize CanonicalBallotSize =          {  40,  36 };
    static inline constexpr CGSize CanonicalHueWheelSize =        { 220, 220 };
    static inline constexpr CGSize CanonicalStepperSize =         {  36,  36 };
    static inline constexpr CGSize CanonicalRotorSize =           { 400, 250 };
    static inline constexpr CGSize CanonicalSliderSize =          { 510,  40 };
    static inline constexpr CGSize CanonicalSliderThumbSize =     {  40,  40 };

    static inline constexpr CGSize CanonicalSmallTextButtonSize = up_size_scaled(CanonicalTextButtonSize, 0.75);

    static inline constexpr CGFloat CanonicalTextButtonCapHeight = 29;
    static inline constexpr CGFloat CanonicalTextButtonBaselineAdjustment = -3.5;
    static inline constexpr CGFloat CanonicalSmallTextButtonCapHeight = CanonicalTextButtonCapHeight * 0.8;
    static inline constexpr CGFloat CanonicalSmallTextButtonBaselineAdjustment = -2.5;
    static inline constexpr CGFloat CanonicalGameInformationCapHeight = 57;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptCapHeight = 39;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptBaselineAdjustment = 27;
    static inline constexpr CGFloat CanonicalGameInformationSuperscriptKerning = 1;
    static inline constexpr CGFloat CanonicalGameTimeLabelWidth =  180;
    static inline constexpr CGPoint CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC =  { -30, 91.7 };
    static inline constexpr CGPoint CanonicalGameScoreLabelRightAlignedBaselinePointRelativeToTDC = {  30, 91.7 };
    static inline constexpr CGFloat CanonicalGameScoreLabelWidth =  175;
    static inline constexpr CGFloat CanonicalWordScoreCapHeight = 52;
    static inline constexpr CGFloat CanonicalWordScoreBonusCapHeight = 30;
    static inline constexpr CGFloat CanonicalWordScoreBonusBaselineAdjustment = 14;
    static inline constexpr CGFloat CanonicalBallotLabelCapHeight = 25;
    static inline constexpr CGFloat CanonicalBallotLabelBaselineAdjustment = 6.5;
    static inline constexpr CGFloat CanonicalBallotLabelLeftMargin = 41;
    static inline constexpr CGFloat CanonicalSliderIconInset = 75;

    static inline constexpr CGFloat CanonicalChoiceLabelCapHeight = 30;
    static inline constexpr CGFloat CanonicalChoiceLabelBaselineAdjustment = -12;
    static inline constexpr CGFloat CanonicalChoiceLabelLeftMargin = 82;
    static inline constexpr CGFloat CanonicalChoiceLabelRightMargin = 87;
    static inline constexpr CGFloat CanonicalRotorElementCapHeight = 36;

    static inline constexpr CGSize CanonicalTileSize = { 100, 120 };
    static inline constexpr CGRect CanonicalTileFrame = { 0, 0, up_size_width(CanonicalTileSize), up_size_height(CanonicalTileSize) };
    static inline constexpr CGFloat CanonicalTileStrokeWidth = 3;
    static inline constexpr CGFloat CanonicalTileGap = 15;
    static inline constexpr CGFloat CanonicalTilesLayoutWidth = up_size_width(CanonicalTileSize) * 7 + (CanonicalTileGap * 6);

    static inline constexpr CGRect CanonicalControlsLayoutFrame =    {   92,  22, 816,  84 };
    static inline constexpr CGRect CanonicalWordTrayFrame =          { 62.5, 133, 875, 182 };
    static inline constexpr CGRect CanonicalWordTrayTileMaskFrame =  { 62.5, 143, 875, 420 };
    static inline constexpr CGRect CanonicalTilesLayoutFrame =       {    0, 348, CanonicalTilesLayoutWidth, 120 };

    static inline constexpr CGFloat CanonicalWordTrayStroke =      10;
    static inline constexpr CGFloat CanonicalWordTrayShakeAmount = 30;

    static inline constexpr CGRect CanonicalWordScoreLayoutFrame = CanonicalWordTrayFrame;

    static inline constexpr CGRect CanonicalDialogTopButtonsLayoutFrame =      {  83,  26,  834,  76 };
    static inline constexpr CGRect CanonicalDialogResponseButtonsLayoutFrame = { 257, 350,  480,  76 };
    static inline constexpr CGSize CanonicalDialogTitleSize = {  875, 182 };
    static inline constexpr CGRect CanonicalDialogHelpButtonFrame = { 853, 382,  up_size_width(CanonicalRoundHelpButtonSize), up_size_height(CanonicalRoundHelpButtonSize) };

    static inline constexpr CGRect CanonicalGameNoteLayoutFrame = { 0, 384, 1000, 116 };
    static inline constexpr CGFloat CanonicalGameNoteFontCapHeight = 32;
    static inline constexpr CGFloat CanonicalGameNoteFontBaselineAdjustment = 6;
    static inline constexpr CGRect CanonicalGameShareButtonFrame = { 853, 382,  up_size_width(CanonicalRoundHelpButtonSize), up_size_height(CanonicalRoundHelpButtonSize) };

    static inline constexpr CGFloat CanonicalGameViewMenuScale = 0.7;
    static inline constexpr CGFloat CanonicalGameViewAboutPlayingScale = 0.65;
    static inline constexpr CGFloat CanonicalOffscreenNearFrameFactor = 1.2;

    static inline constexpr CGRect CanonicalChoiceBackButtonRowLayoutFrame = {  20,  30, 960, 64 };
    static inline constexpr CGRect CanonicalChoiceTitleLayoutFrame =         {  83,  26, 834, 76 };
    static inline constexpr CGRect CanonicalChoice1LayoutFrame =             {  30, 120, 940, 76 };
    static inline constexpr CGRect CanonicalChoice2LayoutFrame =             {  30, 204, 940, 76 };
    static inline constexpr CGRect CanonicalChoice3LayoutFrame =             {  30, 288, 940, 76 };
    static inline constexpr CGRect CanonicalChoice4LayoutFrame =             {  30, 372, 940, 76 };
    static inline constexpr CGSize CanonicalChoiceSize =                              {  280, 76 };

    static inline constexpr CGFloat CanonicalChoiceCenterMargin = 136;
    static inline constexpr CGFloat CanonicalChoiceCenterTitleMargin =  115;
    static inline constexpr CGRect CanonicalChoiceCenterGoFrame =  { 713, 376, up_size_width(CanonicalTextButtonSize), up_size_height(CanonicalTextButtonSize) };
    
    static inline constexpr CGFloat CanonicalSettingsDescriptionFontCapHeight = 19;
    static inline constexpr CGFloat CanonicalPlacardValueFontCapHeight = 38;
    static inline constexpr CGFloat CanonicalPlacardDescriptionFontCapHeight = 24;

    static inline constexpr CGRect CanonicalExtrasColorsThemeRotorFrame =  { 470,  30, up_size_width(CanonicalRotorSize), up_size_height(CanonicalRotorSize) };
    static inline constexpr CGRect CanonicalExtrasColorsDescriptionFrame = { 384, 282, 572, 76 };
    static inline constexpr CGRect CanonicalExtrasColorsExampleFrame =     { 400, 386, 540, 66 };
    static inline constexpr CGRect CanonicalExtrasColorsIconPromptFrame =       { 384, 282, 572, 76 };
    static inline constexpr CGRect CanonicalExtrasColorsIconButtonLayoutFrame = { 460, 381, 440, 76 };

    static inline constexpr CGRect CanonicalExtrasSoundEffectsCheckboxFrame =  { 400, 64, up_size_width(CanonicalBallotSize), up_size_height(CanonicalBallotSize) };
    static inline constexpr CGRect CanonicalExtrasSoundEffectsSliderFrame =  { 423, 124, up_size_width(CanonicalSliderSize), up_size_height(CanonicalSliderSize) };
    static inline constexpr CGRect CanonicalExtrasSoundTunesCheckboxFrame =  { 400, 216, up_size_width(CanonicalBallotSize), up_size_height(CanonicalBallotSize) };
    static inline constexpr CGRect CanonicalExtrasSoundTunesSliderFrame =  { 423, 276, up_size_width(CanonicalSliderSize), up_size_height(CanonicalSliderSize) };
    static inline constexpr CGRect CanonicalExtrasSoundDescriptionFrame = { 384, 368, 572, 300 };

    static inline constexpr CGRect CanonicalExtrasRetryCheckboxFrame =  { 540, 354, up_size_width(CanonicalBallotSize), up_size_height(CanonicalBallotSize) };
    static inline constexpr CGRect CanonicalExtrasRetryDescriptionFrame = { 384, 88, 572, 300 };

    static inline constexpr CGRect CanonicalExtrasShareHighScoreButtonFrame =  { 516.5, 90, up_size_width(CanonicalRoundHelpButtonSize), up_size_height(CanonicalRoundHelpButtonSize) };
    static inline constexpr CGRect CanonicalExtrasShareHighScoreValueFrame = { 462, 198, 170, 64 };
    static inline constexpr CGRect CanonicalExtrasShareHighScoreDescriptionFrame = { 462, 160, 173, 64 };
    static inline constexpr CGRect CanonicalExtrasShareLastGameButtonFrame =  { 759.5, 90, up_size_width(CanonicalRoundHelpButtonSize), up_size_height(CanonicalRoundHelpButtonSize) };
    static inline constexpr CGRect CanonicalExtrasShareLastGameValueFrame = { 705, 198, 170, 64 };
    static inline constexpr CGRect CanonicalExtrasShareLastGameDescriptionFrame = { 705, 160, 173, 64 };
    static inline constexpr CGRect CanonicalExtrasShareDescriptionFrame = { 384, 300, 572, 300 };
    static inline constexpr CGRect CanonicalExtrasShareLastGameHighScoreEqualDescription = { 384, 270, 572, 300 };
    static inline constexpr CGFloat CanonicalExtrasShareLastGameHighScoreEqualGap = 28;

    static inline constexpr CGRect CanonicalDialogShareHelpTitleFrame = { 272, 142, 460, 200 };
    static inline constexpr CGRect CanonicalDialogShareHelpTextFrame = { 250, 220, 500, 200 };
    static inline constexpr CGRect CanonicalDialogShareHelpOKButtonFrame = { 429.5, 386, up_size_width(CanonicalSmallTextButtonSize), up_size_height(CanonicalSmallTextButtonSize) };
    static inline constexpr CGFloat CanonicalDialogTitleCapHeight = 35;

    static inline constexpr CGRect CanonicalAboutLogoFrame = { 245, 60, 160, 160 };
    static inline constexpr CGRect CanonicalAboutWordMarkFrame = { 235, 223, 180, 140 };
    static inline constexpr CGRect CanonicalAboutGameDescriptionFrame = { 160, 304, 335, 150 };
    static inline constexpr CGFloat CanonicalSettingsAboutFontCapHeight = 19;
    static inline constexpr CGFloat CanonicalLegalFontCapHeight = 16;

    static inline constexpr CGRect CanonicalAboutLexiconDescriptionFrame = { 40, 44, 600, 400 };
    static inline constexpr CGRect CanonicalAboutThanksDescriptionFrame = { 40, 44, 600, 400 };

    static inline constexpr CGRect CanonicalAboutPlayingGameViewFrame = { -180, -132, 1000, 500 };
    static inline constexpr CGRect CanonicalAboutPlayingGameBottomPromptFrame = { 40, 410, 560, 80 };
    static inline constexpr CGRect CanonicalAboutPlaying2xCalloutFrame = { 676, 243, 46, 46 };

    static inline constexpr CGSize CanonicalBotSpotSize = { 92, 92 };

    static inline constexpr CGRect CanonicalHeroLogoFrame = { 426, 132, 160, 160 };
    static inline constexpr CGRect CanonicalHeroWordMarkFrame = { 416, 295, 180, 300 };
    static inline constexpr CGFloat CanonicalHeroWordMarkCapHeight = 31;

    static inline constexpr CGRect CanonicalChallengePromptFrame = { 200, 112, 600, 300 };
    static inline constexpr CGRect CanonicalChallengeScoreFrame = { 100, 228, 800, 300 };
    static inline constexpr CGFloat CanonicalChallengePromptFontCapHeight = 62;
    static inline constexpr CGFloat CanonicalChallengeScoreFontCapHeight = 34;

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

    CGSize size_for(const Location &);
    template <class ...Args> CGSize size_for(Args... args) { return size_for(Location(std::forward<Args>(args)...)); }
    
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

    CGRect word_tray_layout_frame() const { return m_word_tray_layout_frame; }

    CGRect word_tray_mask_frame() const { return layout_centered_x_aspect_rect(CanonicalWordTrayTileMaskFrame); }

    CGSize tile_size() const { return m_tile_size; }
    CGFloat tile_stroke_width() const { return m_tile_stroke_width; }
    UIBezierPath *tile_stroke_path() const { return m_tile_stroke_path; }
    CGRect tile_drag_barrier_frame() const { return m_tile_drag_barrier_frame; }

    UIOffset word_tray_shake_offset() const { return m_word_tray_shake_offset; }
    
    UPOutsets game_controls_button_charge_outsets() const { return m_game_controls_button_charge_outsets; }
    UPOutsets ballot_control_charge_outsets() const { return m_ballot_control_charge_outsets; }
    UPOutsets stepper_control_charge_outsets() const { return m_stepper_control_charge_outsets; }
    UPOutsets slider_control_charge_outsets() const { return m_slider_control_charge_outsets; }
    UPOutsets help_button_charge_outsets() const { return m_help_button_charge_outsets; }

    UIFont *text_button_font() const { return m_text_button_font; }
    UIFont *small_text_button_font() const { return m_small_text_button_font; }
    UIFont *game_information_font() const { return m_game_information_font; }
    UIFont *game_information_superscript_font() const { return m_game_information_superscript_font; }
    UIFont *game_note_font() const { return m_game_note_font; }
    UIFont *word_score_font() const { return m_word_score_font; }
    UIFont *word_score_bonus_font() const { return m_word_score_bonus_font; }
    UIFont *ballot_control_font() const { return m_ballot_control_font; }
    UIFont *choice_control_font() const { return m_choice_control_font; }
    UIFont *rotor_control_font() const { return m_rotor_control_font; }
    UIFont *description_font() const { return m_description_font; }
    UIFont *dialog_title_font() const { return m_dialog_title_font; }
    UIFont *about_font() const { return m_about_font; }
    UIFont *challenge_prompt_font() const { return m_challenge_prompt_font; }
    UIFont *challenge_score_font_font() const { return m_challenge_score_font_font; }
    UIFont *placard_value_font() const { return m_placard_value_font; }
    UIFont *placard_description_font() const { return m_placard_description_font; }
    UIFont *word_mark_font() const { return m_word_mark_font; }
    UIFont *legal_font() const { return m_legal_font; }

    CGFloat ballot_control_label_left_margin() const { return m_ballot_control_label_left_margin; }
    CGFloat choice_control_label_left_margin() const { return m_choice_control_label_left_margin; }
    CGFloat choice_control_label_right_margin() const { return m_choice_control_label_right_margin; }

    CGAffineTransform menu_game_view_transform() const { return m_menu_game_view_transform; }
    CGAffineTransform about_playing_game_view_transform() const { return m_about_playing_game_view_transform; }
    CGAffineTransform extras_example_transform() const { return m_extras_example_transform; }

    CGRect layout_relative_aspect_rect(CGRect) const;

    CGFloat width_for_score(int score);

private:
    
    SpellLayout() {}

    UP_STATIC_INLINE SpellLayout *g_instance;
    
    CGRect layout_centered_x_aspect_rect(CGRect) const;
    CGRect layout_game_over_score_frame(NSString *) const;

    void set_aspect_mode(AspectMode aspect_mode) { m_aspect_mode = aspect_mode; }
    void set_aspect_ratio(CGFloat f) { m_aspect_ratio = f; }
    void set_aspect_scale(CGFloat f) { m_aspect_scale = f; }
    void set_letterbox_insets(UIEdgeInsets insets) { m_letterbox_insets = insets; }
    void set_layout_frame(CGRect rect) { m_layout_frame = rect; }
    void set_layout_scale(CGFloat f) { m_layout_scale = f; }
    void set_word_tray_layout_frame(CGRect rect) { m_word_tray_layout_frame = rect; }
    void set_tile_size(CGSize size) { m_tile_size = size; }
    void set_tile_stroke_width(CGFloat f) { m_tile_stroke_width = f; }
    void set_tile_drag_barrier_frame(CGRect rect) { m_tile_drag_barrier_frame = rect; }
    void set_word_tray_shake_offset(UIOffset offset) { m_word_tray_shake_offset = offset; }
    void set_menu_game_view_transform(CGAffineTransform t) { m_menu_game_view_transform = t; }
    void set_about_playing_game_view_transform(CGAffineTransform t) { m_about_playing_game_view_transform = t; }
    void set_extras_example_transform(CGAffineTransform t) { m_extras_example_transform = t; }
    void set_text_button_font(UIFont *font) { m_text_button_font = font; }
    void set_small_text_button_font(UIFont *font) { m_small_text_button_font = font; }
    void set_game_information_font(UIFont *font) { m_game_information_font = font; }
    void set_game_information_superscript_font(UIFont *font) { m_game_information_superscript_font = font; }
    void set_game_note_font(UIFont *font) { m_game_note_font = font; }
    void set_word_score_font(UIFont *font) { m_word_score_font = font; }
    void set_word_score_bonus_font(UIFont *font) { m_word_score_bonus_font = font; }
    void set_ballot_control_font(UIFont *font) { m_ballot_control_font = font; }
    void set_ballot_control_label_left_margin(CGFloat f) { m_ballot_control_label_left_margin = f; }
    void set_ballot_control_charge_outsets(UPOutsets outsets) { m_ballot_control_charge_outsets = outsets; }
    void set_stepper_control_charge_outsets(UPOutsets outsets) { m_stepper_control_charge_outsets = outsets; }
    void set_slider_control_charge_outsets(UPOutsets outsets) { m_slider_control_charge_outsets = outsets; }
    void set_choice_control_font(UIFont *font) { m_choice_control_font = font; }
    void set_choice_control_label_left_margin(CGFloat f) { m_choice_control_label_left_margin = f; }
    void set_choice_control_label_right_margin(CGFloat f) { m_choice_control_label_right_margin = f; }
    void set_rotor_control_font(UIFont *font) { m_rotor_control_font = font; }
    void set_description_font(UIFont *font) { m_description_font = font; }
    void set_about_font(UIFont *font) { m_about_font = font; }
    void set_dialog_title_font(UIFont *font) { m_dialog_title_font = font; }
    void set_challenge_prompt_font(UIFont *font) { m_challenge_prompt_font = font; }
    void set_challenge_score_font_font(UIFont *font) { m_challenge_score_font_font = font; }
    void set_placard_value_font(UIFont *font) { m_placard_value_font = font; }
    void set_placard_description_font(UIFont *font) { m_placard_description_font = font; }
    void set_word_mark_font(UIFont *font) { m_word_mark_font = font; }
    void set_legal_font(UIFont *font) { m_legal_font = font; }
    void set_game_controls_button_charge_outsets(UPOutsets outsets) { m_game_controls_button_charge_outsets = outsets; }
    void set_help_button_charge_outsets(UPOutsets outsets) { m_help_button_charge_outsets = outsets; }
    void set_game_timer_frame(CGRect rect) { m_game_timer_frame = rect; }
    void set_game_score_frame(CGRect rect) { m_game_score_frame = rect; }

    void calculate_game_view_transforms();
    void calculate_extras_example_transform();
    void calculate_tile_size();
    void calculate_tile_stroke_width();
    void calculate_word_tray_layout_frame();
    void calculate_word_tray_shake_offset();
    void calculate_tile_drag_barrier_frame();
    void calculate_word_tray_tile_frames();
    void calculate_player_tray_tile_frames();
    void calculate_text_button_font_metrics();
    void calculate_small_text_button_font_metrics();
    void calculate_game_information_font_metrics();
    void calculate_game_information_superscript_font_metrics();
    void calculate_game_note_font_metrics();
    void calculate_word_score_font_metrics();
    void calculate_word_score_bonus_font_metrics();
    void calculate_ballot_control_metrics();
    void calculate_stepper_control_metrics();
    void calculate_slider_control_metrics();
    void calculate_choice_control_metrics();
    void calculate_rotor_control_metrics();
    void calculate_description_font_metrics();
    void calculate_about_font_metrics();
    void calculate_dialog_title_font_metrics();
    void calculate_challenge_prompt_font_metrics();
    void calculate_challenge_score_font_font_metrics();
    void calculate_placard_value_font_metrics();
    void calculate_placard_description_font_metrics();
    void calculate_word_mark_font_metrics();
    void calculate_legal_font_metrics();
    void calculate_player_tile_locations();
    void calculate_word_tile_locations();
    void calculate_dialog_locations();
    void calculate_game_locations();
    void calculate_choice_locations();
    void calculate_extras_locations();
    void calculate_about_locations();
    void calculate_game_controls_button_charge_outsets();
    void calculate_help_button_charge_outsets();
    void calculate_and_set_locations(const Role role, const CGRect &frame, CGFloat near_factor = CanonicalOffscreenNearFrameFactor);

    void calculate_game_timer_frame();
    void calculate_game_score_frame();

    CGRect game_timer_frame() const { return m_game_timer_frame; }
    CGRect game_score_frame() const { return m_game_score_frame; }

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
    CGAffineTransform m_menu_game_view_transform;
    CGAffineTransform m_about_playing_game_view_transform;
    CGAffineTransform m_extras_example_transform;

    __strong UIFont *m_text_button_font;
    __strong UIFont *m_small_text_button_font;
    __strong UIFont *m_game_information_font;
    __strong UIFont *m_game_information_superscript_font;
    __strong UIFont *m_game_note_font;
    __strong UIFont *m_word_score_font;
    __strong UIFont *m_word_score_bonus_font;
    __strong UIFont *m_ballot_control_font;
    __strong UIFont *m_choice_control_font;
    __strong UIFont *m_rotor_control_font;
    __strong UIFont *m_description_font;
    __strong UIFont *m_about_font;
    __strong UIFont *m_dialog_title_font;
    __strong UIFont *m_challenge_prompt_font;
    __strong UIFont *m_challenge_score_font_font;
    __strong UIFont *m_placard_value_font;
    __strong UIFont *m_placard_description_font;
    __strong UIFont *m_word_mark_font;
    __strong UIFont *m_legal_font;

    CGFloat m_ballot_control_label_left_margin = 0.0;
    CGFloat m_choice_control_label_left_margin = 0.0;
    CGFloat m_choice_control_label_right_margin = 0.0;

    CGSize m_tile_size = CGSizeZero;
    CGFloat m_tile_stroke_width = 0.0;
    UIBezierPath *m_tile_stroke_path = nil;
    
    CGRect m_word_tray_layout_frame = CGRectZero;
    UIOffset m_word_tray_shake_offset;
    CGRect m_tile_drag_barrier_frame = CGRectZero;

    TileRectArray m_player_tray_tile_frames;
    TilePointArray m_player_tray_tile_centers;
    std::array<TileRectArray, TileCount> m_word_tray_tile_frames;
    std::array<TilePointArray, TileCount> m_word_tray_tile_centers;

    UPOutsets m_game_controls_button_charge_outsets = UPOutsetsZero;
    UPOutsets m_ballot_control_charge_outsets = UPOutsetsZero;
    UPOutsets m_stepper_control_charge_outsets = UPOutsetsZero;
    UPOutsets m_slider_control_charge_outsets = UPOutsetsZero;
    UPOutsets m_help_button_charge_outsets = UPOutsetsZero;

    CGRect m_game_timer_frame = CGRectZero;
    CGRect m_game_score_frame = CGRectZero;
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

SpellLayout::Role role_in_player_tray(TilePosition pos);
template <class ...Args> SpellLayout::Role role_for(Args... args) { return role_in_player_tray(TilePosition(std::forward<Args>(args)...)); }
SpellLayout::Role role_in_word(TileIndex idx, size_t word_length);
SpellLayout::Role role_for_score(int score);

}  // namespace UP

#endif  // __cplusplus
