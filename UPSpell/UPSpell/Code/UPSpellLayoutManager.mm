//
//  UPSpellLayoutManager.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UIFont+UP.h>
#import <UpKit/UPFontMetrics.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>

#include "UIFont+UPSpell.h"
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
        NSLog(@"layout manager wider:  %.2f, %.2f", effective_width, effective_height);
        NSLog(@"        aspect_scale:  %.3f", aspect_scale());
        NSLog(@"        layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        NSLog(@"        layout_scale:  %.3f", layout_scale());
        NSLog(@"     letterbox_insets: %@", NSStringFromUIEdgeInsets(letterbox_insets()));
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

        NSLog(@"layout manager taller:  %.2f, %.2f", effective_width, effective_height);
        NSLog(@"         aspect_scale:  %.3f", aspect_scale());
        NSLog(@"         layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        NSLog(@"         layout_scale:  %.3f", layout_scale());
        NSLog(@"     letterbox_insets:  %@", NSStringFromUIEdgeInsets(letterbox_insets()));
    }

    calculate_controls_layout_frame();
    calculate_word_tray_frame();
    calculate_tiles_layout_frame();
    calculate_controls_button_pause_frame();
    calculate_controls_button_trash_frame();
    calculate_gameplay_information_font_metrics();
    calculate_game_time_label_frame();
    calculate_game_score_label_frame();
    calculate_tile_frames();
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
    NSLog(@"controls layout frame:   %@", NSStringFromCGRect(controls_layout_frame()));
}

void SpellLayoutManager::calculate_word_tray_frame()
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
    NSLog(@"word tray layout frame: %@", NSStringFromCGRect(word_tray_layout_frame()));
}


void SpellLayoutManager::calculate_tiles_layout_frame()
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            set_tiles_layout_frame(CanonicalTilesLayoutFrame);
            break;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect frame = up_rect_scaled_centered_x_in_rect(CanonicalTilesLayoutFrame, layout_scale(), layout_frame());
            set_tiles_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalTilesLayoutFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved down in the UI by 25% of the letterbox inset
            // That's what looks good.
            frame.origin.y += letterbox_insets().top * 0.25;
            set_tiles_layout_frame(up_pixel_rect(frame, screen_scale()));
            break;
        }
    }
    NSLog(@"   tiles layout frame:  %@", NSStringFromCGRect(tiles_layout_frame()));
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
    NSLog(@"   pause button frame:  %@", NSStringFromCGRect(controls_button_pause_frame()));
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
    NSLog(@"   trash button frame:  %@", NSStringFromCGRect(controls_button_trash_frame()));
}

void SpellLayoutManager::calculate_gameplay_information_font_metrics()
{
    CGFloat cap_height = CanonicalGameplayInformationCapHeight * layout_scale();
    UIFont *font = [UIFont gameplayInformationFontWithCapHeight:cap_height];
    set_gameplay_information_font_metrics(FontMetrics(font.fontName, font.pointSize));
}

void SpellLayoutManager::calculate_game_time_label_frame()
{
    const FontMetrics &font_metrics = gameplay_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameTimeLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x - w;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_time_label_frame(up_pixel_rect(frame, screen_scale()));
    NSLog(@"   time label frame:    %@", NSStringFromCGRect(game_time_label_frame()));
}

void SpellLayoutManager::calculate_game_score_label_frame()
{
    const FontMetrics &font_metrics = gameplay_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameScoreLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameScoreLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_score_label_frame(up_pixel_rect(frame, screen_scale()));
    NSLog(@"   score label frame:   %@", NSStringFromCGRect(game_score_label_frame()));
}

void SpellLayoutManager::calculate_tile_frames()
{
    CGSize canonicalSize = CanonicalTileSize;
    CGSize size = up_size_scaled(canonicalSize, layout_scale());
    CGFloat gap = CanonicalTileGap * layout_scale();
    CGFloat x = up_rect_min_x(tiles_layout_frame());
    CGFloat y = up_rect_min_y(tiles_layout_frame());
    for (auto &tile_frame : m_tile_frames) {
        CGRect r = CGRectMake(x, y, up_size_width(size), up_size_height(size));
        tile_frame = r; //up_pixel_rect(r, screen_scale());
        x += up_size_width(size) + gap;
    }
    int idx = 0;
    for (const auto &r : tile_frames()) {
        NSLog(@"   tile frame [%d]:      %@", idx, NSStringFromCGRect(r));
        idx++;
    }
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

    NSLog(@"   tile stroke width:   %.2f", tile_stroke_width());
}

void SpellLayoutManager::create_canonical_tile_paths()
{
    m_canonical_tile_paths.clear();
    
    // A
    UIBezierPath *glyphAPath = [UIBezierPath bezierPath];
    [glyphAPath moveToPoint: CGPointMake(55.21, 63.11)];
    [glyphAPath addLineToPoint: CGPointMake(49.8, 41.3)];
    [glyphAPath addLineToPoint: CGPointMake(44.22, 63.11)];
    [glyphAPath addLineToPoint: CGPointMake(55.21, 63.11)];
    [glyphAPath closePath];
    [glyphAPath moveToPoint: CGPointMake(43.23, 27.69)];
    [glyphAPath addLineToPoint: CGPointMake(57.18, 27.69)];
    [glyphAPath addLineToPoint: CGPointMake(73.18, 85.25)];
    [glyphAPath addLineToPoint: CGPointMake(60.22, 85.25)];
    [glyphAPath addLineToPoint: CGPointMake(57.26, 73.04)];
    [glyphAPath addLineToPoint: CGPointMake(42.08, 73.04)];
    [glyphAPath addLineToPoint: CGPointMake(39.13, 85.25)];
    [glyphAPath addLineToPoint: CGPointMake(26.82, 85.25)];
    [glyphAPath addLineToPoint: CGPointMake(43.23, 27.69)];
    [glyphAPath closePath];
    m_canonical_tile_paths[U'A'] = glyphAPath;

    // B
    UIBezierPath *glyphBPath = [UIBezierPath bezierPath];
    [glyphBPath moveToPoint: CGPointMake(48.97, 75.91)];
    [glyphBPath addCurveToPoint: CGPointMake(56.77, 68.2) controlPoint1: CGPointMake(53.81, 75.91) controlPoint2: CGPointMake(56.77, 72.71)];
    [glyphBPath addCurveToPoint: CGPointMake(48.73, 60.41) controlPoint1: CGPointMake(56.77, 63.11) controlPoint2: CGPointMake(53.81, 60.41)];
    [glyphBPath addLineToPoint: CGPointMake(45.04, 60.41)];
    [glyphBPath addLineToPoint: CGPointMake(45.04, 75.91)];
    [glyphBPath addLineToPoint: CGPointMake(48.97, 75.91)];
    [glyphBPath closePath];
    [glyphBPath moveToPoint: CGPointMake(45.04, 51.8)];
    [glyphBPath addLineToPoint: CGPointMake(48.48, 51.8)];
    [glyphBPath addCurveToPoint: CGPointMake(55.78, 44.25) controlPoint1: CGPointMake(53.08, 51.8) controlPoint2: CGPointMake(55.78, 48.76)];
    [glyphBPath addCurveToPoint: CGPointMake(48.89, 37.2) controlPoint1: CGPointMake(55.78, 39.83) controlPoint2: CGPointMake(53.16, 37.2)];
    [glyphBPath addLineToPoint: CGPointMake(45.04, 37.2)];
    [glyphBPath addLineToPoint: CGPointMake(45.04, 51.8)];
    [glyphBPath closePath];
    [glyphBPath moveToPoint: CGPointMake(49.88, 85.25)];
    [glyphBPath addLineToPoint: CGPointMake(33.55, 85.25)];
    [glyphBPath addLineToPoint: CGPointMake(33.55, 27.85)];
    [glyphBPath addLineToPoint: CGPointMake(50.04, 27.85)];
    [glyphBPath addCurveToPoint: CGPointMake(67.27, 43.02) controlPoint1: CGPointMake(61.12, 27.85) controlPoint2: CGPointMake(67.27, 33.76)];
    [glyphBPath addCurveToPoint: CGPointMake(59.72, 55.65) controlPoint1: CGPointMake(67.27, 48.76) controlPoint2: CGPointMake(64.64, 53.19)];
    [glyphBPath addCurveToPoint: CGPointMake(68.58, 68.94) controlPoint1: CGPointMake(65.22, 58.11) controlPoint2: CGPointMake(68.58, 62.62)];
    [glyphBPath addCurveToPoint: CGPointMake(49.88, 85.25) controlPoint1: CGPointMake(68.58, 79.27) controlPoint2: CGPointMake(60.79, 85.25)];
    [glyphBPath closePath];
    [glyphBPath fill];
    m_canonical_tile_paths[U'B'] = glyphBPath;

    // C
    UIBezierPath *glyphCPath = [UIBezierPath bezierPath];
    [glyphCPath moveToPoint: CGPointMake(32.52, 56.55)];
    [glyphCPath addCurveToPoint: CGPointMake(54.1, 26.95) controlPoint1: CGPointMake(32.52, 38.35) controlPoint2: CGPointMake(41.55, 26.95)];
    [glyphCPath addCurveToPoint: CGPointMake(66.9, 31.62) controlPoint1: CGPointMake(59.68, 26.95) controlPoint2: CGPointMake(64.03, 29.16)];
    [glyphCPath addLineToPoint: CGPointMake(66.9, 44.5)];
    [glyphCPath addLineToPoint: CGPointMake(66.74, 44.5)];
    [glyphCPath addCurveToPoint: CGPointMake(55.74, 38.19) controlPoint1: CGPointMake(63.7, 41.14) controlPoint2: CGPointMake(59.76, 38.19)];
    [glyphCPath addCurveToPoint: CGPointMake(45, 56.39) controlPoint1: CGPointMake(49.67, 38.19) controlPoint2: CGPointMake(45, 45.32)];
    [glyphCPath addCurveToPoint: CGPointMake(55.74, 74.92) controlPoint1: CGPointMake(45, 68.53) controlPoint2: CGPointMake(49.67, 74.92)];
    [glyphCPath addCurveToPoint: CGPointMake(67.23, 68.77) controlPoint1: CGPointMake(59.93, 74.92) controlPoint2: CGPointMake(63.95, 72.3)];
    [glyphCPath addLineToPoint: CGPointMake(67.48, 68.85)];
    [glyphCPath addLineToPoint: CGPointMake(66.41, 81.48)];
    [glyphCPath addCurveToPoint: CGPointMake(53.28, 86.16) controlPoint1: CGPointMake(63.21, 84.02) controlPoint2: CGPointMake(59.03, 86.16)];
    [glyphCPath addCurveToPoint: CGPointMake(32.52, 56.55) controlPoint1: CGPointMake(41.38, 86.16) controlPoint2: CGPointMake(32.52, 75.5)];
    [glyphCPath closePath];
    m_canonical_tile_paths[U'C'] = glyphCPath;

    // D
    UIBezierPath *glyphDPath = [UIBezierPath bezierPath];
    [glyphDPath moveToPoint: CGPointMake(43.15, 38.6)];
    [glyphDPath addLineToPoint: CGPointMake(43.15, 74.51)];
    [glyphDPath addLineToPoint: CGPointMake(45.2, 74.51)];
    [glyphDPath addCurveToPoint: CGPointMake(58.41, 56.55) controlPoint1: CGPointMake(53.82, 74.51) controlPoint2: CGPointMake(58.41, 68.2)];
    [glyphDPath addCurveToPoint: CGPointMake(45.12, 38.6) controlPoint1: CGPointMake(58.41, 44.58) controlPoint2: CGPointMake(53.98, 38.6)];
    [glyphDPath addLineToPoint: CGPointMake(43.15, 38.6)];
    [glyphDPath closePath];
    [glyphDPath moveToPoint: CGPointMake(31.09, 27.85)];
    [glyphDPath addLineToPoint: CGPointMake(44.46, 27.85)];
    [glyphDPath addCurveToPoint: CGPointMake(70.88, 56.39) controlPoint1: CGPointMake(62.02, 27.85) controlPoint2: CGPointMake(70.88, 38.6)];
    [glyphDPath addCurveToPoint: CGPointMake(44.3, 85.25) controlPoint1: CGPointMake(70.88, 73.77) controlPoint2: CGPointMake(61.86, 85.25)];
    [glyphDPath addLineToPoint: CGPointMake(31.09, 85.25)];
    [glyphDPath addLineToPoint: CGPointMake(31.09, 27.85)];
    [glyphDPath closePath];
    m_canonical_tile_paths[U'D'] = glyphDPath;

    // E
    UIBezierPath *glyphEPath = [UIBezierPath bezierPath];
    [glyphEPath moveToPoint: CGPointMake(35.89, 27.85)];
    [glyphEPath addLineToPoint: CGPointMake(64.28, 27.85)];
    [glyphEPath addLineToPoint: CGPointMake(65.83, 38.35)];
    [glyphEPath addLineToPoint: CGPointMake(47.95, 38.35)];
    [glyphEPath addLineToPoint: CGPointMake(47.95, 51.14)];
    [glyphEPath addLineToPoint: CGPointMake(63.13, 51.14)];
    [glyphEPath addLineToPoint: CGPointMake(63.13, 61.23)];
    [glyphEPath addLineToPoint: CGPointMake(47.95, 61.23)];
    [glyphEPath addLineToPoint: CGPointMake(47.95, 74.76)];
    [glyphEPath addLineToPoint: CGPointMake(66, 74.76)];
    [glyphEPath addLineToPoint: CGPointMake(64.44, 85.25)];
    [glyphEPath addLineToPoint: CGPointMake(35.89, 85.25)];
    [glyphEPath addLineToPoint: CGPointMake(35.89, 27.85)];
    [glyphEPath closePath];
    m_canonical_tile_paths[U'E'] = glyphEPath;

    // F
    UIBezierPath *glyphFPath = [UIBezierPath bezierPath];
    [glyphFPath moveToPoint: CGPointMake(48.77, 63.11)];
    [glyphFPath addLineToPoint: CGPointMake(48.77, 85.25)];
    [glyphFPath addLineToPoint: CGPointMake(36.63, 85.25)];
    [glyphFPath addLineToPoint: CGPointMake(36.63, 27.85)];
    [glyphFPath addLineToPoint: CGPointMake(66, 27.85)];
    [glyphFPath addLineToPoint: CGPointMake(64.44, 38.43)];
    [glyphFPath addLineToPoint: CGPointMake(48.77, 38.43)];
    [glyphFPath addLineToPoint: CGPointMake(48.77, 52.86)];
    [glyphFPath addLineToPoint: CGPointMake(63.05, 52.86)];
    [glyphFPath addLineToPoint: CGPointMake(63.05, 63.11)];
    [glyphFPath addLineToPoint: CGPointMake(48.77, 63.11)];
    [glyphFPath closePath];
    m_canonical_tile_paths[U'F'] = glyphFPath;
    
    // G
    UIBezierPath *glyphGPath = [UIBezierPath bezierPath];
    [glyphGPath moveToPoint: CGPointMake(51.93, 86.16)];
    [glyphGPath addCurveToPoint: CGPointMake(29.69, 56.88) controlPoint1: CGPointMake(38.8, 86.16) controlPoint2: CGPointMake(29.69, 75.99)];
    [glyphGPath addCurveToPoint: CGPointMake(53.49, 26.95) controlPoint1: CGPointMake(29.69, 37.94) controlPoint2: CGPointMake(38.88, 26.95)];
    [glyphGPath addCurveToPoint: CGPointMake(67.76, 31.3) controlPoint1: CGPointMake(58.9, 26.95) controlPoint2: CGPointMake(63.99, 28.76)];
    [glyphGPath addLineToPoint: CGPointMake(67.76, 43.68)];
    [glyphGPath addLineToPoint: CGPointMake(67.6, 43.68)];
    [glyphGPath addCurveToPoint: CGPointMake(54.31, 38.1) controlPoint1: CGPointMake(63.58, 40.48) controlPoint2: CGPointMake(59.39, 38.1)];
    [glyphGPath addCurveToPoint: CGPointMake(42.16, 56.8) controlPoint1: CGPointMake(47.25, 38.1) controlPoint2: CGPointMake(42.16, 44.34)];
    [glyphGPath addCurveToPoint: CGPointMake(53.65, 75.66) controlPoint1: CGPointMake(42.16, 69.92) controlPoint2: CGPointMake(46.35, 75.66)];
    [glyphGPath addCurveToPoint: CGPointMake(58, 74.92) controlPoint1: CGPointMake(55.21, 75.66) controlPoint2: CGPointMake(56.6, 75.41)];
    [glyphGPath addLineToPoint: CGPointMake(58, 62.54)];
    [glyphGPath addLineToPoint: CGPointMake(50.62, 62.54)];
    [glyphGPath addLineToPoint: CGPointMake(50.62, 53.44)];
    [glyphGPath addLineToPoint: CGPointMake(68.75, 53.44)];
    [glyphGPath addLineToPoint: CGPointMake(68.75, 80.58)];
    [glyphGPath addCurveToPoint: CGPointMake(51.93, 86.16) controlPoint1: CGPointMake(64.07, 83.94) controlPoint2: CGPointMake(58.49, 86.16)];
    [glyphGPath closePath];
    m_canonical_tile_paths[U'G'] = glyphGPath;

    // H
    UIBezierPath *glyphHPath = [UIBezierPath bezierPath];
    [glyphHPath moveToPoint: CGPointMake(57.59, 61.56)];
    [glyphHPath addLineToPoint: CGPointMake(42.41, 61.56)];
    [glyphHPath addLineToPoint: CGPointMake(42.41, 85.25)];
    [glyphHPath addLineToPoint: CGPointMake(30.27, 85.25)];
    [glyphHPath addLineToPoint: CGPointMake(30.27, 27.85)];
    [glyphHPath addLineToPoint: CGPointMake(42.41, 27.85)];
    [glyphHPath addLineToPoint: CGPointMake(42.41, 50.73)];
    [glyphHPath addLineToPoint: CGPointMake(57.59, 50.73)];
    [glyphHPath addLineToPoint: CGPointMake(57.59, 27.85)];
    [glyphHPath addLineToPoint: CGPointMake(69.73, 27.85)];
    [glyphHPath addLineToPoint: CGPointMake(69.73, 85.25)];
    [glyphHPath addLineToPoint: CGPointMake(57.59, 85.25)];
    [glyphHPath addLineToPoint: CGPointMake(57.59, 61.56)];
    [glyphHPath closePath];
    m_canonical_tile_paths[U'H'] = glyphHPath;
    
    // I
    UIBezierPath *glyphIPath = [UIBezierPath bezierPathWithRect: CGRectMake(43.92, 27.85, 12.15, 57.4)];
    m_canonical_tile_paths[U'I'] = glyphIPath;
    
    // J
    UIBezierPath *glyphJPath = [UIBezierPath bezierPath];
    [glyphJPath moveToPoint: CGPointMake(49.22, 27.85)];
    [glyphJPath addLineToPoint: CGPointMake(61.36, 27.85)];
    [glyphJPath addLineToPoint: CGPointMake(61.36, 69.84)];
    [glyphJPath addCurveToPoint: CGPointMake(46.6, 86.07) controlPoint1: CGPointMake(61.36, 80.66) controlPoint2: CGPointMake(55.54, 86.07)];
    [glyphJPath addCurveToPoint: CGPointMake(37.24, 83.78) controlPoint1: CGPointMake(42.57, 86.07) controlPoint2: CGPointMake(39.54, 85.09)];
    [glyphJPath addLineToPoint: CGPointMake(36.01, 72.54)];
    [glyphJPath addLineToPoint: CGPointMake(36.26, 72.46)];
    [glyphJPath addCurveToPoint: CGPointMake(43.72, 75.17) controlPoint1: CGPointMake(38.72, 74.1) controlPoint2: CGPointMake(41.02, 75.17)];
    [glyphJPath addCurveToPoint: CGPointMake(49.22, 68.61) controlPoint1: CGPointMake(47.09, 75.17) controlPoint2: CGPointMake(49.22, 72.95)];
    [glyphJPath addLineToPoint: CGPointMake(49.22, 27.85)];
    [glyphJPath closePath];
    m_canonical_tile_paths[U'J'] = glyphJPath;

    // K
    UIBezierPath *glyphKPath = [UIBezierPath bezierPath];
    [glyphKPath moveToPoint: CGPointMake(44.95, 60.57)];
    [glyphKPath addLineToPoint: CGPointMake(44.3, 60.57)];
    [glyphKPath addLineToPoint: CGPointMake(44.3, 85.25)];
    [glyphKPath addLineToPoint: CGPointMake(32.16, 85.25)];
    [glyphKPath addLineToPoint: CGPointMake(32.16, 27.85)];
    [glyphKPath addLineToPoint: CGPointMake(44.3, 27.85)];
    [glyphKPath addLineToPoint: CGPointMake(44.3, 51.72)];
    [glyphKPath addLineToPoint: CGPointMake(44.79, 51.72)];
    [glyphKPath addLineToPoint: CGPointMake(57.92, 27.85)];
    [glyphKPath addLineToPoint: CGPointMake(71.46, 27.85)];
    [glyphKPath addLineToPoint: CGPointMake(71.46, 28.02)];
    [glyphKPath addLineToPoint: CGPointMake(55.29, 55.24)];
    [glyphKPath addLineToPoint: CGPointMake(71.87, 85.09)];
    [glyphKPath addLineToPoint: CGPointMake(71.87, 85.25)];
    [glyphKPath addLineToPoint: CGPointMake(58.08, 85.25)];
    [glyphKPath addLineToPoint: CGPointMake(44.95, 60.57)];
    [glyphKPath closePath];
    m_canonical_tile_paths[U'K'] = glyphKPath;
    
    // L
    UIBezierPath *glyphLPath = [UIBezierPath bezierPath];
    [glyphLPath moveToPoint: CGPointMake(37.69, 27.85)];
    [glyphLPath addLineToPoint: CGPointMake(49.84, 27.85)];
    [glyphLPath addLineToPoint: CGPointMake(49.84, 74.59)];
    [glyphLPath addLineToPoint: CGPointMake(65.75, 74.59)];
    [glyphLPath addLineToPoint: CGPointMake(65.75, 85.25)];
    [glyphLPath addLineToPoint: CGPointMake(37.69, 85.25)];
    [glyphLPath addLineToPoint: CGPointMake(37.69, 27.85)];
    [glyphLPath closePath];
    m_canonical_tile_paths[U'L'] = glyphLPath;

    // M
    UIBezierPath *glyphMPath = [UIBezierPath bezierPath];
    [glyphMPath moveToPoint: CGPointMake(50, 61.06)];
    [glyphMPath addLineToPoint: CGPointMake(59.52, 27.85)];
    [glyphMPath addLineToPoint: CGPointMake(76.25, 27.85)];
    [glyphMPath addLineToPoint: CGPointMake(76.25, 85.25)];
    [glyphMPath addLineToPoint: CGPointMake(64.52, 85.25)];
    [glyphMPath addLineToPoint: CGPointMake(64.6, 43.52)];
    [glyphMPath addLineToPoint: CGPointMake(51.56, 85.58)];
    [glyphMPath addLineToPoint: CGPointMake(47.78, 85.58)];
    [glyphMPath addLineToPoint: CGPointMake(34.74, 43.6)];
    [glyphMPath addLineToPoint: CGPointMake(34.9, 85.25)];
    [glyphMPath addLineToPoint: CGPointMake(23.75, 85.25)];
    [glyphMPath addLineToPoint: CGPointMake(23.75, 27.85)];
    [glyphMPath addLineToPoint: CGPointMake(40.48, 27.85)];
    [glyphMPath addLineToPoint: CGPointMake(50, 61.06)];
    [glyphMPath closePath];
    m_canonical_tile_paths[U'M'] = glyphMPath;
    
    // N
    UIBezierPath *glyphNPath = [UIBezierPath bezierPath];
    [glyphNPath moveToPoint: CGPointMake(30.31, 27.85)];
    [glyphNPath addLineToPoint: CGPointMake(41.8, 27.85)];
    [glyphNPath addLineToPoint: CGPointMake(58.53, 59.1)];
    [glyphNPath addLineToPoint: CGPointMake(58.45, 27.85)];
    [glyphNPath addLineToPoint: CGPointMake(69.69, 27.85)];
    [glyphNPath addLineToPoint: CGPointMake(69.69, 85.42)];
    [glyphNPath addLineToPoint: CGPointMake(60.67, 85.42)];
    [glyphNPath addLineToPoint: CGPointMake(41.39, 50.32)];
    [glyphNPath addLineToPoint: CGPointMake(41.55, 85.25)];
    [glyphNPath addLineToPoint: CGPointMake(30.31, 85.25)];
    [glyphNPath addLineToPoint: CGPointMake(30.31, 27.85)];
    [glyphNPath closePath];
    m_canonical_tile_paths[U'N'] = glyphNPath;
    
    // O
    UIBezierPath *glyphOPath = [UIBezierPath bezierPath];
    [glyphOPath moveToPoint: CGPointMake(49.96, 75.58)];
    [glyphOPath addCurveToPoint: CGPointMake(59.4, 56.55) controlPoint1: CGPointMake(55.62, 75.58) controlPoint2: CGPointMake(59.4, 69.02)];
    [glyphOPath addCurveToPoint: CGPointMake(49.96, 37.53) controlPoint1: CGPointMake(59.4, 44.09) controlPoint2: CGPointMake(55.7, 37.53)];
    [glyphOPath addCurveToPoint: CGPointMake(40.61, 56.55) controlPoint1: CGPointMake(44.3, 37.53) controlPoint2: CGPointMake(40.61, 44.09)];
    [glyphOPath addCurveToPoint: CGPointMake(49.96, 75.58) controlPoint1: CGPointMake(40.61, 68.94) controlPoint2: CGPointMake(44.22, 75.58)];
    [glyphOPath closePath];
    [glyphOPath moveToPoint: CGPointMake(50.04, 26.71)];
    [glyphOPath addCurveToPoint: CGPointMake(71.78, 56.55) controlPoint1: CGPointMake(63.33, 26.71) controlPoint2: CGPointMake(71.78, 38.43)];
    [glyphOPath addCurveToPoint: CGPointMake(49.96, 86.4) controlPoint1: CGPointMake(71.78, 74.68) controlPoint2: CGPointMake(63.25, 86.4)];
    [glyphOPath addCurveToPoint: CGPointMake(28.22, 56.55) controlPoint1: CGPointMake(36.67, 86.4) controlPoint2: CGPointMake(28.22, 74.68)];
    [glyphOPath addCurveToPoint: CGPointMake(50.04, 26.71) controlPoint1: CGPointMake(28.22, 38.43) controlPoint2: CGPointMake(36.75, 26.71)];
    [glyphOPath closePath];
    m_canonical_tile_paths[U'O'] = glyphOPath;

    // P
    UIBezierPath *glyphPPath = [UIBezierPath bezierPath];
    [glyphPPath moveToPoint: CGPointMake(45.98, 37.94)];
    [glyphPPath addLineToPoint: CGPointMake(45.98, 56.72)];
    [glyphPPath addLineToPoint: CGPointMake(48.44, 56.72)];
    [glyphPPath addCurveToPoint: CGPointMake(56.73, 46.96) controlPoint1: CGPointMake(53.28, 56.72) controlPoint2: CGPointMake(56.73, 53.93)];
    [glyphPPath addCurveToPoint: CGPointMake(48.53, 37.94) controlPoint1: CGPointMake(56.73, 40.48) controlPoint2: CGPointMake(53.28, 37.94)];
    [glyphPPath addLineToPoint: CGPointMake(45.98, 37.94)];
    [glyphPPath closePath];
    [glyphPPath moveToPoint: CGPointMake(46.06, 66.56)];
    [glyphPPath addLineToPoint: CGPointMake(46.06, 85.25)];
    [glyphPPath addLineToPoint: CGPointMake(33.92, 85.25)];
    [glyphPPath addLineToPoint: CGPointMake(33.92, 27.85)];
    [glyphPPath addLineToPoint: CGPointMake(48.77, 27.85)];
    [glyphPPath addCurveToPoint: CGPointMake(68.87, 46.8) controlPoint1: CGPointMake(61, 27.85) controlPoint2: CGPointMake(68.87, 34.09)];
    [glyphPPath addCurveToPoint: CGPointMake(48.94, 66.56) controlPoint1: CGPointMake(68.87, 59.83) controlPoint2: CGPointMake(60.5, 66.56)];
    [glyphPPath addLineToPoint: CGPointMake(46.06, 66.56)];
    [glyphPPath closePath];
    m_canonical_tile_paths[U'P'] = glyphPPath;

    // Q
    UIBezierPath *glyphQPath = [UIBezierPath bezierPath];
    [glyphQPath moveToPoint: CGPointMake(40.61, 56.55)];
    [glyphQPath addCurveToPoint: CGPointMake(50.04, 75.58) controlPoint1: CGPointMake(40.61, 68.94) controlPoint2: CGPointMake(44.3, 75.58)];
    [glyphQPath addCurveToPoint: CGPointMake(59.4, 56.55) controlPoint1: CGPointMake(55.7, 75.58) controlPoint2: CGPointMake(59.4, 69.02)];
    [glyphQPath addCurveToPoint: CGPointMake(49.96, 37.53) controlPoint1: CGPointMake(59.4, 44.09) controlPoint2: CGPointMake(55.7, 37.53)];
    [glyphQPath addCurveToPoint: CGPointMake(40.61, 56.55) controlPoint1: CGPointMake(44.3, 37.53) controlPoint2: CGPointMake(40.61, 44.09)];
    [glyphQPath closePath];
    [glyphQPath moveToPoint: CGPointMake(61.61, 95.59)];
    [glyphQPath addCurveToPoint: CGPointMake(46.76, 85.91) controlPoint1: CGPointMake(55.95, 95.59) controlPoint2: CGPointMake(51.11, 93.95)];
    [glyphQPath addCurveToPoint: CGPointMake(28.22, 56.47) controlPoint1: CGPointMake(35.27, 84.11) controlPoint2: CGPointMake(28.22, 72.95)];
    [glyphQPath addCurveToPoint: CGPointMake(50.04, 26.7) controlPoint1: CGPointMake(28.22, 38.43) controlPoint2: CGPointMake(36.75, 26.7)];
    [glyphQPath addCurveToPoint: CGPointMake(71.78, 56.23) controlPoint1: CGPointMake(63.33, 26.7) controlPoint2: CGPointMake(71.78, 38.35)];
    [glyphQPath addCurveToPoint: CGPointMake(59.07, 83.45) controlPoint1: CGPointMake(71.78, 69.59) controlPoint2: CGPointMake(67.03, 79.43)];
    [glyphQPath addCurveToPoint: CGPointMake(64.73, 86.81) controlPoint1: CGPointMake(60.63, 85.91) controlPoint2: CGPointMake(62.43, 86.81)];
    [glyphQPath addCurveToPoint: CGPointMake(70.47, 85.17) controlPoint1: CGPointMake(66.78, 86.81) controlPoint2: CGPointMake(68.67, 86.16)];
    [glyphQPath addLineToPoint: CGPointMake(70.64, 85.34)];
    [glyphQPath addLineToPoint: CGPointMake(68.01, 94.19)];
    [glyphQPath addCurveToPoint: CGPointMake(61.61, 95.59) controlPoint1: CGPointMake(66.37, 95.01) controlPoint2: CGPointMake(64.15, 95.59)];
    [glyphQPath closePath];
    m_canonical_tile_paths[U'Q'] = glyphQPath;

    // R
    UIBezierPath *glyphRPath = [UIBezierPath bezierPath];
    [glyphRPath moveToPoint: CGPointMake(44.79, 37.69)];
    [glyphRPath addLineToPoint: CGPointMake(44.79, 55.08)];
    [glyphRPath addLineToPoint: CGPointMake(47.5, 55.08)];
    [glyphRPath addCurveToPoint: CGPointMake(55.38, 46.06) controlPoint1: CGPointMake(52.34, 55.08) controlPoint2: CGPointMake(55.38, 51.88)];
    [glyphRPath addCurveToPoint: CGPointMake(47.74, 37.69) controlPoint1: CGPointMake(55.38, 40.24) controlPoint2: CGPointMake(52.5, 37.69)];
    [glyphRPath addLineToPoint: CGPointMake(44.79, 37.69)];
    [glyphRPath closePath];
    [glyphRPath moveToPoint: CGPointMake(47.33, 63.69)];
    [glyphRPath addLineToPoint: CGPointMake(44.96, 63.69)];
    [glyphRPath addLineToPoint: CGPointMake(44.96, 85.25)];
    [glyphRPath addLineToPoint: CGPointMake(32.81, 85.25)];
    [glyphRPath addLineToPoint: CGPointMake(32.81, 27.85)];
    [glyphRPath addLineToPoint: CGPointMake(48.32, 27.85)];
    [glyphRPath addCurveToPoint: CGPointMake(67.52, 45.4) controlPoint1: CGPointMake(60.13, 27.85) controlPoint2: CGPointMake(67.52, 33.84)];
    [glyphRPath addCurveToPoint: CGPointMake(58.66, 61.15) controlPoint1: CGPointMake(67.52, 52.95) controlPoint2: CGPointMake(63.91, 58.28)];
    [glyphRPath addLineToPoint: CGPointMake(71.62, 85.25)];
    [glyphRPath addLineToPoint: CGPointMake(58.08, 85.25)];
    [glyphRPath addLineToPoint: CGPointMake(47.33, 63.69)];
    [glyphRPath closePath];
    m_canonical_tile_paths[U'R'] = glyphRPath;

    // S
    UIBezierPath *glyphSPath = [UIBezierPath bezierPath];
    [glyphSPath moveToPoint: CGPointMake(50.7, 26.87)];
    [glyphSPath addCurveToPoint: CGPointMake(64.15, 31.13) controlPoint1: CGPointMake(56.03, 26.87) controlPoint2: CGPointMake(60.71, 28.59)];
    [glyphSPath addLineToPoint: CGPointMake(64.15, 43.11)];
    [glyphSPath addLineToPoint: CGPointMake(63.99, 43.11)];
    [glyphSPath addCurveToPoint: CGPointMake(51.19, 37.2) controlPoint1: CGPointMake(59.72, 39.5) controlPoint2: CGPointMake(55.21, 37.2)];
    [glyphSPath addCurveToPoint: CGPointMake(45.94, 42.04) controlPoint1: CGPointMake(47.99, 37.2) controlPoint2: CGPointMake(45.94, 39.17)];
    [glyphSPath addCurveToPoint: CGPointMake(53.32, 50.65) controlPoint1: CGPointMake(45.94, 44.99) controlPoint2: CGPointMake(47.83, 46.88)];
    [glyphSPath addCurveToPoint: CGPointMake(66.45, 69.84) controlPoint1: CGPointMake(61.86, 56.39) controlPoint2: CGPointMake(66.45, 61.39)];
    [glyphSPath addCurveToPoint: CGPointMake(49.06, 86.24) controlPoint1: CGPointMake(66.45, 80.01) controlPoint2: CGPointMake(59.23, 86.24)];
    [glyphSPath addCurveToPoint: CGPointMake(34.62, 81.24) controlPoint1: CGPointMake(43.15, 86.24) controlPoint2: CGPointMake(38.06, 84.19)];
    [glyphSPath addLineToPoint: CGPointMake(33.3, 68.2)];
    [glyphSPath addLineToPoint: CGPointMake(33.47, 68.03)];
    [glyphSPath addCurveToPoint: CGPointMake(48.4, 75.91) controlPoint1: CGPointMake(38.55, 72.87) controlPoint2: CGPointMake(44.46, 75.91)];
    [glyphSPath addCurveToPoint: CGPointMake(54.47, 70.49) controlPoint1: CGPointMake(52.01, 75.91) controlPoint2: CGPointMake(54.47, 73.77)];
    [glyphSPath addCurveToPoint: CGPointMake(46.76, 61.39) controlPoint1: CGPointMake(54.47, 67.3) controlPoint2: CGPointMake(52.26, 65.08)];
    [glyphSPath addCurveToPoint: CGPointMake(34.04, 42.78) controlPoint1: CGPointMake(38.8, 56.06) controlPoint2: CGPointMake(34.04, 51.47)];
    [glyphSPath addCurveToPoint: CGPointMake(50.7, 26.87) controlPoint1: CGPointMake(34.04, 33.35) controlPoint2: CGPointMake(40.52, 26.87)];
    [glyphSPath closePath];
    m_canonical_tile_paths[U'S'] = glyphSPath;

    // T
    UIBezierPath *glyphTPath = [UIBezierPath bezierPath];
    [glyphTPath moveToPoint: CGPointMake(56.52, 38.51)];
    [glyphTPath addLineToPoint: CGPointMake(56.52, 85.25)];
    [glyphTPath addLineToPoint: CGPointMake(44.38, 85.25)];
    [glyphTPath addLineToPoint: CGPointMake(44.38, 38.51)];
    [glyphTPath addLineToPoint: CGPointMake(31.42, 38.51)];
    [glyphTPath addLineToPoint: CGPointMake(31.42, 27.85)];
    [glyphTPath addLineToPoint: CGPointMake(69.57, 27.85)];
    [glyphTPath addLineToPoint: CGPointMake(69.57, 38.51)];
    [glyphTPath addLineToPoint: CGPointMake(56.52, 38.51)];
    [glyphTPath closePath];
    m_canonical_tile_paths[U'T'] = glyphTPath;

    // U
    UIBezierPath *glyphUPath = [UIBezierPath bezierPath];
    [glyphUPath moveToPoint: CGPointMake(30.68, 27.85)];
    [glyphUPath addLineToPoint: CGPointMake(42.82, 27.85)];
    [glyphUPath addLineToPoint: CGPointMake(42.82, 65.66)];
    [glyphUPath addCurveToPoint: CGPointMake(50.2, 75.5) controlPoint1: CGPointMake(42.82, 72.46) controlPoint2: CGPointMake(45.61, 75.5)];
    [glyphUPath addCurveToPoint: CGPointMake(57.51, 65.66) controlPoint1: CGPointMake(54.72, 75.5) controlPoint2: CGPointMake(57.51, 72.46)];
    [glyphUPath addLineToPoint: CGPointMake(57.51, 27.85)];
    [glyphUPath addLineToPoint: CGPointMake(69.4, 27.85)];
    [glyphUPath addLineToPoint: CGPointMake(69.4, 64.43)];
    [glyphUPath addCurveToPoint: CGPointMake(50.04, 86.24) controlPoint1: CGPointMake(69.4, 78.45) controlPoint2: CGPointMake(62.43, 86.24)];
    [glyphUPath addCurveToPoint: CGPointMake(30.68, 64.43) controlPoint1: CGPointMake(37.57, 86.24) controlPoint2: CGPointMake(30.68, 78.45)];
    [glyphUPath addLineToPoint: CGPointMake(30.68, 27.85)];
    [glyphUPath closePath];
    m_canonical_tile_paths[U'U'] = glyphUPath;

    // V
    UIBezierPath *glyphVPath = [UIBezierPath bezierPath];
    [glyphVPath moveToPoint: CGPointMake(55.78, 85.66)];
    [glyphVPath addLineToPoint: CGPointMake(44.05, 85.66)];
    [glyphVPath addLineToPoint: CGPointMake(27.97, 27.85)];
    [glyphVPath addLineToPoint: CGPointMake(41.01, 27.85)];
    [glyphVPath addLineToPoint: CGPointMake(50.37, 66.72)];
    [glyphVPath addLineToPoint: CGPointMake(59.72, 27.85)];
    [glyphVPath addLineToPoint: CGPointMake(72.03, 27.85)];
    [glyphVPath addLineToPoint: CGPointMake(55.78, 85.66)];
    [glyphVPath closePath];
    m_canonical_tile_paths[U'V'] = glyphVPath;
    
    // W
    UIBezierPath *glyphWPath = [UIBezierPath bezierPath];
    [glyphWPath moveToPoint: CGPointMake(69.69, 85.42)];
    [glyphWPath addLineToPoint: CGPointMake(58.2, 85.42)];
    [glyphWPath addLineToPoint: CGPointMake(50, 55.24)];
    [glyphWPath addLineToPoint: CGPointMake(41.79, 85.42)];
    [glyphWPath addLineToPoint: CGPointMake(30.39, 85.42)];
    [glyphWPath addLineToPoint: CGPointMake(18.49, 27.85)];
    [glyphWPath addLineToPoint: CGPointMake(30.8, 27.85)];
    [glyphWPath addLineToPoint: CGPointMake(37.53, 66.56)];
    [glyphWPath addLineToPoint: CGPointMake(48.44, 27.53)];
    [glyphWPath addLineToPoint: CGPointMake(51.97, 27.53)];
    [glyphWPath addLineToPoint: CGPointMake(62.88, 66.72)];
    [glyphWPath addLineToPoint: CGPointMake(69.61, 27.85)];
    [glyphWPath addLineToPoint: CGPointMake(81.5, 27.85)];
    [glyphWPath addLineToPoint: CGPointMake(69.69, 85.42)];
    [glyphWPath closePath];
    m_canonical_tile_paths[U'W'] = glyphWPath;
    
    // X
    UIBezierPath *glyphXPath = [UIBezierPath bezierPath];
    [glyphXPath moveToPoint: CGPointMake(50, 65)];
    [glyphXPath addLineToPoint: CGPointMake(41.46, 85.25)];
    [glyphXPath addLineToPoint: CGPointMake(28.34, 85.25)];
    [glyphXPath addLineToPoint: CGPointMake(42.28, 55.98)];
    [glyphXPath addLineToPoint: CGPointMake(28.91, 27.85)];
    [glyphXPath addLineToPoint: CGPointMake(41.96, 27.85)];
    [glyphXPath addLineToPoint: CGPointMake(50, 46.88)];
    [glyphXPath addLineToPoint: CGPointMake(57.96, 27.85)];
    [glyphXPath addLineToPoint: CGPointMake(71.08, 27.85)];
    [glyphXPath addLineToPoint: CGPointMake(57.71, 56.06)];
    [glyphXPath addLineToPoint: CGPointMake(71.74, 85.25)];
    [glyphXPath addLineToPoint: CGPointMake(58.61, 85.25)];
    [glyphXPath addLineToPoint: CGPointMake(50, 65)];
    [glyphXPath closePath];
    m_canonical_tile_paths[U'X'] = glyphXPath;
    
    // Y
    UIBezierPath *glyphYPath = [UIBezierPath bezierPath];
    [glyphYPath moveToPoint: CGPointMake(56.36, 63.03)];
    [glyphYPath addLineToPoint: CGPointMake(56.36, 85.25)];
    [glyphYPath addLineToPoint: CGPointMake(44.21, 85.25)];
    [glyphYPath addLineToPoint: CGPointMake(44.21, 63.2)];
    [glyphYPath addLineToPoint: CGPointMake(28.79, 27.85)];
    [glyphYPath addLineToPoint: CGPointMake(42.08, 27.85)];
    [glyphYPath addLineToPoint: CGPointMake(50.53, 50.81)];
    [glyphYPath addLineToPoint: CGPointMake(58.98, 27.85)];
    [glyphYPath addLineToPoint: CGPointMake(71.7, 27.85)];
    [glyphYPath addLineToPoint: CGPointMake(56.36, 63.03)];
    [glyphYPath closePath];
    m_canonical_tile_paths[U'Y'] = glyphYPath;
    
    // Z
    UIBezierPath *glyphZPath = [UIBezierPath bezierPath];
    [glyphZPath moveToPoint: CGPointMake(66.04, 85.25)];
    [glyphZPath addLineToPoint: CGPointMake(30.92, 85.25)];
    [glyphZPath addLineToPoint: CGPointMake(30.68, 84.76)];
    [glyphZPath addLineToPoint: CGPointMake(51.27, 38.51)];
    [glyphZPath addLineToPoint: CGPointMake(32.97, 38.51)];
    [glyphZPath addLineToPoint: CGPointMake(32.97, 27.85)];
    [glyphZPath addLineToPoint: CGPointMake(68.42, 27.85)];
    [glyphZPath addLineToPoint: CGPointMake(68.66, 28.35)];
    [glyphZPath addLineToPoint: CGPointMake(48.07, 74.59)];
    [glyphZPath addLineToPoint: CGPointMake(68.74, 74.59)];
    [glyphZPath addLineToPoint: CGPointMake(66.04, 85.25)];
    [glyphZPath closePath];
    m_canonical_tile_paths[U'Z'] = glyphZPath;

    // 1
    UIBezierPath *score1Path = [UIBezierPath bezierPath];
    [score1Path moveToPoint: CGPointMake(80.46, 94.3)];
    [score1Path addLineToPoint: CGPointMake(87.77, 90.68)];
    [score1Path addLineToPoint: CGPointMake(88.19, 90.81)];
    [score1Path addLineToPoint: CGPointMake(88.19, 106.67)];
    [score1Path addLineToPoint: CGPointMake(91.83, 106.67)];
    [score1Path addLineToPoint: CGPointMake(91.83, 109.95)];
    [score1Path addLineToPoint: CGPointMake(80.41, 109.95)];
    [score1Path addLineToPoint: CGPointMake(80.41, 106.67)];
    [score1Path addLineToPoint: CGPointMake(84.36, 106.67)];
    [score1Path addLineToPoint: CGPointMake(84.36, 96.19)];
    [score1Path addLineToPoint: CGPointMake(80.51, 98.15)];
    [score1Path addLineToPoint: CGPointMake(80.46, 98.12)];
    [score1Path addLineToPoint: CGPointMake(80.46, 94.3)];
    [score1Path closePath];
    m_canonical_tile_paths[U'1'] = score1Path;
    
    // 2
    UIBezierPath *score2Path = [UIBezierPath bezierPath];
    [score2Path moveToPoint: CGPointMake(91.39, 109.95)];
    [score2Path addLineToPoint: CGPointMake(79.76, 109.95)];
    [score2Path addLineToPoint: CGPointMake(79.63, 108.47)];
    [score2Path addLineToPoint: CGPointMake(85.77, 100.23)];
    [score2Path addCurveToPoint: CGPointMake(87.59, 96.38) controlPoint1: CGPointMake(87.04, 98.48) controlPoint2: CGPointMake(87.59, 97.34)];
    [score2Path addCurveToPoint: CGPointMake(85.43, 94.22) controlPoint1: CGPointMake(87.59, 95.05) controlPoint2: CGPointMake(86.7, 94.22)];
    [score2Path addCurveToPoint: CGPointMake(80.51, 97.63) controlPoint1: CGPointMake(83.61, 94.22) controlPoint2: CGPointMake(81.99, 95.73)];
    [score2Path addLineToPoint: CGPointMake(80.43, 97.6)];
    [score2Path addLineToPoint: CGPointMake(79.99, 93.75)];
    [score2Path addCurveToPoint: CGPointMake(86.11, 90.74) controlPoint1: CGPointMake(81.21, 92.19) controlPoint2: CGPointMake(83.14, 90.74)];
    [score2Path addCurveToPoint: CGPointMake(91.44, 95.81) controlPoint1: CGPointMake(89.33, 90.74) controlPoint2: CGPointMake(91.44, 92.79)];
    [score2Path addCurveToPoint: CGPointMake(88.5, 102.18) controlPoint1: CGPointMake(91.44, 97.91) controlPoint2: CGPointMake(90.45, 99.63)];
    [score2Path addLineToPoint: CGPointMake(85.09, 106.62)];
    [score2Path addLineToPoint: CGPointMake(92.14, 106.57)];
    [score2Path addLineToPoint: CGPointMake(91.39, 109.95)];
    [score2Path closePath];
    m_canonical_tile_paths[U'2'] = score2Path;
    
    // 3
    UIBezierPath *score3Path = [UIBezierPath bezierPath];
    [score3Path moveToPoint: CGPointMake(85.46, 110.24)];
    [score3Path addCurveToPoint: CGPointMake(80.23, 108.91) controlPoint1: CGPointMake(83.22, 110.24) controlPoint2: CGPointMake(81.55, 109.69)];
    [score3Path addLineToPoint: CGPointMake(79.84, 105.11)];
    [score3Path addLineToPoint: CGPointMake(79.89, 105.09)];
    [score3Path addCurveToPoint: CGPointMake(84.94, 106.99) controlPoint1: CGPointMake(81.61, 106.26) controlPoint2: CGPointMake(83.35, 106.99)];
    [score3Path addCurveToPoint: CGPointMake(87.88, 104.67) controlPoint1: CGPointMake(86.68, 106.99) controlPoint2: CGPointMake(87.88, 106.05)];
    [score3Path addCurveToPoint: CGPointMake(82.36, 101.11) controlPoint1: CGPointMake(87.88, 103.11) controlPoint2: CGPointMake(86.68, 102.1)];
    [score3Path addLineToPoint: CGPointMake(82.36, 99.68)];
    [score3Path addCurveToPoint: CGPointMake(87.62, 95.86) controlPoint1: CGPointMake(86.44, 98.2) controlPoint2: CGPointMake(87.62, 97.13)];
    [score3Path addCurveToPoint: CGPointMake(85.2, 93.99) controlPoint1: CGPointMake(87.62, 94.69) controlPoint2: CGPointMake(86.65, 93.99)];
    [score3Path addCurveToPoint: CGPointMake(80.33, 96.2) controlPoint1: CGPointMake(83.64, 93.99) controlPoint2: CGPointMake(81.94, 94.84)];
    [score3Path addLineToPoint: CGPointMake(80.28, 96.2)];
    [score3Path addLineToPoint: CGPointMake(80.28, 92.66)];
    [score3Path addCurveToPoint: CGPointMake(85.79, 90.74) controlPoint1: CGPointMake(81.61, 91.59) controlPoint2: CGPointMake(83.61, 90.74)];
    [score3Path addCurveToPoint: CGPointMake(91.49, 95.26) controlPoint1: CGPointMake(89.25, 90.74) controlPoint2: CGPointMake(91.49, 92.56)];
    [score3Path addCurveToPoint: CGPointMake(87.77, 100.07) controlPoint1: CGPointMake(91.49, 97.37) controlPoint2: CGPointMake(90.3, 98.87)];
    [score3Path addCurveToPoint: CGPointMake(91.75, 105.04) controlPoint1: CGPointMake(90.35, 100.95) controlPoint2: CGPointMake(91.75, 102.64)];
    [score3Path addCurveToPoint: CGPointMake(85.46, 110.24) controlPoint1: CGPointMake(91.75, 108.31) controlPoint2: CGPointMake(88.84, 110.24)];
    [score3Path closePath];
    m_canonical_tile_paths[U'3'] = score3Path;
    
    // 4
    UIBezierPath *score4Path = [UIBezierPath bezierPath];
    [score4Path moveToPoint: CGPointMake(82.62, 103.4)];
    [score4Path addLineToPoint: CGPointMake(86.99, 103.4)];
    [score4Path addLineToPoint: CGPointMake(86.99, 93.47)];
    [score4Path addLineToPoint: CGPointMake(82.62, 103.4)];
    [score4Path closePath];
    [score4Path moveToPoint: CGPointMake(79.11, 104.2)];
    [score4Path addLineToPoint: CGPointMake(85.46, 90.92)];
    [score4Path addLineToPoint: CGPointMake(90.48, 90.92)];
    [score4Path addLineToPoint: CGPointMake(90.48, 103.29)];
    [score4Path addLineToPoint: CGPointMake(92.48, 103.29)];
    [score4Path addLineToPoint: CGPointMake(92.48, 106.15)];
    [score4Path addLineToPoint: CGPointMake(90.48, 106.15)];
    [score4Path addLineToPoint: CGPointMake(90.48, 109.95)];
    [score4Path addLineToPoint: CGPointMake(86.84, 109.95)];
    [score4Path addLineToPoint: CGPointMake(86.84, 106.15)];
    [score4Path addLineToPoint: CGPointMake(79.42, 106.15)];
    [score4Path addLineToPoint: CGPointMake(79.11, 104.2)];
    [score4Path closePath];
    m_canonical_tile_paths[U'4'] = score4Path;
    
    // 5
    UIBezierPath *score5Path = [UIBezierPath bezierPath];
    [score5Path moveToPoint: CGPointMake(84.88, 110.24)];
    [score5Path addCurveToPoint: CGPointMake(80.38, 109.27) controlPoint1: CGPointMake(82.98, 110.24) controlPoint2: CGPointMake(81.48, 109.82)];
    [score5Path addLineToPoint: CGPointMake(80.07, 105.66)];
    [score5Path addLineToPoint: CGPointMake(80.15, 105.63)];
    [score5Path addCurveToPoint: CGPointMake(84.55, 107.04) controlPoint1: CGPointMake(81.74, 106.57) controlPoint2: CGPointMake(83.14, 107.04)];
    [score5Path addCurveToPoint: CGPointMake(87.88, 103.94) controlPoint1: CGPointMake(86.57, 107.04) controlPoint2: CGPointMake(87.88, 105.74)];
    [score5Path addCurveToPoint: CGPointMake(84.28, 100.93) controlPoint1: CGPointMake(87.88, 102.12) controlPoint2: CGPointMake(86.6, 100.93)];
    [score5Path addCurveToPoint: CGPointMake(80.8, 101.63) controlPoint1: CGPointMake(83.11, 100.93) controlPoint2: CGPointMake(81.94, 101.21)];
    [score5Path addLineToPoint: CGPointMake(80.54, 101.47)];
    [score5Path addLineToPoint: CGPointMake(81.09, 91.02)];
    [score5Path addLineToPoint: CGPointMake(90.95, 91.02)];
    [score5Path addLineToPoint: CGPointMake(90.95, 94.4)];
    [score5Path addLineToPoint: CGPointMake(84.1, 94.4)];
    [score5Path addLineToPoint: CGPointMake(83.9, 98.09)];
    [score5Path addCurveToPoint: CGPointMake(85.61, 97.94) controlPoint1: CGPointMake(84.39, 97.99) controlPoint2: CGPointMake(84.99, 97.94)];
    [score5Path addCurveToPoint: CGPointMake(91.8, 103.89) controlPoint1: CGPointMake(89.33, 97.94) controlPoint2: CGPointMake(91.8, 100.17)];
    [score5Path addCurveToPoint: CGPointMake(84.88, 110.24) controlPoint1: CGPointMake(91.8, 107.58) controlPoint2: CGPointMake(89.1, 110.24)];
    [score5Path closePath];
    m_canonical_tile_paths[U'5'] = score5Path;
    
    // 6
    UIBezierPath *score6Path = [UIBezierPath bezierPath];
    [score6Path moveToPoint: CGPointMake(85.9, 107.17)];
    [score6Path addCurveToPoint: CGPointMake(88.53, 103.63) controlPoint1: CGPointMake(87.51, 107.17) controlPoint2: CGPointMake(88.53, 105.74)];
    [score6Path addCurveToPoint: CGPointMake(85.56, 100.2) controlPoint1: CGPointMake(88.53, 101.29) controlPoint2: CGPointMake(87.33, 100.2)];
    [score6Path addCurveToPoint: CGPointMake(83.97, 100.36) controlPoint1: CGPointMake(85.04, 100.2) controlPoint2: CGPointMake(84.52, 100.25)];
    [score6Path addCurveToPoint: CGPointMake(83.3, 103.66) controlPoint1: CGPointMake(83.48, 101.53) controlPoint2: CGPointMake(83.3, 102.56)];
    [score6Path addCurveToPoint: CGPointMake(85.9, 107.17) controlPoint1: CGPointMake(83.3, 105.79) controlPoint2: CGPointMake(84.26, 107.17)];
    [score6Path closePath];
    [score6Path moveToPoint: CGPointMake(85.82, 110.34)];
    [score6Path addCurveToPoint: CGPointMake(79.63, 103.66) controlPoint1: CGPointMake(81.81, 110.34) controlPoint2: CGPointMake(79.63, 107.64)];
    [score6Path addCurveToPoint: CGPointMake(82.93, 94.64) controlPoint1: CGPointMake(79.63, 100.85) controlPoint2: CGPointMake(80.67, 98.25)];
    [score6Path addLineToPoint: CGPointMake(85.22, 91.02)];
    [score6Path addLineToPoint: CGPointMake(89.49, 91.02)];
    [score6Path addLineToPoint: CGPointMake(86.24, 95.88)];
    [score6Path addCurveToPoint: CGPointMake(85.2, 97.57) controlPoint1: CGPointMake(85.82, 96.53) controlPoint2: CGPointMake(85.48, 97.11)];
    [score6Path addCurveToPoint: CGPointMake(86.89, 97.39) controlPoint1: CGPointMake(85.74, 97.47) controlPoint2: CGPointMake(86.29, 97.39)];
    [score6Path addCurveToPoint: CGPointMake(92.17, 103.53) controlPoint1: CGPointMake(89.7, 97.39) controlPoint2: CGPointMake(92.17, 99.55)];
    [score6Path addCurveToPoint: CGPointMake(85.82, 110.34) controlPoint1: CGPointMake(92.17, 107.38) controlPoint2: CGPointMake(89.83, 110.34)];
    [score6Path closePath];
    m_canonical_tile_paths[U'6'] = score6Path;
    
    // 7
    UIBezierPath *score7Path = [UIBezierPath bezierPath];
    [score7Path moveToPoint: CGPointMake(85.07, 109.95)];
    [score7Path addLineToPoint: CGPointMake(81.06, 109.95)];
    [score7Path addLineToPoint: CGPointMake(87.36, 94.4)];
    [score7Path addLineToPoint: CGPointMake(80.12, 94.4)];
    [score7Path addLineToPoint: CGPointMake(79.71, 91.02)];
    [score7Path addLineToPoint: CGPointMake(92.3, 91.02)];
    [score7Path addLineToPoint: CGPointMake(92.38, 91.28)];
    [score7Path addLineToPoint: CGPointMake(85.07, 109.95)];
    [score7Path closePath];
    m_canonical_tile_paths[U'7'] = score7Path;
    
    // 8
    UIBezierPath *score8Path = [UIBezierPath bezierPath];
    [score8Path moveToPoint: CGPointMake(85.87, 99)];
    [score8Path addCurveToPoint: CGPointMake(88.11, 96.27) controlPoint1: CGPointMake(87.2, 99) controlPoint2: CGPointMake(88.11, 97.91)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 93.62) controlPoint1: CGPointMake(88.11, 94.69) controlPoint2: CGPointMake(87.23, 93.62)];
    [score8Path addCurveToPoint: CGPointMake(83.64, 96.27) controlPoint1: CGPointMake(84.47, 93.62) controlPoint2: CGPointMake(83.64, 94.69)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 99) controlPoint1: CGPointMake(83.64, 97.91) controlPoint2: CGPointMake(84.57, 99)];
    [score8Path closePath];
    [score8Path moveToPoint: CGPointMake(85.87, 107.35)];
    [score8Path addCurveToPoint: CGPointMake(88.37, 104.49) controlPoint1: CGPointMake(87.36, 107.35) controlPoint2: CGPointMake(88.37, 106.34)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 101.71) controlPoint1: CGPointMake(88.37, 102.77) controlPoint2: CGPointMake(87.25, 101.71)];
    [score8Path addCurveToPoint: CGPointMake(83.35, 104.49) controlPoint1: CGPointMake(84.47, 101.71) controlPoint2: CGPointMake(83.35, 102.77)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 107.35) controlPoint1: CGPointMake(83.35, 106.34) controlPoint2: CGPointMake(84.42, 107.35)];
    [score8Path closePath];
    [score8Path moveToPoint: CGPointMake(85.87, 110.26)];
    [score8Path addCurveToPoint: CGPointMake(79.71, 104.91) controlPoint1: CGPointMake(82.15, 110.26) controlPoint2: CGPointMake(79.71, 108.18)];
    [score8Path addCurveToPoint: CGPointMake(82.62, 100.3) controlPoint1: CGPointMake(79.71, 102.75) controlPoint2: CGPointMake(80.9, 101.19)];
    [score8Path addCurveToPoint: CGPointMake(80.12, 95.99) controlPoint1: CGPointMake(81.09, 99.45) controlPoint2: CGPointMake(80.12, 97.89)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 90.71) controlPoint1: CGPointMake(80.12, 92.92) controlPoint2: CGPointMake(82.31, 90.71)];
    [score8Path addCurveToPoint: CGPointMake(91.62, 95.99) controlPoint1: CGPointMake(89.44, 90.71) controlPoint2: CGPointMake(91.62, 92.92)];
    [score8Path addCurveToPoint: CGPointMake(89.1, 100.3) controlPoint1: CGPointMake(91.62, 97.89) controlPoint2: CGPointMake(90.63, 99.42)];
    [score8Path addCurveToPoint: CGPointMake(92.01, 104.91) controlPoint1: CGPointMake(90.82, 101.16) controlPoint2: CGPointMake(92.01, 102.75)];
    [score8Path addCurveToPoint: CGPointMake(85.87, 110.26) controlPoint1: CGPointMake(92.01, 108.16) controlPoint2: CGPointMake(89.46, 110.26)];
    [score8Path closePath];
    m_canonical_tile_paths[U'8'] = score8Path;
    
    // 9
    UIBezierPath *score9Path = [UIBezierPath bezierPath];
    [score9Path moveToPoint: CGPointMake(86.16, 100.88)];
    [score9Path addCurveToPoint: CGPointMake(87.69, 100.72) controlPoint1: CGPointMake(86.65, 100.88) controlPoint2: CGPointMake(87.17, 100.82)];
    [score9Path addCurveToPoint: CGPointMake(88.45, 97.31) controlPoint1: CGPointMake(88.22, 99.52) controlPoint2: CGPointMake(88.45, 98.46)];
    [score9Path addCurveToPoint: CGPointMake(85.82, 93.8) controlPoint1: CGPointMake(88.45, 95.18) controlPoint2: CGPointMake(87.43, 93.8)];
    [score9Path addCurveToPoint: CGPointMake(83.19, 97.39) controlPoint1: CGPointMake(84.21, 93.8) controlPoint2: CGPointMake(83.19, 95.29)];
    [score9Path addCurveToPoint: CGPointMake(86.16, 100.88) controlPoint1: CGPointMake(83.19, 99.76) controlPoint2: CGPointMake(84.39, 100.88)];
    [score9Path closePath];
    [score9Path moveToPoint: CGPointMake(86.52, 109.95)];
    [score9Path addLineToPoint: CGPointMake(82.23, 109.95)];
    [score9Path addLineToPoint: CGPointMake(85.48, 105.09)];
    [score9Path addCurveToPoint: CGPointMake(86.45, 103.5) controlPoint1: CGPointMake(85.87, 104.49) controlPoint2: CGPointMake(86.19, 103.97)];
    [score9Path addCurveToPoint: CGPointMake(84.83, 103.68) controlPoint1: CGPointMake(85.93, 103.63) controlPoint2: CGPointMake(85.4, 103.68)];
    [score9Path addCurveToPoint: CGPointMake(79.55, 97.5) controlPoint1: CGPointMake(82.02, 103.68) controlPoint2: CGPointMake(79.55, 101.5)];
    [score9Path addCurveToPoint: CGPointMake(85.9, 90.63) controlPoint1: CGPointMake(79.55, 93.65) controlPoint2: CGPointMake(81.89, 90.63)];
    [score9Path addCurveToPoint: CGPointMake(92.12, 97.31) controlPoint1: CGPointMake(89.91, 90.63) controlPoint2: CGPointMake(92.12, 93.34)];
    [score9Path addCurveToPoint: CGPointMake(88.79, 106.34) controlPoint1: CGPointMake(92.12, 100.12) controlPoint2: CGPointMake(91.05, 102.72)];
    [score9Path addLineToPoint: CGPointMake(86.52, 109.95)];
    [score9Path closePath];
    m_canonical_tile_paths[U'9'] = score9Path;
    
    // 2x
    UIBezierPath *multiplier2xPath = [UIBezierPath bezierPath];
    [multiplier2xPath moveToPoint: CGPointMake(17.7, 104.42)];
    [multiplier2xPath addLineToPoint: CGPointMake(9.09, 104.42)];
    [multiplier2xPath addLineToPoint: CGPointMake(8.86, 103.11)];
    [multiplier2xPath addLineToPoint: CGPointMake(13.25, 97.38)];
    [multiplier2xPath addCurveToPoint: CGPointMake(14.63, 94.6) controlPoint1: CGPointMake(14.21, 96.13) controlPoint2: CGPointMake(14.63, 95.36)];
    [multiplier2xPath addCurveToPoint: CGPointMake(13.12, 93.19) controlPoint1: CGPointMake(14.63, 93.76) controlPoint2: CGPointMake(14.05, 93.19)];
    [multiplier2xPath addCurveToPoint: CGPointMake(9.41, 95.46) controlPoint1: CGPointMake(11.87, 93.19) controlPoint2: CGPointMake(10.62, 94.18)];
    [multiplier2xPath addLineToPoint: CGPointMake(9.34, 95.43)];
    [multiplier2xPath addLineToPoint: CGPointMake(9.12, 92.23)];
    [multiplier2xPath addCurveToPoint: CGPointMake(13.63, 90.27) controlPoint1: CGPointMake(10.08, 91.27) controlPoint2: CGPointMake(11.55, 90.27)];
    [multiplier2xPath addCurveToPoint: CGPointMake(17.92, 94.18) controlPoint1: CGPointMake(16.36, 90.27) controlPoint2: CGPointMake(17.92, 91.91)];
    [multiplier2xPath addCurveToPoint: CGPointMake(15.91, 98.69) controlPoint1: CGPointMake(17.92, 95.62) controlPoint2: CGPointMake(17.35, 96.83)];
    [multiplier2xPath addLineToPoint: CGPointMake(13.6, 101.63)];
    [multiplier2xPath addLineToPoint: CGPointMake(18.5, 101.63)];
    [multiplier2xPath addLineToPoint: CGPointMake(17.7, 104.42)];
    [multiplier2xPath closePath];
    [multiplier2xPath moveToPoint: CGPointMake(28.98, 110.26)];
    [multiplier2xPath addLineToPoint: CGPointMake(25.74, 106.97)];
    [multiplier2xPath addLineToPoint: CGPointMake(22.47, 110.26)];
    [multiplier2xPath addLineToPoint: CGPointMake(20.38, 108.17)];
    [multiplier2xPath addLineToPoint: CGPointMake(23.7, 104.95)];
    [multiplier2xPath addLineToPoint: CGPointMake(20.38, 101.71)];
    [multiplier2xPath addLineToPoint: CGPointMake(22.47, 99.63)];
    [multiplier2xPath addLineToPoint: CGPointMake(25.74, 102.94)];
    [multiplier2xPath addLineToPoint: CGPointMake(29.01, 99.63)];
    [multiplier2xPath addLineToPoint: CGPointMake(31.07, 101.69)];
    [multiplier2xPath addLineToPoint: CGPointMake(27.76, 104.95)];
    [multiplier2xPath addLineToPoint: CGPointMake(31.07, 108.17)];
    [multiplier2xPath addLineToPoint: CGPointMake(28.98, 110.26)];
    [multiplier2xPath closePath];
    // note: stored under 2, not '2'
    m_canonical_tile_paths[2] = multiplier2xPath;

    // 3x
    UIBezierPath *multiplier3xPath = [UIBezierPath bezierPath];
    [multiplier3xPath moveToPoint: CGPointMake(12.96, 104.65)];
    [multiplier3xPath addCurveToPoint: CGPointMake(9.15, 103.73) controlPoint1: CGPointMake(11.36, 104.65) controlPoint2: CGPointMake(10.18, 104.27)];
    [multiplier3xPath addLineToPoint: CGPointMake(8.83, 100.65)];
    [multiplier3xPath addLineToPoint: CGPointMake(8.9, 100.62)];
    [multiplier3xPath addCurveToPoint: CGPointMake(12.55, 101.93) controlPoint1: CGPointMake(10.15, 101.45) controlPoint2: CGPointMake(11.46, 101.93)];
    [multiplier3xPath addCurveToPoint: CGPointMake(14.53, 100.46) controlPoint1: CGPointMake(13.76, 101.93) controlPoint2: CGPointMake(14.53, 101.33)];
    [multiplier3xPath addCurveToPoint: CGPointMake(10.72, 98) controlPoint1: CGPointMake(14.53, 99.5) controlPoint2: CGPointMake(13.73, 98.8)];
    [multiplier3xPath addLineToPoint: CGPointMake(10.72, 96.78)];
    [multiplier3xPath addCurveToPoint: CGPointMake(14.37, 94.16) controlPoint1: CGPointMake(13.73, 95.57) controlPoint2: CGPointMake(14.37, 94.96)];
    [multiplier3xPath addCurveToPoint: CGPointMake(12.74, 92.97) controlPoint1: CGPointMake(14.37, 93.45) controlPoint2: CGPointMake(13.76, 92.97)];
    [multiplier3xPath addCurveToPoint: CGPointMake(9.25, 94.45) controlPoint1: CGPointMake(11.59, 92.97) controlPoint2: CGPointMake(10.34, 93.61)];
    [multiplier3xPath addLineToPoint: CGPointMake(9.18, 94.45)];
    [multiplier3xPath addLineToPoint: CGPointMake(9.18, 91.5)];
    [multiplier3xPath addCurveToPoint: CGPointMake(13.35, 90.25) controlPoint1: CGPointMake(10.05, 90.89) controlPoint2: CGPointMake(11.55, 90.25)];
    [multiplier3xPath addCurveToPoint: CGPointMake(17.7, 93.65) controlPoint1: CGPointMake(15.97, 90.25) controlPoint2: CGPointMake(17.7, 91.6)];
    [multiplier3xPath addCurveToPoint: CGPointMake(15.04, 97.1) controlPoint1: CGPointMake(17.7, 95.02) controlPoint2: CGPointMake(16.87, 96.17)];
    [multiplier3xPath addCurveToPoint: CGPointMake(17.86, 100.69) controlPoint1: CGPointMake(16.96, 97.87) controlPoint2: CGPointMake(17.86, 99.18)];
    [multiplier3xPath addCurveToPoint: CGPointMake(12.96, 104.65) controlPoint1: CGPointMake(17.86, 103.21) controlPoint2: CGPointMake(15.52, 104.65)];
    [multiplier3xPath closePath];
    [multiplier3xPath moveToPoint: CGPointMake(28.98, 110.24)];
    [multiplier3xPath addLineToPoint: CGPointMake(25.74, 106.95)];
    [multiplier3xPath addLineToPoint: CGPointMake(22.47, 110.24)];
    [multiplier3xPath addLineToPoint: CGPointMake(20.38, 108.15)];
    [multiplier3xPath addLineToPoint: CGPointMake(23.7, 104.93)];
    [multiplier3xPath addLineToPoint: CGPointMake(20.38, 101.69)];
    [multiplier3xPath addLineToPoint: CGPointMake(22.47, 99.61)];
    [multiplier3xPath addLineToPoint: CGPointMake(25.74, 102.92)];
    [multiplier3xPath addLineToPoint: CGPointMake(29.01, 99.61)];
    [multiplier3xPath addLineToPoint: CGPointMake(31.07, 101.67)];
    [multiplier3xPath addLineToPoint: CGPointMake(27.76, 104.93)];
    [multiplier3xPath addLineToPoint: CGPointMake(31.07, 108.15)];
    [multiplier3xPath addLineToPoint: CGPointMake(28.98, 110.24)];
    [multiplier3xPath closePath];
    // note: stored under 3, not '3'
    m_canonical_tile_paths[3] = multiplier3xPath;
}

}  // namespace UP
