//
//  UPSpellLayoutManager.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>

#include "UPSpellLayoutManager.h"

namespace UP {

void SpellLayoutManager::set_canvas_frame(const CGRect &canvas_frame)
{
    m_canvas_frame = canvas_frame;
    calculate();
}

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

        calculate_controls_layout_frame();
        calculate_word_tray_layout_frame();
        calculate_tiles_layout_frame();
        calculate_controls_button_pause_layout_frame();
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
        
        calculate_controls_layout_frame();
        calculate_word_tray_layout_frame();
        calculate_tiles_layout_frame();
        calculate_controls_button_pause_layout_frame();
    }
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
            set_controls_layout_frame(frame);
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalControlsLayoutFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 50% the letterbox inset
            // That's what looks good.
            frame.origin.y -= letterbox_insets().top * 0.5;
            set_controls_layout_frame(frame);
            break;
        }
    }
    NSLog(@"controls layout frame:   %@", NSStringFromCGRect(controls_layout_frame()));
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
            set_word_tray_layout_frame(frame);
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalWordTrayFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved up in the UI by 20% of the letterbox inset
            // That's what looks good.
            frame.origin.y -= letterbox_insets().top * 0.2;
            set_word_tray_layout_frame(frame);
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
            set_tiles_layout_frame(frame);
            break;
        }
        case AspectMode::TallerThanCanonical: {
            CGRect frame = CanonicalTilesLayoutFrame;
            frame = up_rect_scaled_centered_x_in_rect(frame, layout_scale(), layout_frame());
            // Frame is moved down in the UI by 20% of the letterbox inset
            // That's what looks good.
            frame.origin.y += letterbox_insets().top * 0.2;
            set_tiles_layout_frame(frame);
            break;
        }
    }
    NSLog(@"   tiles layout frame:  %@", NSStringFromCGRect(tiles_layout_frame()));
}

void SpellLayoutManager::calculate_controls_button_pause_layout_frame()
{
    CGRect frame = up_rect_scaled(CanonicalRoundControlButtonPauseFrame, layout_scale());
    set_controls_button_pause_layout_frame(frame);
    NSLog(@"   pause button frame:  %@", NSStringFromCGRect(controls_button_pause_layout_frame()));
}

}  // namespace UP
