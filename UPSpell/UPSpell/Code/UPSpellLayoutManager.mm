//
//  UPSpellLayoutManager.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UIFont+UP.h>
#import <UpKit/UPFontMetrics.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPUtility.h>

#include "UIFont+UPSpell.h"
#include "UPSpellModel.h"
#include "UPSpellLayoutManager.h"

namespace UP {

void SpellLayoutManager::calculate()
{
    set_aspect_ratio(up_aspect_ratio_for_rect(canvas_frame()));
    if (up_is_fuzzy_equal(aspect_ratio(), CanonicalAspectRatio)) {
        set_aspect_mode(AspectMode::Canonical);
        set_layout_scale(1);
    }
    else if (aspect_ratio() > CanonicalAspectRatio) {
        set_aspect_mode(AspectMode::WiderThanCanonical);
        CGFloat canvas_width = CGRectGetWidth(canvas_frame());
        CGFloat canvas_height = CGRectGetHeight(canvas_frame());
        CGFloat conversion_factor = CanonicalCanvasWidth / canvas_width;
        CGFloat converted_height = canvas_height * conversion_factor;
        set_aspect_scale(converted_height / CanonicalCanvasHeight);
        CGFloat effective_width = floor(canvas_width * aspect_scale());
        CGFloat effective_height = canvas_height;
        
        // layout frame is letterboxed, leaving gaps on the left and right.
        CGFloat letterbox_inset = (canvas_width - effective_width) * 0.5;
        m_letterbox_insets = UIEdgeInsetsMake(0, letterbox_inset, 0, letterbox_inset);
        set_layout_scale(effective_height / CanonicalCanvasHeight);
        set_layout_frame(up_rect_centered_in_rect(CGRectMake(0, 0, effective_width, effective_height), canvas_frame()));
        LOG(LayoutManager, "layout manager wider:  %.2f, %.2f", effective_width, effective_height);
        LOG(LayoutManager, "        aspect_scale:  %.3f", aspect_scale());
        LOG(LayoutManager, "        layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        LOG(LayoutManager, "        layout_scale:  %.3f", layout_scale());
        LOG(LayoutManager, "     letterbox_insets: %@", NSStringFromUIEdgeInsets(letterbox_insets()));
    }
    else {
        set_aspect_mode(AspectMode::TallerThanCanonical);
        CGFloat canvas_width = CGRectGetWidth(canvas_frame());
        CGFloat canvas_height = CGRectGetHeight(canvas_frame());
        CGFloat conversion_factor = CanonicalCanvasHeight / canvas_height;
        CGFloat converted_width = canvas_width * conversion_factor;
        set_aspect_scale(converted_width / CanonicalCanvasWidth);
        CGFloat effective_width = canvas_width;
        CGFloat effective_height = floor(canvas_height * aspect_scale());
        
        // layout frame is letterboxed, leaving gaps on the top and bottom.
        CGFloat letterbox_inset = (canvas_height - effective_height) * 0.5;
        m_letterbox_insets = UIEdgeInsetsMake(letterbox_inset, 0, letterbox_inset, 0);
        set_layout_scale(effective_width / CanonicalCanvasWidth);
        set_layout_frame(up_rect_centered_in_rect(CGRectMake(0, 0, effective_width, effective_height), canvas_frame()));

        LOG(LayoutManager, "layout manager taller:  %.2f, %.2f", effective_width, effective_height);
        LOG(LayoutManager, "         aspect_scale:  %.3f", aspect_scale());
        LOG(LayoutManager, "         layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        LOG(LayoutManager, "         layout_scale:  %.3f", layout_scale());
        LOG(LayoutManager, "     letterbox_insets:  %@", NSStringFromUIEdgeInsets(letterbox_insets()));
    }

    calculate_controls_layout_frame();
    calculate_tile_size();
    calculate_word_tray_layout_frame();
    calculate_word_tray_mask_frame();
    calculate_word_tray_shake_amount();
    calculate_player_tray_layout_frame();
    calculate_word_tray_tile_frames();
    calculate_player_tray_tile_frames();
    calculate_offscreen_tray_tile_frames();
    calculate_controls_button_pause_frame();
    calculate_controls_button_trash_frame();
    calculate_game_information_font_metrics();
    calculate_game_information_superscript_font_metrics();
    calculate_game_time_label_frame();
    calculate_game_score_label_frame();
    calculate_tile_stroke_width();
}

void SpellLayoutManager::calculate_controls_layout_frame()
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            set_controls_layout_frame(CanonicalControlsLayoutFrame);
            break;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect frame = up_rect_scaled_centered_x_in_rect(CanonicalControlsLayoutFrame, layout_scale(), layout_frame());
            set_controls_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalControlsLayoutFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 50% the letterbox inset
            // That's what looks good.
            frame.origin.y -= letterbox_insets().top * 0.5;
            set_controls_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
    }
    LOG(LayoutManager, "controls layout frame:   %@", NSStringFromCGRect(controls_layout_frame()));
}

void SpellLayoutManager::calculate_word_tray_layout_frame()
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            set_word_tray_layout_frame(CanonicalWordTrayFrame);
            break;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect frame = up_rect_scaled_centered_x_in_rect(CanonicalWordTrayFrame, layout_scale(), layout_frame());
            set_word_tray_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalWordTrayFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 20% of the letterbox inset
            // That's what looks good.
            frame.origin.y -= letterbox_insets().top * 0.2;
            set_word_tray_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
    }
    LOG(LayoutManager, "word tray layout frame: %@", NSStringFromCGRect(word_tray_layout_frame()));
}

void SpellLayoutManager::calculate_word_tray_mask_frame()
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            set_word_tray_mask_frame(CanonicalWordTrayMaskFrame);
            break;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect frame = up_rect_scaled_centered_x_in_rect(CanonicalWordTrayMaskFrame, layout_scale(), layout_frame());
            set_word_tray_mask_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalWordTrayMaskFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 20% of the letterbox inset
            // That's what looks good.
            frame.origin.y -= letterbox_insets().top * 0.2;
            set_word_tray_mask_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
    }
    LOG(LayoutManager, "word tray mask frame: %@", NSStringFromCGRect(word_tray_mask_frame()));
}

void SpellLayoutManager::calculate_player_tray_layout_frame()
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            set_player_tray_layout_frame(CanonicalTilesLayoutFrame);
            break;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect frame = up_rect_scaled_centered_x_in_rect(CanonicalTilesLayoutFrame, layout_scale(), layout_frame());
            set_player_tray_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalTilesLayoutFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved down in the UI by 25% of the letterbox inset
            // That's what looks good.
            frame.origin.y += letterbox_insets().top * 0.25;
            set_player_tray_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
    }
    LOG(LayoutManager, "   tiles layout frame:  %@", NSStringFromCGRect(player_tray_layout_frame()));
}

void SpellLayoutManager::calculate_tile_size()
{
    CGSize size = up_size_scaled(CanonicalTileSize, layout_scale());
    set_tile_size(up_pixel_size(size, screen_scale()));
}

void SpellLayoutManager::calculate_tile_stroke_width()
{
    CGFloat stroke_width = CanonicalTileStrokeWidth * layout_scale();
    set_tile_stroke_width(stroke_width);

    CGRect stroke_bounds = CGRectMake(0, 0, up_size_width(CanonicalTileSize), up_size_height(CanonicalTileSize));
    CGRect stroke_inset = CGRectInset(stroke_bounds, CanonicalTileStrokeWidth, CanonicalTileStrokeWidth);

    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(up_rect_max_x(stroke_inset), up_rect_min_y(stroke_inset))];
    [path addLineToPoint: CGPointMake(up_rect_min_x(stroke_inset), up_rect_min_y(stroke_inset))];
    [path addLineToPoint: CGPointMake(up_rect_min_x(stroke_inset), up_rect_max_y(stroke_inset))];
    [path addLineToPoint: CGPointMake(up_rect_max_x(stroke_inset), up_rect_max_y(stroke_inset))];
    [path closePath];
    [path moveToPoint: CGPointMake(up_rect_max_x(stroke_bounds), up_rect_min_y(stroke_bounds))];
    [path addLineToPoint: CGPointMake(up_rect_max_x(stroke_bounds), up_rect_max_y(stroke_bounds))];
    [path addLineToPoint: CGPointMake(up_rect_min_x(stroke_bounds), up_rect_max_y(stroke_bounds))];
    [path addLineToPoint: CGPointMake(up_rect_min_x(stroke_bounds), up_rect_min_y(stroke_bounds))];
    [path closePath];
    m_tile_stroke_path = path;

    LOG(LayoutManager, "   tile stroke width:   %.2f", tile_stroke_width());
}

void SpellLayoutManager::calculate_controls_button_pause_frame()
{
    CGSize size = up_size_scaled(CanonicalRoundControlButtonSize, layout_scale());
    CGRect frame = CGRectMake(
        up_rect_min_x(controls_layout_frame()),
        up_rect_min_y(controls_layout_frame()),
        up_size_width(size),
        up_size_height(size)
    );
    set_controls_button_pause_frame(up_pixel_rect(frame, screen_scale()));
    LOG(LayoutManager, "   pause button frame:  %@", NSStringFromCGRect(controls_button_pause_frame()));
}

void SpellLayoutManager::calculate_controls_button_trash_frame()
{
    CGSize size = up_size_scaled(CanonicalRoundControlButtonSize, layout_scale());
    CGRect frame = CGRectMake(
        up_rect_max_x(controls_layout_frame()) - up_size_width(size),
        up_rect_min_y(controls_layout_frame()),
        up_size_width(size),
        up_size_height(size)
    );
    set_controls_button_trash_frame(up_pixel_rect(frame, screen_scale()));
    LOG(LayoutManager, "   trash button frame:  %@", NSStringFromCGRect(controls_button_trash_frame()));
}

void SpellLayoutManager::calculate_game_information_font_metrics()
{
    CGFloat cap_height = CanonicalGameInformationCapHeight * layout_scale();
    UIFont *font = [UIFont gameInformationFontWithCapHeight:cap_height];
    set_game_information_font_metrics(FontMetrics(font.fontName, font.pointSize));
}

void SpellLayoutManager::calculate_game_information_superscript_font_metrics()
{
    CGFloat cap_height = CanonicalGameInformationSuperscriptCapHeight * layout_scale();
    UIFont *font = [UIFont gameInformationFontWithCapHeight:cap_height];
    CGFloat baseline_adjustment = CanonicalGameInformationSuperscriptBaselineAdjustment * layout_scale();
    CGFloat kerning = CanonicalGameInformationSuperscriptKerning * layout_scale();
    set_game_information_superscript_font_metrics(FontMetrics(font.fontName, font.pointSize, baseline_adjustment, kerning));
}

void SpellLayoutManager::calculate_game_time_label_frame()
{
    const FontMetrics &font_metrics = game_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameTimeLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x - w;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_time_label_frame(up_pixel_rect(frame, screen_scale()));
    LOG(LayoutManager, "   time label frame:    %@", NSStringFromCGRect(game_time_label_frame()));
}

void SpellLayoutManager::calculate_game_score_label_frame()
{
    const FontMetrics &font_metrics = game_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameScoreLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameScoreLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_score_label_frame(up_pixel_rect(frame, screen_scale()));
    LOG(LayoutManager, "   score label frame:   %@", NSStringFromCGRect(game_score_label_frame()));
}

void SpellLayoutManager::calculate_word_tray_shake_amount()
{
    CGFloat amount = CanonicalWordTrayShakeAmount * layout_scale();
    set_word_tray_shake_amount(up_pixel_float(amount, screen_scale()));
}

void SpellLayoutManager::calculate_word_tray_tile_frames()
{
    CGSize canonicalSize = CanonicalTileSize;
    CGSize size = up_size_scaled(canonicalSize, layout_scale());
    CGFloat gap = CanonicalTileGap * layout_scale();
    
    CGFloat x = up_rect_min_x(player_tray_layout_frame());
    CGFloat y = up_rect_min_y(word_tray_layout_frame());
    TileRectArray rects;
    TilePointArray centers;
    for (size_t idx = 0; idx < TileCount; idx++) {
        CGRect rect = CGRectMake(x, y, up_size_width(size), up_size_height(size));
        rect = up_rect_centered_y_in_rect(rect, word_tray_layout_frame());
        CGRect frame = up_pixel_rect(rect, screen_scale());
        rects[idx] = frame;
        centers[idx] = up_pixel_point(up_rect_center(frame), screen_scale());
        x += up_size_width(size) + gap;
    }
    
    TileRectArray odd_rects = rects;
    TilePointArray odd_centers = centers;

    // length 7
    m_word_tray_tile_frames[6] = odd_rects;
    m_word_tray_tile_centers[6] = odd_centers;

    // length 5
    shift_left(odd_rects.begin(), odd_rects.end(), 1);
    std::fill(odd_rects.begin() + 5, odd_rects.end(), CGRectZero);
    shift_left(odd_centers.begin(), odd_centers.end(), 1);
    std::fill(odd_centers.begin() + 5, odd_centers.end(), CGPointZero);
    m_word_tray_tile_frames[4] = odd_rects;
    m_word_tray_tile_centers[4] = odd_centers;

    // length 3
    shift_left(odd_rects.begin(), odd_rects.end(), 1);
    std::fill(odd_rects.begin() + 3, odd_rects.end(), CGRectZero);
    shift_left(odd_centers.begin(), odd_centers.end(), 1);
    std::fill(odd_centers.begin() + 3, odd_centers.end(), CGPointZero);
    m_word_tray_tile_frames[2] = odd_rects;
    m_word_tray_tile_centers[2] = odd_centers;

    // length 1
    shift_left(odd_rects.begin(), odd_rects.end(), 1);
    std::fill(odd_rects.begin() + 1, odd_rects.end(), CGRectZero);
    shift_left(odd_centers.begin(), odd_centers.end(), 1);
    std::fill(odd_centers.begin() + 1, odd_centers.end(), CGPointZero);
    m_word_tray_tile_frames[0] = odd_rects;
    m_word_tray_tile_centers[0] = odd_centers;

    // recentering
    TileRectArray even_rects = rects;
    TilePointArray even_centers = centers;
    CGFloat offset = (up_size_width(size) + gap) * 0.5;
    for (size_t idx = 0; idx < TileCount; idx++) {
        even_rects[idx] = up_pixel_rect(CGRectOffset(even_rects[idx], -offset, 0), screen_scale());
        even_centers[idx] = up_pixel_point(CGPointMake(even_centers[idx].x - offset, even_centers[idx].y), screen_scale());
    }
    
    // length 6
    shift_left(even_rects.begin(), even_rects.end(), 1);
    std::fill(even_rects.begin() + 6, even_rects.end(), CGRectZero);
    shift_left(even_centers.begin(), even_centers.end(), 1);
    std::fill(even_centers.begin() + 6, even_centers.end(), CGPointZero);
    m_word_tray_tile_frames[5] = even_rects;
    m_word_tray_tile_centers[5] = even_centers;

    // length 4
    shift_left(even_rects.begin(), even_rects.end(), 1);
    std::fill(even_rects.begin() + 4, even_rects.end(), CGRectZero);
    shift_left(even_centers.begin(), even_centers.end(), 1);
    std::fill(even_centers.begin() + 4, even_centers.end(), CGPointZero);
    m_word_tray_tile_frames[3] = even_rects;
    m_word_tray_tile_centers[3] = even_centers;

    // length 2
    shift_left(even_rects.begin(), even_rects.end(), 1);
    std::fill(even_rects.begin() + 2, even_rects.end(), CGRectZero);
    shift_left(even_centers.begin(), even_centers.end(), 1);
    std::fill(even_centers.begin() + 2, even_centers.end(), CGPointZero);
    m_word_tray_tile_frames[1] = even_rects;
    m_word_tray_tile_centers[1] = even_centers;

    int idx = 0;
    for (const auto &r : word_tray_tile_frames(2)) {
        LOG(LayoutManager, "   word tray frame [%d]:  %@", idx, NSStringFromCGRect(r));
        idx++;
    }
}

void SpellLayoutManager::calculate_player_tray_tile_frames()
{
    CGSize canonicalSize = CanonicalTileSize;
    CGSize size = up_size_scaled(canonicalSize, layout_scale());
    CGFloat gap = CanonicalTileGap * layout_scale();
    CGFloat x = up_rect_min_x(player_tray_layout_frame());
    CGFloat y = up_rect_min_y(player_tray_layout_frame());
    for (size_t idx = 0; idx < TileCount; idx++) {
        CGRect rect = CGRectMake(x, y, up_size_width(size), up_size_height(size));
        CGRect frame = up_pixel_rect(rect, screen_scale());
        m_player_tray_tile_frames[idx] = frame;
        m_player_tray_tile_centers[idx] = up_pixel_point(up_rect_center(frame), screen_scale());
        x += up_size_width(size) + gap;
    }
    int idx = 0;
    for (const auto &r : player_tray_tile_frames()) {
        LOG(LayoutManager, "   tile tray frame [%d]: %@", idx, NSStringFromCGRect(r));
        idx++;
    }
}

void SpellLayoutManager::calculate_offscreen_tray_tile_frames()
{
    CGSize canonicalSize = CanonicalTileSize;
    CGSize size = up_size_scaled(canonicalSize, layout_scale());
    CGFloat gap = CanonicalTileGap * layout_scale();
    CGFloat x = up_rect_min_x(player_tray_layout_frame());
    CGFloat y = up_rect_max_y(screen_bounds()) + (up_size_height(size) * 0.8);
    for (size_t idx = 0; idx < TileCount; idx++) {
        CGRect rect = CGRectMake(x, y, up_size_width(size), up_size_height(size));
        CGRect frame = up_pixel_rect(rect, screen_scale());
        m_offscreen_tray_tile_frames[idx] = frame;
        m_offscreen_tray_tile_centers[idx] = up_pixel_point(up_rect_center(frame), screen_scale());
        x += up_size_width(size) + gap;
    }
    int idx = 0;
    for (const auto &r : offscreen_tray_tile_frames()) {
        LOG(LayoutManager, "   fill tray frame [%d]: %@", idx, NSStringFromCGRect(r));
        idx++;
    }
}

}  // namespace UP
