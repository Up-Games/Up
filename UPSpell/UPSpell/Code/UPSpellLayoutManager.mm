//
//  UPSpellLayoutManager.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UIFont+UP.h>
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
    calculate_game_time_label_metrics();
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
            // Frame is moved down in the UI by 20% of the letterbox inset
            // That's what looks good.
            frame.origin.y += letterbox_insets().top * 0.2;
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

void SpellLayoutManager::calculate_game_time_label_metrics()
{
    CGFloat cap_height = CanonicalGameplayInformationCapHeight * layout_scale();
    UIFont *font = [UIFont gameplayInformationFontWithCapHeight:cap_height];
    set_game_time_label_font_size(font.pointSize);
    CGPoint baseline_point = up_point_scaled(CanonicalGameTimeLabelRightAlignedBaselinePointRelativeToTDC, layout_scale());
    CGFloat w = CanonicalGameTimeLabelWidth * layout_scale();
    CGFloat x = up_rect_mid_x(controls_layout_frame()) + baseline_point.x - w;
    CGFloat y = up_rect_mid_y(controls_layout_frame()) - (cap_height * 1.03);
    CGFloat h = font.lineHeight;
    CGRect frame = CGRectMake(x, y, w, h);
    set_game_time_label_frame(up_pixel_rect(frame, screen_scale()));
    NSLog(@"   time label frame:    %@", NSStringFromCGRect(game_time_label_frame()));
}

}  // namespace UP
