//
//  UPCheckbox.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPAssertions.h>
#import <UpKit/UIColor+UP.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPTapGestureRecognizer.h>

#import "UPCheckbox.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

static UIBezierPath *CheckboxPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(17.59, 7)];
    [path addCurveToPoint: CGPointMake(14.48, 7) controlPoint1: CGPointMake(16.56, 7) controlPoint2: CGPointMake(15.52, 7)];
    [path addCurveToPoint: CGPointMake(11.38, 7) controlPoint1: CGPointMake(13.45, 7) controlPoint2: CGPointMake(12.42, 7)];
    [path addCurveToPoint: CGPointMake(3.86, 7.33) controlPoint1: CGPointMake(8.88, 7.04) controlPoint2: CGPointMake(6.36, 6.92)];
    [path addCurveToPoint: CGPointMake(0.76, 9.61) controlPoint1: CGPointMake(2.98, 7.53) controlPoint2: CGPointMake(1.32, 7.73)];
    [path addCurveToPoint: CGPointMake(0.49, 12.8) controlPoint1: CGPointMake(0.5, 10.52) controlPoint2: CGPointMake(0.51, 11.71)];
    [path addCurveToPoint: CGPointMake(0.49, 29.2) controlPoint1: CGPointMake(0.49, 18.81) controlPoint2: CGPointMake(0.49, 23.19)];
    [path addCurveToPoint: CGPointMake(0.76, 32.39) controlPoint1: CGPointMake(0.51, 30.29) controlPoint2: CGPointMake(0.5, 31.48)];
    [path addCurveToPoint: CGPointMake(3.86, 34.67) controlPoint1: CGPointMake(1.32, 34.27) controlPoint2: CGPointMake(3, 34.47)];
    [path addCurveToPoint: CGPointMake(10.77, 35) controlPoint1: CGPointMake(6.16, 35.05) controlPoint2: CGPointMake(8.47, 34.97)];
    [path addCurveToPoint: CGPointMake(14.49, 35) controlPoint1: CGPointMake(12.01, 35) controlPoint2: CGPointMake(13.25, 35)];
    [path addCurveToPoint: CGPointMake(18.21, 35) controlPoint1: CGPointMake(15.73, 35) controlPoint2: CGPointMake(16.97, 35)];
    [path addCurveToPoint: CGPointMake(23.38, 34.88) controlPoint1: CGPointMake(19.93, 35) controlPoint2: CGPointMake(21.66, 34.99)];
    [path addCurveToPoint: CGPointMake(26.76, 34.15) controlPoint1: CGPointMake(24.51, 34.77) controlPoint2: CGPointMake(25.65, 34.7)];
    [path addCurveToPoint: CGPointMake(28.21, 32.39) controlPoint1: CGPointMake(27.28, 33.86) controlPoint2: CGPointMake(27.86, 33.54)];
    [path addCurveToPoint: CGPointMake(28.49, 29.2) controlPoint1: CGPointMake(28.48, 31.48) controlPoint2: CGPointMake(28.47, 30.29)];
    [path addCurveToPoint: CGPointMake(28.49, 12.8) controlPoint1: CGPointMake(28.49, 23.19) controlPoint2: CGPointMake(28.49, 18.81)];
    [path addCurveToPoint: CGPointMake(28.21, 9.61) controlPoint1: CGPointMake(28.47, 11.71) controlPoint2: CGPointMake(28.48, 10.52)];
    [path addCurveToPoint: CGPointMake(25.12, 7.33) controlPoint1: CGPointMake(27.66, 7.73) controlPoint2: CGPointMake(25.98, 7.53)];
    [path addCurveToPoint: CGPointMake(17.59, 7) controlPoint1: CGPointMake(22.61, 6.92) controlPoint2: CGPointMake(20.1, 7.04)];
    [path closePath];
    [path moveToPoint: CGPointMake(17.57, 11)];
    [path addCurveToPoint: CGPointMake(19.25, 11.01) controlPoint1: CGPointMake(18.13, 11.01) controlPoint2: CGPointMake(18.69, 11.01)];
    [path addCurveToPoint: CGPointMake(24.38, 11.26) controlPoint1: CGPointMake(21.06, 11.01) controlPoint2: CGPointMake(22.77, 11.01)];
    [path addLineToPoint: CGPointMake(24.44, 11.28)];
    [path addCurveToPoint: CGPointMake(24.48, 12.56) controlPoint1: CGPointMake(24.47, 11.69) controlPoint2: CGPointMake(24.48, 12.2)];
    [path addLineToPoint: CGPointMake(24.49, 12.83)];
    [path addCurveToPoint: CGPointMake(24.49, 29.17) controlPoint1: CGPointMake(24.49, 18.82) controlPoint2: CGPointMake(24.49, 23.18)];
    [path addLineToPoint: CGPointMake(24.48, 29.46)];
    [path addCurveToPoint: CGPointMake(24.45, 30.73) controlPoint1: CGPointMake(24.48, 29.82) controlPoint2: CGPointMake(24.47, 30.34)];
    [path addCurveToPoint: CGPointMake(23.27, 30.87) controlPoint1: CGPointMake(24.12, 30.79) controlPoint2: CGPointMake(23.73, 30.83)];
    [path addLineToPoint: CGPointMake(23.07, 30.89)];
    [path addCurveToPoint: CGPointMake(18.2, 31) controlPoint1: CGPointMake(21.46, 30.99) controlPoint2: CGPointMake(19.8, 31)];
    [path addCurveToPoint: CGPointMake(14.49, 31) controlPoint1: CGPointMake(16.96, 31) controlPoint2: CGPointMake(15.72, 31)];
    [path addCurveToPoint: CGPointMake(10.82, 31) controlPoint1: CGPointMake(13.25, 31) controlPoint2: CGPointMake(12.01, 31)];
    [path addCurveToPoint: CGPointMake(9.51, 30.99) controlPoint1: CGPointMake(10.38, 30.99) controlPoint2: CGPointMake(9.95, 30.99)];
    [path addCurveToPoint: CGPointMake(4.61, 30.74) controlPoint1: CGPointMake(7.78, 30.99) controlPoint2: CGPointMake(6.14, 30.98)];
    [path addLineToPoint: CGPointMake(4.53, 30.72)];
    [path addCurveToPoint: CGPointMake(4.5, 29.44) controlPoint1: CGPointMake(4.51, 30.31) controlPoint2: CGPointMake(4.5, 29.8)];
    [path addLineToPoint: CGPointMake(4.49, 29.17)];
    [path addCurveToPoint: CGPointMake(4.49, 12.83) controlPoint1: CGPointMake(4.49, 23.18) controlPoint2: CGPointMake(4.49, 18.82)];
    [path addLineToPoint: CGPointMake(4.5, 12.54)];
    [path addCurveToPoint: CGPointMake(4.53, 11.28) controlPoint1: CGPointMake(4.5, 12.19) controlPoint2: CGPointMake(4.51, 11.68)];
    [path addLineToPoint: CGPointMake(4.6, 11.26)];
    [path addCurveToPoint: CGPointMake(9.73, 11.01) controlPoint1: CGPointMake(6.21, 11.01) controlPoint2: CGPointMake(7.92, 11.01)];
    [path addCurveToPoint: CGPointMake(11.41, 11) controlPoint1: CGPointMake(10.29, 11.01) controlPoint2: CGPointMake(10.85, 11.01)];
    [path addLineToPoint: CGPointMake(14.48, 11)];
    [path addLineToPoint: CGPointMake(17.57, 11)];
    [path closePath];
    return path;
}

static UIBezierPath *CheckboxCheckPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(38.8, 2.72)];
    [path addCurveToPoint: CGPointMake(38.45, 2.3) controlPoint1: CGPointMake(38.69, 2.57) controlPoint2: CGPointMake(38.58, 2.43)];
    [path addLineToPoint: CGPointMake(37.81, 1.66)];
    [path addCurveToPoint: CGPointMake(37.18, 1.03) controlPoint1: CGPointMake(37.6, 1.45) controlPoint2: CGPointMake(37.39, 1.24)];
    [path addCurveToPoint: CGPointMake(36.75, 0.68) controlPoint1: CGPointMake(37.05, 0.9) controlPoint2: CGPointMake(36.9, 0.78)];
    [path addCurveToPoint: CGPointMake(35.72, 0.53) controlPoint1: CGPointMake(36.46, 0.47) controlPoint2: CGPointMake(36.11, 0.42)];
    [path addCurveToPoint: CGPointMake(35.05, 0.83) controlPoint1: CGPointMake(35.51, 0.59) controlPoint2: CGPointMake(35.3, 0.69)];
    [path addCurveToPoint: CGPointMake(33.57, 1.92) controlPoint1: CGPointMake(34.55, 1.12) controlPoint2: CGPointMake(34.1, 1.48)];
    [path addCurveToPoint: CGPointMake(31.52, 3.78) controlPoint1: CGPointMake(32.93, 2.45) controlPoint2: CGPointMake(32.26, 3.06)];
    [path addCurveToPoint: CGPointMake(28.72, 6.52) controlPoint1: CGPointMake(30.58, 4.69) controlPoint2: CGPointMake(29.64, 5.6)];
    [path addCurveToPoint: CGPointMake(16.81, 18.42) controlPoint1: CGPointMake(24.75, 10.48) controlPoint2: CGPointMake(20.78, 14.45)];
    [path addCurveToPoint: CGPointMake(14.97, 20.27) controlPoint1: CGPointMake(16.2, 19.03) controlPoint2: CGPointMake(15.58, 19.65)];
    [path addLineToPoint: CGPointMake(14.84, 19.81)];
    [path addCurveToPoint: CGPointMake(14.03, 16.76) controlPoint1: CGPointMake(14.57, 18.8) controlPoint2: CGPointMake(14.3, 17.78)];
    [path addLineToPoint: CGPointMake(14.01, 16.68)];
    [path addCurveToPoint: CGPointMake(13.11, 13.83) controlPoint1: CGPointMake(13.75, 15.74) controlPoint2: CGPointMake(13.49, 14.76)];
    [path addCurveToPoint: CGPointMake(12.66, 12.94) controlPoint1: CGPointMake(13.01, 13.57) controlPoint2: CGPointMake(12.87, 13.25)];
    [path addCurveToPoint: CGPointMake(12.09, 12.38) controlPoint1: CGPointMake(12.53, 12.75) controlPoint2: CGPointMake(12.37, 12.54)];
    [path addCurveToPoint: CGPointMake(11.05, 12.24) controlPoint1: CGPointMake(11.8, 12.22) controlPoint2: CGPointMake(11.45, 12.17)];
    [path addCurveToPoint: CGPointMake(10.55, 12.35) controlPoint1: CGPointMake(10.88, 12.27) controlPoint2: CGPointMake(10.71, 12.31)];
    [path addLineToPoint: CGPointMake(8.4, 12.93)];
    [path addCurveToPoint: CGPointMake(7.91, 13.08) controlPoint1: CGPointMake(8.23, 12.97) controlPoint2: CGPointMake(8.07, 13.02)];
    [path addCurveToPoint: CGPointMake(7.08, 13.72) controlPoint1: CGPointMake(7.52, 13.22) controlPoint2: CGPointMake(7.24, 13.44)];
    [path addCurveToPoint: CGPointMake(6.86, 14.49) controlPoint1: CGPointMake(6.92, 14) controlPoint2: CGPointMake(6.88, 14.27)];
    [path addCurveToPoint: CGPointMake(6.91, 15.49) controlPoint1: CGPointMake(6.83, 14.87) controlPoint2: CGPointMake(6.87, 15.22)];
    [path addCurveToPoint: CGPointMake(7.59, 18.49) controlPoint1: CGPointMake(7.06, 16.49) controlPoint2: CGPointMake(7.32, 17.47)];
    [path addCurveToPoint: CGPointMake(9.54, 25.75) controlPoint1: CGPointMake(8.23, 20.91) controlPoint2: CGPointMake(8.88, 23.33)];
    [path addCurveToPoint: CGPointMake(9.86, 26.84) controlPoint1: CGPointMake(9.64, 26.11) controlPoint2: CGPointMake(9.75, 26.48)];
    [path addLineToPoint: CGPointMake(10.04, 27.44)];
    [path addCurveToPoint: CGPointMake(10.53, 28.64) controlPoint1: CGPointMake(10.19, 27.89) controlPoint2: CGPointMake(10.34, 28.28)];
    [path addCurveToPoint: CGPointMake(11.1, 29.42) controlPoint1: CGPointMake(10.66, 28.88) controlPoint2: CGPointMake(10.82, 29.17)];
    [path addCurveToPoint: CGPointMake(11.53, 29.68) controlPoint1: CGPointMake(11.23, 29.53) controlPoint2: CGPointMake(11.37, 29.62)];
    [path addCurveToPoint: CGPointMake(12.01, 29.76) controlPoint1: CGPointMake(11.68, 29.73) controlPoint2: CGPointMake(11.84, 29.76)];
    [path addCurveToPoint: CGPointMake(12.41, 29.72) controlPoint1: CGPointMake(12.14, 29.76) controlPoint2: CGPointMake(12.27, 29.74)];
    [path addCurveToPoint: CGPointMake(13.05, 29.57) controlPoint1: CGPointMake(12.59, 29.68) controlPoint2: CGPointMake(12.78, 29.64)];
    [path addLineToPoint: CGPointMake(13.29, 29.5)];
    [path addCurveToPoint: CGPointMake(13.44, 29.45) controlPoint1: CGPointMake(13.34, 29.48) controlPoint2: CGPointMake(13.39, 29.47)];
    [path addCurveToPoint: CGPointMake(14.59, 28.73) controlPoint1: CGPointMake(13.86, 29.26) controlPoint2: CGPointMake(14.24, 28.99)];
    [path addCurveToPoint: CGPointMake(16.16, 27.41) controlPoint1: CGPointMake(15.19, 28.28) controlPoint2: CGPointMake(15.75, 27.79)];
    [path addLineToPoint: CGPointMake(16.43, 27.16)];
    [path addCurveToPoint: CGPointMake(21.06, 22.66) controlPoint1: CGPointMake(17.96, 25.75) controlPoint2: CGPointMake(19.37, 24.35)];
    [path addCurveToPoint: CGPointMake(32.96, 10.76) controlPoint1: CGPointMake(25.03, 18.7) controlPoint2: CGPointMake(29, 14.73)];
    [path addCurveToPoint: CGPointMake(35.69, 7.96) controlPoint1: CGPointMake(33.88, 9.83) controlPoint2: CGPointMake(34.79, 8.9)];
    [path addCurveToPoint: CGPointMake(37.56, 5.91) controlPoint1: CGPointMake(36.41, 7.22) controlPoint2: CGPointMake(37.02, 6.55)];
    [path addCurveToPoint: CGPointMake(38.65, 4.42) controlPoint1: CGPointMake(37.92, 5.48) controlPoint2: CGPointMake(38.33, 4.98)];
    [path addCurveToPoint: CGPointMake(38.94, 3.75) controlPoint1: CGPointMake(38.79, 4.19) controlPoint2: CGPointMake(38.88, 3.97)];
    [path addCurveToPoint: CGPointMake(38.8, 2.72) controlPoint1: CGPointMake(39.05, 3.37) controlPoint2: CGPointMake(39, 3.01)];
    [path closePath];
    return path;
}

@interface UPCheckbox ()
@property (nonatomic) UPLabel *label;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPCheckbox

+ (UPCheckbox *)checkbox
{
    return [[UPCheckbox alloc] initWithTarget:nil action:nullptr];
}

+ (UPCheckbox *)checkboxWithTarget:(id)target action:(SEL)action
{
    return [[UPCheckbox alloc] initWithTarget:target action:action];
}

- (instancetype)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithFrame:CGRectZero];
    self.target = target;
    self.action = action;
    self.label = [UPLabel label];
    self.label.font = SpellLayout::instance().checkbox_font();
    self.label.textColorCategory = UPColorCategoryDialogTitle;
    self.label.backgroundColorCategory = UPColorCategoryClear;
    [self addSubview:self.label];
    self.gesture = [UPTapGestureRecognizer gestureWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.gesture];
    
    self.canonicalSize = SpellLayout::CanonicalCheckboxSize;
    [self setFillPath:CheckboxPath() forState:UPControlStateNormal];
    [self setStrokePath:CheckboxPath() forState:UPControlStateNormal];
    [self setAccentPath:CheckboxCheckPath() forState:UPControlStateSelected];
    [self setAccentPath:CheckboxCheckPath() forState:(UPControlStateHighlighted | UPControlStateSelected)];

    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setLabelString:(NSString *)labelString
{
    _labelString = labelString;
    self.label.string = labelString;
    [self setNeedsLayout];
}

- (void)handleTap:(UPTapGestureRecognizer *)gesture
{
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible: {
            break;
        }
        case UIGestureRecognizerStateBegan: {
            self.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.highlighted = gesture.touchInside;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.highlighted = NO;
            [self setSelected:!self.selected];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([self.target respondsToSelector:self.action]) {
                if ([NSStringFromSelector(self.action) hasSuffix:@":"]) {
                    [self.target performSelector:self.action withObject:self];
                }
                else {
                    [self.target performSelector:self.action];
                }
            }
            else {
                LOG(General, "Target does not respond to selector: %@ : %@", self.target, NSStringFromSelector(self.action));
            }
#pragma clang diagnostic pop
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed: {
            self.highlighted = NO;
            break;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    SpellLayout &layout = SpellLayout::instance();

    CGRect bounds = self.bounds;
    
    [self.label sizeToFit];
    
    CGRect labelFrame = self.label.frame;
    CGFloat labelOriginY = up_rect_height(bounds) - up_rect_height(labelFrame) + layout.checkbox_font_metrics().baseline_adjustment();
    labelFrame.origin = CGPointMake(layout.checkbox_label_left_margin(), labelOriginY);;
    self.label.frame = labelFrame;
}

@end
