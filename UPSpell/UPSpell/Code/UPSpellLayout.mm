//
//  UPSpellLayout.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

#import <UpKit/UPAssertions.h>
#import <UpKit/UIFont+UP.h>
#import <UpKit/UPFontMetrics.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPUtility.h>

#include "UIFont+UPSpell.h"
#include "UPSpellModel.h"
#include "UPSpellLayout.h"

namespace UP {

SpellLayout::Role role_for(TilePosition pos)
{
    switch (pos.index()) {
        case 0:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile1 : SpellLayout::Role::WordTile1;
        case 1:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile2 : SpellLayout::Role::WordTile2;
        case 2:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile3 : SpellLayout::Role::WordTile3;
        case 3:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile4 : SpellLayout::Role::WordTile4;
        case 4:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile5 : SpellLayout::Role::WordTile5;
        case 5:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile6 : SpellLayout::Role::WordTile6;
        case 6:
            return pos.in_player_tray() ? SpellLayout::Role::PlayerTile7 : SpellLayout::Role::WordTile7;
    }
    ASSERT_NOT_REACHED();
    return SpellLayout::Role::None;
}

SpellLayout::Role role_in_word(TileIndex idx, size_t word_length)
{
    ASSERT_IDX(idx);
    switch (word_length) {
        case 0: {
            return SpellLayout::Role::None;
        }
        case 1: {
            return SpellLayout::Role::WordTile1of1;
        }
        case 2: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of2;
                case 1:
                    return SpellLayout::Role::WordTile2of2;
                default:
                    return SpellLayout::Role::None;
            }
        }
        case 3: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of3;
                case 1:
                    return SpellLayout::Role::WordTile2of3;
                case 2:
                    return SpellLayout::Role::WordTile3of3;
                default:
                    return SpellLayout::Role::None;
            }
        }
        case 4: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of4;
                case 1:
                    return SpellLayout::Role::WordTile2of4;
                case 2:
                    return SpellLayout::Role::WordTile3of4;
                case 3:
                    return SpellLayout::Role::WordTile4of4;
                default:
                    return SpellLayout::Role::None;
            }
        }
        case 5: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of5;
                case 1:
                    return SpellLayout::Role::WordTile2of5;
                case 2:
                    return SpellLayout::Role::WordTile3of5;
                case 3:
                    return SpellLayout::Role::WordTile4of5;
                case 4:
                    return SpellLayout::Role::WordTile5of5;
                default:
                    return SpellLayout::Role::None;
            }
        }
        case 6: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of6;
                case 1:
                    return SpellLayout::Role::WordTile2of6;
                case 2:
                    return SpellLayout::Role::WordTile3of6;
                case 3:
                    return SpellLayout::Role::WordTile4of6;
                case 4:
                    return SpellLayout::Role::WordTile5of6;
                case 5:
                    return SpellLayout::Role::WordTile6of6;
                default:
                    return SpellLayout::Role::None;
            }
        }
        case 7: {
            switch (idx) {
                case 0:
                    return SpellLayout::Role::WordTile1of7;
                case 1:
                    return SpellLayout::Role::WordTile2of7;
                case 2:
                    return SpellLayout::Role::WordTile3of7;
                case 3:
                    return SpellLayout::Role::WordTile4of7;
                case 4:
                    return SpellLayout::Role::WordTile5of7;
                case 5:
                    return SpellLayout::Role::WordTile6of7;
                case 6:
                    return SpellLayout::Role::WordTile7of7;
                default:
                    return SpellLayout::Role::None;
            }
        }
    }
    ASSERT_NOT_REACHED();
    return SpellLayout::Role::None;
}

SpellLayout::Role role_for_score(int score)
{
    if (score >= 1000) {
        return SpellLayout::Role::GameScoreGameOver4;
    }
    if (score >= 100) {
        return SpellLayout::Role::GameScoreGameOver3;
    }
    if (score >= 10) {
        return SpellLayout::Role::GameScoreGameOver2;
    }
    return SpellLayout::Role::GameScoreGameOver1;
}

CGRect SpellLayout::layout_aspect_rect(CGRect rect)
{
    switch (aspect_mode()) {
        case AspectMode::Canonical: {
            return rect;
        }
        case AspectMode::WiderThanCanonical: {
            CGRect r = up_rect_scaled_centered_x_in_rect(rect, layout_scale(), layout_frame());
            return up_pixel_rect(r, screen_scale());
        }
        case AspectMode::TallerThanCanonical: {
            CGRect r = up_rect_scaled_centered_x_in_rect(rect, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 20% of the letterbox inset
            // That's what looks good.
            r.origin.y -= letterbox_insets().top * 0.2;
            return up_pixel_rect(r, screen_scale());
        }
    }
    ASSERT_NOT_REACHED();
}

void SpellLayout::calculate()
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
        LOG(Layout, "layout manager wider:  %.2f, %.2f", effective_width, effective_height);
        LOG(Layout, "        aspect_scale:  %.3f", aspect_scale());
        LOG(Layout, "        layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        LOG(Layout, "        layout_scale:  %.3f", layout_scale());
        LOG(Layout, "     letterbox_insets: %@", NSStringFromUIEdgeInsets(letterbox_insets()));
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

        LOG(Layout, "layout manager taller:  %.2f, %.2f", effective_width, effective_height);
        LOG(Layout, "         aspect_scale:  %.3f", aspect_scale());
        LOG(Layout, "         layout_frame:  %@", NSStringFromCGRect(layout_frame()));
        LOG(Layout, "         layout_scale:  %.3f", layout_scale());
        LOG(Layout, "     letterbox_insets:  %@", NSStringFromUIEdgeInsets(letterbox_insets()));
    }

    calculate_menu_game_view_transform();
    calculate_tile_size();
    calculate_tile_stroke_width();
    calculate_player_tray_layout_frame();
    calculate_word_tray_layout_frame();
    calculate_word_tray_mask_frame();
    calculate_word_tray_shake_offset();
    calculate_tile_drag_barrier_frame();
    calculate_player_tray_tile_frames();
    calculate_word_tray_tile_frames();
    calculate_game_information_font_metrics();
    calculate_game_information_superscript_font_metrics();
    calculate_game_note_font_metrics();
    calculate_game_controls_layout_frame();
    calculate_game_controls_button_charge_size();
    calculate_locations();
}

CGRect SpellLayout::frame_for(const Location &loc)
{
    auto it = m_location_frames.find(loc);
    return it == m_location_frames.end() ? CGRectZero : it->second;
}

CGPoint SpellLayout::center_for(const Location &loc)
{
    return up_rect_center(frame_for(loc));
}

void SpellLayout::calculate_menu_game_view_transform()
{
    CGAffineTransform t = CGAffineTransformMakeScale(CanonicalGameViewMenuScale, CanonicalGameViewMenuScale);
    CGFloat dy = ((1.0 - CanonicalGameViewMenuScale) / 2.0) * up_rect_height(screen_bounds());
    t = CGAffineTransformTranslate(t, 0, dy);
    set_menu_game_view_transform(t);
    LOG(Layout, "menu_game_view_transform: %@", NSStringFromCGAffineTransform(menu_game_view_transform()));
}

void SpellLayout::calculate_tile_size()
{
    CGSize size = up_size_scaled(CanonicalTileSize, layout_scale());
    set_tile_size(up_pixel_size(size, screen_scale()));
}

void SpellLayout::calculate_tile_stroke_width()
{
    CGFloat stroke_width = CanonicalTileStrokeWidth * layout_scale();
    set_tile_stroke_width(stroke_width);
    
    CGRect stroke_bounds = CGRectMake(0, 0, up_size_width(CanonicalTileSize), up_size_height(CanonicalTileSize));
    CGRect stroke_inset = CGRectInset(stroke_bounds, CanonicalTileStrokeWidth, CanonicalTileStrokeWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(up_rect_max_x(stroke_inset), up_rect_min_y(stroke_inset))];
    [path addLineToPoint:CGPointMake(up_rect_min_x(stroke_inset), up_rect_min_y(stroke_inset))];
    [path addLineToPoint:CGPointMake(up_rect_min_x(stroke_inset), up_rect_max_y(stroke_inset))];
    [path addLineToPoint:CGPointMake(up_rect_max_x(stroke_inset), up_rect_max_y(stroke_inset))];
    [path closePath];
    [path moveToPoint:CGPointMake(up_rect_max_x(stroke_bounds), up_rect_min_y(stroke_bounds))];
    [path addLineToPoint:CGPointMake(up_rect_max_x(stroke_bounds), up_rect_max_y(stroke_bounds))];
    [path addLineToPoint:CGPointMake(up_rect_min_x(stroke_bounds), up_rect_max_y(stroke_bounds))];
    [path addLineToPoint:CGPointMake(up_rect_min_x(stroke_bounds), up_rect_min_y(stroke_bounds))];
    [path closePath];
    m_tile_stroke_path = path;
    
    LOG(Layout, "tile_stroke_width: %.2f", tile_stroke_width());
}

void SpellLayout::calculate_game_information_font_metrics()
{
    CGFloat cap_height = CanonicalGameInformationCapHeight * layout_scale();
    UIFont *font = [UIFont gameInformationFontWithCapHeight:cap_height];
    set_game_information_font(font);
    set_game_information_font_metrics(FontMetrics(font.fontName, font.pointSize));
}

void SpellLayout::calculate_game_information_superscript_font_metrics()
{
    CGFloat cap_height = CanonicalGameInformationSuperscriptCapHeight * layout_scale();
    UIFont *font = [UIFont gameInformationFontWithCapHeight:cap_height];
    set_game_information_superscript_font(font);
    CGFloat baseline_adjustment = CanonicalGameInformationSuperscriptBaselineAdjustment * layout_scale();
    CGFloat kerning = CanonicalGameInformationSuperscriptKerning * layout_scale();
    set_game_information_superscript_font_metrics(FontMetrics(font.fontName, font.pointSize, baseline_adjustment, kerning));
}

void SpellLayout::calculate_game_note_font_metrics()
{
    CGFloat cap_height = CanonicalDialogOverNoteFontCapHeight * layout_scale();
    UIFont *font = [UIFont gameNoteFontWithCapHeight:cap_height];
    set_game_note_font(font);
    set_game_note_font_metrics(FontMetrics(font.fontName, font.pointSize));
}

void SpellLayout::calculate_game_controls_layout_frame()
{
    set_controls_layout_frame(layout_aspect_rect(CanonicalControlsLayoutFrame));
    LOG(Layout, "player_tray_layout_frame: %@", NSStringFromCGRect(controls_layout_frame()));
}

void SpellLayout::calculate_player_tray_layout_frame()
{
    set_player_tray_layout_frame(layout_aspect_rect(CanonicalTilesLayoutFrame));
    LOG(Layout, "player_tray_layout_frame: %@", NSStringFromCGRect(player_tray_layout_frame()));
}

void SpellLayout::calculate_word_tray_layout_frame()
{
    set_word_tray_layout_frame(layout_aspect_rect(CanonicalWordTrayFrame));
    LOG(Layout, "word_tray_layout_frame: %@", NSStringFromCGRect(word_tray_layout_frame()));
}

void SpellLayout::calculate_word_tray_mask_frame()
{
    set_word_tray_mask_frame(layout_aspect_rect(CanonicalWordTrayMaskFrame));
    LOG(Layout, "word_tray_mask_frame: %@", NSStringFromCGRect(word_tray_mask_frame()));
}

void SpellLayout::calculate_word_tray_shake_offset()
{
    CGFloat amount = CanonicalWordTrayShakeAmount * layout_scale();
    set_word_tray_shake_offset(UIOffsetMake(up_pixel_float(amount, screen_scale()), 0));
}

void SpellLayout::calculate_tile_drag_barrier_frame()
{
    CGRect frame = CGRectIntersection(word_tray_mask_frame(), canvas_frame());
    frame = CGRectIntersection(frame, CGRectInset(screen_bounds(), 20, 20));
    frame = CGRectInset(frame, up_size_width(tile_size()) * 0.85, up_size_height(tile_size()) * 0.65);
    frame = CGRectOffset(frame, 0, up_size_height(tile_size()) * 0.11);
    set_tile_drag_barrier_frame(up_pixel_rect(frame, screen_scale()));
    LOG(Layout, "tile_drag_barrier_frame: %@", NSStringFromCGRect(tile_drag_barrier_frame()));
}

void SpellLayout::calculate_player_tray_tile_frames()
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
        LOG(Layout, "   tile tray frame [%d]: %@", idx, NSStringFromCGRect(r));
        idx++;
    }
}

void SpellLayout::calculate_word_tray_tile_frames()
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
    CGFloat offset_x = (up_size_width(size) + gap) * 0.5;
    for (size_t idx = 0; idx < TileCount; idx++) {
        even_rects[idx] = up_pixel_rect(CGRectOffset(even_rects[idx], -offset_x, 0), screen_scale());
        even_centers[idx] = up_pixel_point(CGPointMake(even_centers[idx].x - offset_x, even_centers[idx].y), screen_scale());
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
        LOG(Layout, "word_tray_tile_frame [%d]:  %@", idx, NSStringFromCGRect(r));
        idx++;
    }
}

void SpellLayout::calculate_locations()
{
    calculate_player_tile_locations();
    calculate_word_tile_locations();
    calculate_dialog_locations();
    calculate_game_locations();
}

void SpellLayout::calculate_player_tile_locations()
{
    const auto &begin = m_player_tray_tile_frames.begin();
    const CGFloat screen_min_x = up_rect_min_x(screen_bounds());
    const CGFloat screen_min_y = up_rect_min_y(screen_bounds());
    const CGFloat screen_max_x = up_rect_max_x(screen_bounds());
    const CGFloat screen_max_y = up_rect_max_y(screen_bounds());
    for (auto it = begin; it != m_player_tray_tile_frames.end(); ++it) {
        const CGRect default_frame = *it;
        const CGFloat df_min_x = up_rect_min_x(default_frame);
        const CGFloat df_min_y = up_rect_min_y(default_frame);
        const CGFloat df_w = up_rect_width(default_frame);
        const CGFloat df_h = up_rect_height(default_frame);
        const CGFloat df_off_x = df_w * CanonicalOffscreenFrameFactor;
        const CGFloat df_off_y = df_h * CanonicalOffscreenFrameFactor;
        const TileIndex idx = it - begin;
        Role role = role_for(TilePosition(TileTray::Player, idx));
        CGRect off_top_frame = CGRectMake(df_min_x, screen_min_y - df_off_y, df_w, df_h);
        CGRect off_bottom_frame = CGRectMake(df_min_x, screen_max_y + df_off_y, df_w, df_h);
        CGRect off_left_frame = CGRectMake(screen_min_x - df_off_x, df_min_y, df_w, df_h);
        CGRect off_right_frame = CGRectMake(screen_max_x + df_off_x, df_min_y, df_w, df_h);
        CGRect submitted_tile_frame = CGRectMake(df_min_x, up_rect_min_y(word_tray_layout_frame()) - df_h, df_w, df_h);
        m_location_frames.emplace(Location(role, Spot::Default), up_pixel_rect(default_frame, screen_scale()));
        m_location_frames.emplace(Location(role, Spot::OffTop), up_pixel_rect(off_top_frame, screen_scale()));
        m_location_frames.emplace(Location(role, Spot::OffBottom), up_pixel_rect(off_bottom_frame, screen_scale()));
        m_location_frames.emplace(Location(role, Spot::OffLeft), up_pixel_rect(off_left_frame, screen_scale()));
        m_location_frames.emplace(Location(role, Spot::OffRight), up_pixel_rect(off_right_frame, screen_scale()));
        m_location_frames.emplace(Location(role, Spot::TileSubmitted), up_pixel_rect(submitted_tile_frame, screen_scale()));
    }
}

void SpellLayout::calculate_word_tile_locations()
{
    for (size_t widx = 0; widx < TileCount; widx++) {
        TileRectArray word_tray_tile_frames = m_word_tray_tile_frames[widx];
        const auto &begin = word_tray_tile_frames.begin();
        const CGFloat screen_min_x = up_rect_min_x(screen_bounds());
        const CGFloat screen_min_y = up_rect_min_y(screen_bounds());
        const CGFloat screen_max_x = up_rect_max_x(screen_bounds());
        const CGFloat screen_max_y = up_rect_max_y(screen_bounds());
        for (auto it = begin; it != word_tray_tile_frames.end(); ++it) {
            const CGRect default_frame = *it;
            const CGFloat df_min_x = up_rect_min_x(default_frame);
            const CGFloat df_min_y = up_rect_min_y(default_frame);
            const CGFloat df_w = up_rect_width(default_frame);
            const CGFloat df_h = up_rect_height(default_frame);
            const CGFloat df_off_x = df_w * CanonicalOffscreenFrameFactor;
            const CGFloat df_off_y = df_h * CanonicalOffscreenFrameFactor;
            const TileIndex idx = it - begin;
            Role role = role_in_word(idx, widx + 1);
            CGRect off_top_frame = CGRectMake(df_min_x, screen_min_y - df_off_y, df_w, df_h);
            CGRect off_bottom_frame = CGRectMake(df_min_x, screen_max_y + df_off_y, df_w, df_h);
            CGRect off_left_frame = CGRectMake(screen_min_x - df_off_x, df_min_y, df_w, df_h);
            CGRect off_right_frame = CGRectMake(screen_max_x + df_off_x, df_min_y, df_w, df_h);
            CGRect submitted_tile_frame = CGRectMake(df_min_x, up_rect_min_y(word_tray_layout_frame()) - df_h, df_w, df_h);
            m_location_frames.emplace(Location(role, Spot::Default), up_pixel_rect(default_frame, screen_scale()));
            m_location_frames.emplace(Location(role, Spot::OffTop), up_pixel_rect(off_top_frame, screen_scale()));
            m_location_frames.emplace(Location(role, Spot::OffBottom), up_pixel_rect(off_bottom_frame, screen_scale()));
            m_location_frames.emplace(Location(role, Spot::OffLeft), up_pixel_rect(off_left_frame, screen_scale()));
            m_location_frames.emplace(Location(role, Spot::OffRight), up_pixel_rect(off_right_frame, screen_scale()));
            m_location_frames.emplace(Location(role, Spot::TileSubmitted), up_pixel_rect(submitted_tile_frame, screen_scale()));
        }
    }
}

void SpellLayout::calculate_dialog_locations()
{
    calculate_and_set_locations(Role::DialogMessageHigh, word_tray_layout_frame());
    calculate_and_set_locations(Role::DialogNote, layout_aspect_rect(CanonicalDialogNoteLayoutFrame));

    CGRect centered_message_frame = up_rect_centered_in_rect(word_tray_layout_frame(), screen_bounds());
    centered_message_frame.origin.y = up_rect_min_y(centered_message_frame) - (up_rect_height(centered_message_frame) * 0.12);
    calculate_and_set_locations(Role::DialogMessageCenter, centered_message_frame);

    CGSize button_size = up_size_scaled(CanonicalTextButtonSize, layout_scale());
    CGRect top_buttons_layout_frame = layout_aspect_rect(CanonicalDialogTopButtonsLayoutFrame);
    calculate_and_set_locations(Role::DialogButtonTopLeft, up_left_aligned_rect(button_size, top_buttons_layout_frame));
    calculate_and_set_locations(Role::DialogButtonTopCenter, up_center_aligned_rect(button_size, top_buttons_layout_frame));
    calculate_and_set_locations(Role::DialogButtonTopRight, up_right_aligned_rect(button_size, top_buttons_layout_frame));

    CGRect response_buttons_layout_frame = layout_aspect_rect(CanonicalDialogResponseButtonsLayoutFrame);
    calculate_and_set_locations(Role::DialogButtonDefaultResponse, up_right_aligned_rect(button_size, response_buttons_layout_frame));
    calculate_and_set_locations(Role::DialogButtonAlternativeResponse, up_left_aligned_rect(button_size, response_buttons_layout_frame));
}

void SpellLayout::calculate_game_locations()
{
    CGSize button_size = up_size_scaled(CanonicalRoundButtonSize, layout_scale());
    CGRect controls_layout_frame = layout_aspect_rect(CanonicalControlsLayoutFrame);
    calculate_and_set_locations(Role::GameButtonLeft, up_left_aligned_rect(button_size, controls_layout_frame));
    calculate_and_set_locations(Role::GameButtonRight, up_right_aligned_rect(button_size, controls_layout_frame));

    calculate_game_timer_frame();
    calculate_and_set_locations(Role::GameTimer, game_timer_frame());

    calculate_game_score_frame();
    calculate_and_set_locations(Role::GameScore, game_score_frame());
    calculate_and_set_locations(Role::GameScoreGameOver1, layout_game_over_score_frame(@"1"));
    calculate_and_set_locations(Role::GameScoreGameOver2, layout_game_over_score_frame(@"10"));
    calculate_and_set_locations(Role::GameScoreGameOver3, layout_game_over_score_frame(@"100"));
    calculate_and_set_locations(Role::GameScoreGameOver4, layout_game_over_score_frame(@"1000"));
}

void SpellLayout::calculate_and_set_locations(const Role role, const CGRect &default_frame)
{
    const CGFloat screen_min_x = up_rect_min_x(screen_bounds());
    const CGFloat screen_min_y = up_rect_min_y(screen_bounds());
    const CGFloat screen_max_x = up_rect_max_x(screen_bounds());
    const CGFloat screen_max_y = up_rect_max_y(screen_bounds());
    const CGFloat df_min_x = up_rect_min_x(default_frame);
    const CGFloat df_min_y = up_rect_min_y(default_frame);
    const CGFloat df_w = up_rect_width(default_frame);
    const CGFloat df_h = up_rect_height(default_frame);
    const CGFloat df_off_x = df_w * CanonicalOffscreenFrameFactor;
    const CGFloat df_off_y = df_h * CanonicalOffscreenFrameFactor;
    CGRect off_top_frame = CGRectMake(df_min_x, screen_min_y - df_off_y, df_w, df_h);
    CGRect off_bottom_frame = CGRectMake(df_min_x, screen_max_y + df_off_y, df_w, df_h);
    CGRect off_left_frame = CGRectMake(screen_min_x - df_off_x, df_min_y, df_w, df_h);
    CGRect off_right_frame = CGRectMake(screen_max_x + df_off_x, df_min_y, df_w, df_h);
    m_location_frames.emplace(Location(role, Spot::Default), up_pixel_rect(default_frame, screen_scale()));
    m_location_frames.emplace(Location(role, Spot::OffTop), up_pixel_rect(off_top_frame, screen_scale()));
    m_location_frames.emplace(Location(role, Spot::OffBottom), up_pixel_rect(off_bottom_frame, screen_scale()));
    m_location_frames.emplace(Location(role, Spot::OffLeft), up_pixel_rect(off_left_frame, screen_scale()));
    m_location_frames.emplace(Location(role, Spot::OffRight), up_pixel_rect(off_right_frame, screen_scale()));
}

void SpellLayout::calculate_game_controls_button_charge_size()
{
    CGSize size = up_size_scaled(CanonicalRoundButtonSize, layout_scale());
    CGSize charge_size = CGSizeMake(up_size_width(size) * 0.65, up_size_height(size) * 0.15);
    set_game_controls_button_charge_size(up_pixel_size(charge_size, screen_scale()));
    LOG(Layout, "game_controls_button_charge_size: %@", NSStringFromCGSize(game_controls_button_charge_size()));
}

void SpellLayout::calculate_game_timer_frame()
{
    const FontMetrics &font_metrics = game_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameTimeLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x - w;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_timer_frame(up_pixel_rect(frame, screen_scale()));
    LOG(Layout, "game_timer_frame: %@", NSStringFromCGRect(game_timer_frame()));
}

void SpellLayout::calculate_game_score_frame()
{
    const FontMetrics &font_metrics = game_information_font_metrics();
    CGFloat cap_height = font_metrics.cap_height();
    CGPoint baseline_point = up_point_scaled(CanonicalGameScoreLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameScoreLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - cap_height;
    CGFloat h = font_metrics.line_height();
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_score_frame(up_pixel_rect(frame, screen_scale()));
    LOG(Layout, "game_score_frame: %@", NSStringFromCGRect(game_score_frame()));
}

CGRect SpellLayout::layout_game_over_score_frame(NSString *string) const
{
    NSAttributedString *richText = [[NSAttributedString alloc] initWithString:string attributes:@{
        NSFontAttributeName: game_information_font() }
    ];
    CGPathRef path = CGPathCreateWithRect(CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX), NULL);
    CGFloat width = 0.0;
    CTFramesetterRef setter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)richText);
    CTFrameRef frame = CTFramesetterCreateFrame(setter, CFRangeMake(0, string.length), path, NULL);
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    for (id item in lines) {
        CTLineRef line = (__bridge CTLineRef)item;
        width = UPMaxT(CGFloat, width, CTLineGetTypographicBounds(line, NULL, NULL, NULL));
    }
    CFRelease(frame);
    CFRelease(setter);
    CFRelease(path);
    
    // center right-aligned label
    CGPoint center = up_rect_center(canvas_frame());
    CGRect labelFrame = game_score_frame();;
    labelFrame = up_rect_centered_x_in_rect(labelFrame, canvas_frame());
    labelFrame.origin.x = center.x - up_rect_width(labelFrame) + (width * 0.5);
    return up_pixel_rect(labelFrame, screen_scale());
}

}  // namespace UP
