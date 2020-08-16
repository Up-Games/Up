//
//  UPRotor.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/NSMutableAttributedString+UP.h>
#import <UpKit/UPGeometry.h>

#import "UIFont+UPSpell.h"
#import "UPRotor.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

static UIBezierPath *RotorBezelPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(354.95, 155.4)];
    [path addCurveToPoint: CGPointMake(354.6, 177.35) controlPoint1: CGPointMake(354.94, 162.72) controlPoint2: CGPointMake(354.77, 170.04)];
    [path addCurveToPoint: CGPointMake(353.55, 192.77) controlPoint1: CGPointMake(354.47, 182.5) controlPoint2: CGPointMake(354.17, 187.65)];
    [path addCurveToPoint: CGPointMake(351.44, 202.66) controlPoint1: CGPointMake(353.14, 196.12) controlPoint2: CGPointMake(352.63, 199.45)];
    [path addCurveToPoint: CGPointMake(349.61, 206.02) controlPoint1: CGPointMake(351, 203.85) controlPoint2: CGPointMake(350.43, 204.99)];
    [path addCurveToPoint: CGPointMake(344.97, 208.56) controlPoint1: CGPointMake(348.46, 207.48) controlPoint2: CGPointMake(346.89, 208.32)];
    [path addCurveToPoint: CGPointMake(341.09, 208.83) controlPoint1: CGPointMake(343.68, 208.72) controlPoint2: CGPointMake(342.38, 208.82)];
    [path addLineToPoint: CGPointMake(18.17, 209)];
    [path addCurveToPoint: CGPointMake(14.78, 208.72) controlPoint1: CGPointMake(17.04, 208.99) controlPoint2: CGPointMake(15.89, 208.89)];
    [path addCurveToPoint: CGPointMake(9.5, 204.89) controlPoint1: CGPointMake(12.27, 208.33) controlPoint2: CGPointMake(10.62, 206.91)];
    [path addCurveToPoint: CGPointMake(7.23, 197.94) controlPoint1: CGPointMake(8.29, 202.7) controlPoint2: CGPointMake(7.7, 200.33)];
    [path addCurveToPoint: CGPointMake(5.86, 186.6) controlPoint1: CGPointMake(6.49, 194.19) controlPoint2: CGPointMake(6.12, 190.4)];
    [path addCurveToPoint: CGPointMake(5.01, 148.41) controlPoint1: CGPointMake(5.01, 173.88) controlPoint2: CGPointMake(5.02, 161.15)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(4.99, 116.89) controlPoint2: CGPointMake(5, 104.12)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.06, 65.28) controlPoint2: CGPointMake(5.23, 57.96)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(5.53, 45.5) controlPoint2: CGPointMake(5.83, 40.35)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(6.86, 31.88) controlPoint2: CGPointMake(7.37, 28.55)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(9, 24.15) controlPoint2: CGPointMake(9.57, 23.01)];
    [path addCurveToPoint: CGPointMake(15.04, 19.44) controlPoint1: CGPointMake(11.54, 20.52) controlPoint2: CGPointMake(13.11, 19.68)];
    [path addCurveToPoint: CGPointMake(18.91, 19.17) controlPoint1: CGPointMake(16.32, 19.28) controlPoint2: CGPointMake(17.62, 19.18)];
    [path addLineToPoint: CGPointMake(341.83, 19)];
    [path addCurveToPoint: CGPointMake(345.22, 19.28) controlPoint1: CGPointMake(342.96, 19.01) controlPoint2: CGPointMake(344.1, 19.11)];
    [path addCurveToPoint: CGPointMake(350.5, 23.11) controlPoint1: CGPointMake(347.73, 19.67) controlPoint2: CGPointMake(349.38, 21.09)];
    [path addCurveToPoint: CGPointMake(352.78, 30.06) controlPoint1: CGPointMake(351.71, 25.3) controlPoint2: CGPointMake(352.3, 27.67)];
    [path addCurveToPoint: CGPointMake(354.14, 41.4) controlPoint1: CGPointMake(353.52, 33.81) controlPoint2: CGPointMake(353.88, 37.6)];
    [path addCurveToPoint: CGPointMake(354.99, 79.59) controlPoint1: CGPointMake(354.99, 54.12) controlPoint2: CGPointMake(354.98, 66.86)];
    [path addCurveToPoint: CGPointMake(354.95, 155.4) controlPoint1: CGPointMake(355.01, 111.11) controlPoint2: CGPointMake(355, 123.88)];
    [path closePath];
    [path moveToPoint: CGPointMake(0, 228)];
    [path addLineToPoint: CGPointMake(360, 228)];
    [path addLineToPoint: CGPointMake(360, 0)];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path addLineToPoint: CGPointMake(0, 228)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(341.09, 208.83)];
    [path addCurveToPoint: CGPointMake(344.96, 208.56) controlPoint1: CGPointMake(342.38, 208.82) controlPoint2: CGPointMake(343.68, 208.72)];
    [path addCurveToPoint: CGPointMake(349.61, 206.02) controlPoint1: CGPointMake(346.89, 208.32) controlPoint2: CGPointMake(348.46, 207.48)];
    [path addCurveToPoint: CGPointMake(351.44, 202.66) controlPoint1: CGPointMake(350.43, 204.99) controlPoint2: CGPointMake(351, 203.85)];
    [path addCurveToPoint: CGPointMake(353.55, 192.77) controlPoint1: CGPointMake(352.63, 199.45) controlPoint2: CGPointMake(353.14, 196.12)];
    [path addCurveToPoint: CGPointMake(354.6, 177.35) controlPoint1: CGPointMake(354.17, 187.65) controlPoint2: CGPointMake(354.47, 182.5)];
    [path addCurveToPoint: CGPointMake(354.95, 155.4) controlPoint1: CGPointMake(354.77, 170.04) controlPoint2: CGPointMake(354.94, 162.72)];
    [path addCurveToPoint: CGPointMake(354.99, 79.59) controlPoint1: CGPointMake(355, 123.88) controlPoint2: CGPointMake(355.01, 111.11)];
    [path addCurveToPoint: CGPointMake(354.14, 41.4) controlPoint1: CGPointMake(354.97, 66.85) controlPoint2: CGPointMake(354.99, 54.12)];
    [path addCurveToPoint: CGPointMake(352.78, 30.06) controlPoint1: CGPointMake(353.88, 37.6) controlPoint2: CGPointMake(353.52, 33.81)];
    [path addCurveToPoint: CGPointMake(350.5, 23.11) controlPoint1: CGPointMake(352.3, 27.67) controlPoint2: CGPointMake(351.71, 25.3)];
    [path addCurveToPoint: CGPointMake(345.22, 19.28) controlPoint1: CGPointMake(349.38, 21.09) controlPoint2: CGPointMake(347.73, 19.67)];
    [path addCurveToPoint: CGPointMake(341.83, 19) controlPoint1: CGPointMake(344.1, 19.11) controlPoint2: CGPointMake(342.96, 19.01)];
    [path addLineToPoint: CGPointMake(18.91, 19.17)];
    [path addCurveToPoint: CGPointMake(15.03, 19.44) controlPoint1: CGPointMake(17.62, 19.18) controlPoint2: CGPointMake(16.32, 19.28)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(13.11, 19.68) controlPoint2: CGPointMake(11.54, 20.52)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(9.57, 23.01) controlPoint2: CGPointMake(9, 24.15)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(7.37, 28.55) controlPoint2: CGPointMake(6.86, 31.88)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.83, 40.35) controlPoint2: CGPointMake(5.53, 45.5)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(5.23, 57.96) controlPoint2: CGPointMake(5.06, 65.28)];
    [path addCurveToPoint: CGPointMake(5.01, 148.41) controlPoint1: CGPointMake(5, 104.12) controlPoint2: CGPointMake(4.99, 116.89)];
    [path addCurveToPoint: CGPointMake(5.86, 186.6) controlPoint1: CGPointMake(5.03, 161.14) controlPoint2: CGPointMake(5.01, 173.88)];
    [path addCurveToPoint: CGPointMake(7.22, 197.94) controlPoint1: CGPointMake(6.11, 190.4) controlPoint2: CGPointMake(6.49, 194.19)];
    [path addCurveToPoint: CGPointMake(9.5, 204.89) controlPoint1: CGPointMake(7.7, 200.33) controlPoint2: CGPointMake(8.29, 202.7)];
    [path addCurveToPoint: CGPointMake(14.78, 208.72) controlPoint1: CGPointMake(10.62, 206.91) controlPoint2: CGPointMake(12.27, 208.33)];
    [path addCurveToPoint: CGPointMake(18.17, 209) controlPoint1: CGPointMake(15.9, 208.89) controlPoint2: CGPointMake(17.04, 208.99)];
    [path addLineToPoint: CGPointMake(341.09, 208.83)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(341.83, 19)];
    [path addLineToPoint: CGPointMake(18.91, 19.17)];
    [path addCurveToPoint: CGPointMake(15.03, 19.44) controlPoint1: CGPointMake(17.62, 19.18) controlPoint2: CGPointMake(16.32, 19.28)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(13.11, 19.68) controlPoint2: CGPointMake(11.54, 20.52)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(9.57, 23.01) controlPoint2: CGPointMake(9, 24.15)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(7.37, 28.55) controlPoint2: CGPointMake(6.86, 31.88)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.83, 40.35) controlPoint2: CGPointMake(5.53, 45.5)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(5.23, 57.97) controlPoint2: CGPointMake(5.06, 65.28)];
    [path addCurveToPoint: CGPointMake(5.01, 148.41) controlPoint1: CGPointMake(5, 104.12) controlPoint2: CGPointMake(4.99, 116.89)];
    [path addCurveToPoint: CGPointMake(5.86, 186.6) controlPoint1: CGPointMake(5.02, 161.15) controlPoint2: CGPointMake(5.01, 173.88)];
    [path addCurveToPoint: CGPointMake(7.22, 197.94) controlPoint1: CGPointMake(6.11, 190.4) controlPoint2: CGPointMake(6.48, 194.19)];
    [path addCurveToPoint: CGPointMake(9.5, 204.89) controlPoint1: CGPointMake(7.7, 200.33) controlPoint2: CGPointMake(8.29, 202.7)];
    [path addCurveToPoint: CGPointMake(14.78, 208.72) controlPoint1: CGPointMake(10.62, 206.91) controlPoint2: CGPointMake(12.27, 208.33)];
    [path addCurveToPoint: CGPointMake(18.17, 209) controlPoint1: CGPointMake(15.89, 208.89) controlPoint2: CGPointMake(17.04, 208.99)];
    [path addLineToPoint: CGPointMake(341.09, 208.83)];
    [path addCurveToPoint: CGPointMake(344.96, 208.56) controlPoint1: CGPointMake(342.38, 208.82) controlPoint2: CGPointMake(343.68, 208.72)];
    [path addCurveToPoint: CGPointMake(349.61, 206.02) controlPoint1: CGPointMake(346.89, 208.32) controlPoint2: CGPointMake(348.46, 207.48)];
    [path addCurveToPoint: CGPointMake(351.44, 202.66) controlPoint1: CGPointMake(350.43, 204.99) controlPoint2: CGPointMake(351, 203.85)];
    [path addCurveToPoint: CGPointMake(353.55, 192.77) controlPoint1: CGPointMake(352.63, 199.45) controlPoint2: CGPointMake(353.14, 196.12)];
    [path addCurveToPoint: CGPointMake(354.6, 177.35) controlPoint1: CGPointMake(354.17, 187.65) controlPoint2: CGPointMake(354.47, 182.5)];
    [path addCurveToPoint: CGPointMake(354.95, 155.4) controlPoint1: CGPointMake(354.77, 170.03) controlPoint2: CGPointMake(354.94, 162.72)];
    [path addCurveToPoint: CGPointMake(354.98, 79.59) controlPoint1: CGPointMake(355, 123.88) controlPoint2: CGPointMake(355.01, 111.11)];
    [path addCurveToPoint: CGPointMake(354.14, 41.4) controlPoint1: CGPointMake(354.97, 66.86) controlPoint2: CGPointMake(354.99, 54.12)];
    [path addCurveToPoint: CGPointMake(352.77, 30.06) controlPoint1: CGPointMake(353.88, 37.6) controlPoint2: CGPointMake(353.51, 33.81)];
    [path addCurveToPoint: CGPointMake(350.5, 23.11) controlPoint1: CGPointMake(352.3, 27.67) controlPoint2: CGPointMake(351.71, 25.3)];
    [path addCurveToPoint: CGPointMake(345.22, 19.28) controlPoint1: CGPointMake(349.38, 21.09) controlPoint2: CGPointMake(347.73, 19.67)];
    [path addCurveToPoint: CGPointMake(341.83, 19) controlPoint1: CGPointMake(344.1, 19.11) controlPoint2: CGPointMake(342.96, 19.01)];
    [path closePath];
    [path moveToPoint: CGPointMake(341.82, 22)];
    [path addCurveToPoint: CGPointMake(344.76, 22.25) controlPoint1: CGPointMake(342.76, 22.01) controlPoint2: CGPointMake(343.75, 22.09)];
    [path addCurveToPoint: CGPointMake(347.87, 24.56) controlPoint1: CGPointMake(346.17, 22.47) controlPoint2: CGPointMake(347.1, 23.16)];
    [path addCurveToPoint: CGPointMake(349.83, 30.64) controlPoint1: CGPointMake(348.91, 26.44) controlPoint2: CGPointMake(349.43, 28.59)];
    [path addCurveToPoint: CGPointMake(351.14, 41.6) controlPoint1: CGPointMake(350.61, 34.59) controlPoint2: CGPointMake(350.94, 38.57)];
    [path addCurveToPoint: CGPointMake(351.98, 78.53) controlPoint1: CGPointMake(351.96, 53.87) controlPoint2: CGPointMake(351.98, 66.4)];
    [path addLineToPoint: CGPointMake(351.98, 79.59)];
    [path addCurveToPoint: CGPointMake(351.95, 155.39) controlPoint1: CGPointMake(352.01, 111.43) controlPoint2: CGPointMake(352, 124.19)];
    [path addCurveToPoint: CGPointMake(351.6, 177.28) controlPoint1: CGPointMake(351.94, 162.44) controlPoint2: CGPointMake(351.79, 169.48)];
    [path addCurveToPoint: CGPointMake(350.57, 192.41) controlPoint1: CGPointMake(351.46, 182.91) controlPoint2: CGPointMake(351.12, 187.85)];
    [path addCurveToPoint: CGPointMake(348.63, 201.62) controlPoint1: CGPointMake(350.22, 195.27) controlPoint2: CGPointMake(349.76, 198.57)];
    [path addCurveToPoint: CGPointMake(347.26, 204.16) controlPoint1: CGPointMake(348.24, 202.67) controlPoint2: CGPointMake(347.8, 203.48)];
    [path addCurveToPoint: CGPointMake(344.59, 205.59) controlPoint1: CGPointMake(346.6, 204.99) controlPoint2: CGPointMake(345.76, 205.44)];
    [path addCurveToPoint: CGPointMake(341.09, 205.83) controlPoint1: CGPointMake(343.38, 205.74) controlPoint2: CGPointMake(342.19, 205.82)];
    [path addLineToPoint: CGPointMake(18.19, 206)];
    [path addCurveToPoint: CGPointMake(15.24, 205.75) controlPoint1: CGPointMake(17.25, 205.99) controlPoint2: CGPointMake(16.26, 205.91)];
    [path addCurveToPoint: CGPointMake(12.13, 203.44) controlPoint1: CGPointMake(13.83, 205.53) controlPoint2: CGPointMake(12.9, 204.84)];
    [path addCurveToPoint: CGPointMake(10.17, 197.36) controlPoint1: CGPointMake(11.09, 201.56) controlPoint2: CGPointMake(10.57, 199.41)];
    [path addCurveToPoint: CGPointMake(8.85, 186.4) controlPoint1: CGPointMake(9.39, 193.41) controlPoint2: CGPointMake(9.06, 189.43)];
    [path addCurveToPoint: CGPointMake(8.02, 149.47) controlPoint1: CGPointMake(8.03, 174.14) controlPoint2: CGPointMake(8.02, 161.6)];
    [path addLineToPoint: CGPointMake(8.01, 148.41)];
    [path addCurveToPoint: CGPointMake(8.05, 72.61) controlPoint1: CGPointMake(7.99, 116.54) controlPoint2: CGPointMake(8, 103.78)];
    [path addCurveToPoint: CGPointMake(8.4, 50.72) controlPoint1: CGPointMake(8.06, 65.55) controlPoint2: CGPointMake(8.21, 58.52)];
    [path addCurveToPoint: CGPointMake(9.43, 35.59) controlPoint1: CGPointMake(8.54, 45.09) controlPoint2: CGPointMake(8.87, 40.15)];
    [path addCurveToPoint: CGPointMake(11.37, 26.38) controlPoint1: CGPointMake(9.78, 32.74) controlPoint2: CGPointMake(10.24, 29.43)];
    [path addCurveToPoint: CGPointMake(12.74, 23.84) controlPoint1: CGPointMake(11.76, 25.33) controlPoint2: CGPointMake(12.2, 24.52)];
    [path addCurveToPoint: CGPointMake(15.41, 22.41) controlPoint1: CGPointMake(13.39, 23.01) controlPoint2: CGPointMake(14.24, 22.56)];
    [path addCurveToPoint: CGPointMake(18.91, 22.17) controlPoint1: CGPointMake(16.62, 22.26) controlPoint2: CGPointMake(17.81, 22.18)];
    [path addLineToPoint: CGPointMake(341.82, 22)];
    [path closePath];
    return path;
}

// =========================================================================================================================================

@interface UPRotorLabel : UIView
@property (nonatomic) NSArray<NSString *> *elements;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic) CGFloat elementHeight;
@end

@implementation UPRotorLabel

- (instancetype)initWithElements:(NSArray<NSString *> *)elements elementHeight:(CGFloat)elementHeight
{
    self = [super initWithFrame:CGRectZero];
    self.elements = elements;
    self.elementHeight = elementHeight;
    self.opaque = NO;
    return self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    SpellLayout &layout = SpellLayout::instance();
    UIFont *font = layout.rotor_control_font();
    
    CGRect bounds = self.bounds;
    CGFloat elementY = 0;
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@" "];
    [attrString setTextAlignment:NSTextAlignmentCenter];
    [attrString setFont:font];
    NSUInteger i = 0;
    elementY = self.elementHeight * 2;
    UIColor *selectedColor = [UIColor themeColorWithCategory:UPColorCategoryContent];
    UIColor *unselectedColor = [selectedColor colorWithAlphaComponent:[UIColor themeControlContentInactiveAlpha]];
    for (NSString *element in self.elements) {
        attrString.string = element;
        if (i == self.selectedIndex) {
            [attrString setTextColor:selectedColor];
        }
        else {
            [attrString setTextColor:unselectedColor];
        }
        CGRect textRect = CGRectMake(0, elementY, up_rect_width(bounds), self.elementHeight);
        CGRect elementRect = textRect;
        elementRect.size.height = font.lineHeight;
        elementRect = up_rect_centered_in_rect(elementRect, textRect);
        elementRect.origin.y -= (font.lineHeight * 0.035);
        [attrString drawInRect:elementRect];
        elementY += self.elementHeight;
        i++;
    }
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [self setNeedsDisplay];
}

@end

// =========================================================================================================================================

@interface UPRotor () <UIScrollViewDelegate>
@property (nonatomic, readwrite) NSArray<NSString *> *elements;
@property (nonatomic, readwrite) BOOL changing;
@property (nonatomic, weak) id target;
@property (nonatomic) SEL action;
@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) UPRotorLabel *elementsLabel;
@property (nonatomic) CGFloat elementHeight;
@end

@implementation UPRotor

+ (UPRotor *)rotorWithElements:(NSArray<NSString *> *)elements
{
    return [[UPRotor alloc] initWithElements:elements];
}

- (instancetype)initWithElements:(NSArray<NSString *> *)elements
{
    self = [super initWithFrame:CGRectZero];

    self.elements = elements;

    self.clipsToBounds = YES;
    
    SpellLayout &layout = SpellLayout::instance();
    
    self.canonicalSize = SpellLayout::CanonicalRotorSize;

    [self setFillPath:RotorFillPath()];
    [self setFillColorCategory:UPColorCategoryPrimaryFill];
    [self setStrokePath:RotorStrokePath()];
    [self setAuxiliaryPath:RotorBezelPath()];
    [self setAuxiliaryColorCategory:UPColorCategoryInfinity];

    // There is a maximum of five elements visible in the rotor at once, and when the rotor
    // is at rest, the middle of these five is "selected" and appears centered vertically
    // in the rotor.
    static constexpr NSUInteger VisibleElementsCount = 5;
    self.elementHeight = (self.canonicalSize.height / VisibleElementsCount) * layout.layout_scale();
    self.elementsLabel = [[UPRotorLabel alloc] initWithElements:self.elements elementHeight:self.elementHeight];

    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delaysContentTouches = NO;
    [self.scrollView addSubview:self.elementsLabel];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    [self bringPathViewToFront:self.auxiliaryPathView];
    [self bringPathViewToFront:self.strokePathView];

    return self;
}

- (void)selectIndex:(NSUInteger)index
{
    ASSERT(index < self.elements.count);
    [self setSelectedIndex:index];
    self.scrollView.contentOffset = CGPointMake(0, index * self.elementHeight);
}

@dynamic selectedString;
- (NSString *)selectedString
{
    return self.elements[self.selectedIndex];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    ASSERT(selectedIndex < self.elements.count);
    _selectedIndex = selectedIndex;
    [self.elementsLabel setSelectedIndex:selectedIndex];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return CGRectContainsPoint(self.bounds, point) ? self.scrollView : nil;
}

- (void)setTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setChanging:(BOOL)changing
{
    _changing = changing;
    [self sendAction];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    self.scrollView.frame = bounds;
    
    // There are four "phantom" elements, two above the top element and two below the bottom element.
    // These create room for the top and bottom elements to be centered in the rotor.
    static constexpr NSUInteger PhantomElementsCount = 4;
    CGFloat elementsLabelHeight = (PhantomElementsCount + self.elements.count) * self.elementHeight;
    
    self.elementsLabel.frame = CGRectMake(0, 0, up_rect_width(bounds), elementsLabelHeight);
    self.scrollView.contentSize = self.elementsLabel.frame.size;
}

- (void)sendAction
{
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
}

#pragma mark - UIScrollVoewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    NSUInteger selectedIndex = 0;
    CGFloat dy = FLT_MAX;
    for (NSUInteger i = 0; i < self.elements.count; i++) {
        CGFloat toffsetY = i * self.elementHeight;
        CGFloat tdy = fabs(toffsetY - offsetY);
        if (tdy < dy) {
            dy = tdy;
            selectedIndex = i;
        }
    }
    BOOL changed = (self.selectedIndex != selectedIndex);
    [self setSelectedIndex:selectedIndex];
    if (changed) {
        [self sendAction];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat offsetY = targetContentOffset->y;
    CGFloat closestY = 0;
    CGFloat dy = FLT_MAX;
    for (NSUInteger i = 0; i < self.elements.count; i++) {
        CGFloat toffsetY = i * self.elementHeight;
        CGFloat tdy = fabs(toffsetY - offsetY);
        if (tdy < dy) {
            dy = tdy;
            closestY = toffsetY;
        }
        
    }
    targetContentOffset->y = closestY;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.changing = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)willDecelerate
{
    if (!willDecelerate) {
        [self setChanging:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setChanging:NO];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self setChanging:NO];
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.elementsLabel updateThemeColors];
}

@end
