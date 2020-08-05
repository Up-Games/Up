//
//  UPSlider.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPGeometry.h>
#import <UpKit/UPMath.h>
#import <UpKit/UPSlideGestureRecognizer.h>

#import "UPSpellLayout.h"
#import "UPSlider.h"

using UP::SpellLayout;

//UIBezierPath *SliderChannelFillPath()
//{
//    return [UIBezierPath bezierPathWithRect: CGRectMake(0, 0, 280, 76)];
//}

//UIBezierPath *ChoiceStrokePath()
//{
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint: CGPointMake(0, 76)];
//    [path addLineToPoint: CGPointMake(280, 76)];
//    [path addLineToPoint: CGPointMake(280, 0)];
//    [path addLineToPoint: CGPointMake(0, 0)];
//    [path addLineToPoint: CGPointMake(0, 76)];
//    [path closePath];
//    [path moveToPoint: CGPointMake(3, 3)];
//    [path addLineToPoint: CGPointMake(277, 3)];
//    [path addLineToPoint: CGPointMake(277, 73)];
//    [path addLineToPoint: CGPointMake(3, 73)];
//    [path addLineToPoint: CGPointMake(3, 3)];
//    [path closePath];
//    return path;
//}

@interface UPSlider ()
@property (nonatomic, readwrite) BOOL discrete;
@property (nonatomic, readwrite) NSUInteger marks;
@property (nonatomic, readwrite) NSUInteger valueAsMark;
@property (nonatomic, readwrite) CGFloat valueAsFraction;
@property (nonatomic, readwrite) UPSlideGestureRecognizer *slideGesture;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@end

@implementation UPSlider

+ (UPSlider *)discreteSliderWithMarks:(NSUInteger)marks
{
    return [[UPSlider alloc] initWithDiscrete:YES marks:marks];
}

+ (UPSlider *)continuousSliderWithMarks:(NSUInteger)marks
{
    return [[UPSlider alloc] initWithDiscrete:NO marks:marks];
}

- (instancetype)initWithDiscrete:(BOOL)discrete marks:(NSUInteger)marks
{
    self = [super initWithFrame:CGRectZero];
    self.discrete = discrete;
    self.marks = marks;

    self.canonicalSize = SpellLayout::CanonicalSliderSize;
    self.slideGesture = [UPSlideGestureRecognizer gestureWithTarget:self action:@selector(handleSlide:)];
    [self addGestureRecognizer:self.slideGesture];

    self.backgroundColor = [UIColor testColor1];
    
//    [self setFillPath:ChoiceFillPath() forState:UPControlStateSelected];
//    [self setFillColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
//    [self setFillColorCategory:UPColorCategoryControlShapeActiveFill forState:UPControlStateSelected];
//    [self setFillColorCategory:UPColorCategoryClear forState:UPControlStateDisabled];
//
//    [self setStrokePath:ChoiceStrokePath() forState:UPControlStateSelected];
//    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateNormal];
//    [self setStrokeColorCategory:UPColorCategoryPrimaryStroke forState:UPControlStateSelected];
//    [self setStrokeColorCategory:UPColorCategoryClear forState:UPControlStateDisabled];

    return self;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setMarkValue:(NSUInteger)markValue
{
    self.valueAsMark = UPClampT(NSUInteger, markValue, 0, self.marks);
    self.valueAsFraction = self.marks > 0 ? (self.valueAsMark / (CGFloat)self.marks) : 0.0;
    [self setNeedsLayout];
}

- (void)setFractionValue:(CGFloat)fractionValue
{
    self.valueAsFraction = UPClampT(CGFloat, fractionValue, 0.0, 1.0);
    if (self.marks == 0) {
        self.valueAsMark = 0;
    }
    else {
        self.valueAsMark = round(self.valueAsFraction * self.marks);
    }
    [self setNeedsLayout];
}

- (void)handleSlide:(UPSlideGestureRecognizer *)gesture
{
    if (!self.enabled) {
        return;
    }

    CGRect bounds = self.bounds;
    CGFloat scale = up_rect_width(bounds) / up_size_width(SpellLayout::CanonicalSliderSize);
    constexpr CGFloat CanonicalTrackWidth = up_size_width(SpellLayout::CanonicalSliderSize) - (SpellLayout::CanonicalSliderIconInset * 2);
    CGFloat scaledTrackWidth = CanonicalTrackWidth * scale;
    CGFloat scaledInset = SpellLayout::CanonicalSliderIconInset * scale;

    CGPoint point = gesture.locationInView;
    CGFloat x = point.x - scaledInset;

    self.valueAsFraction = UPClampT(CGFloat, x / scaledTrackWidth, 0.0, 1.0);
    if (self.marks == 0) {
        self.valueAsMark = 0;
    }
    else {
        self.valueAsMark = round(self.valueAsFraction * self.marks);
    }
    
    [self setNeedsLayout];

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
    else if (self.target || self.action) {
        LOG(General, "Target does not respond to selector: %@ : %@", self.target, NSStringFromSelector(self.action));
    }
#pragma clang diagnostic pop
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    SpellLayout &layout = SpellLayout::instance();
//    CGRect bounds = self.bounds;
    
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
}

@end
