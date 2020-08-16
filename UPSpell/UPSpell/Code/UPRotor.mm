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
    [path moveToPoint: CGPointMake(394.95, 177.4)];
    [path addCurveToPoint: CGPointMake(394.6, 199.35) controlPoint1: CGPointMake(394.94, 184.72) controlPoint2: CGPointMake(394.77, 192.04)];
    [path addCurveToPoint: CGPointMake(393.55, 214.77) controlPoint1: CGPointMake(394.47, 204.5) controlPoint2: CGPointMake(394.17, 209.65)];
    [path addCurveToPoint: CGPointMake(391.44, 224.66) controlPoint1: CGPointMake(393.14, 218.12) controlPoint2: CGPointMake(392.63, 221.45)];
    [path addCurveToPoint: CGPointMake(389.61, 228.02) controlPoint1: CGPointMake(391, 225.85) controlPoint2: CGPointMake(390.43, 226.99)];
    [path addCurveToPoint: CGPointMake(384.97, 230.56) controlPoint1: CGPointMake(388.46, 229.48) controlPoint2: CGPointMake(386.89, 230.32)];
    [path addCurveToPoint: CGPointMake(381.09, 230.83) controlPoint1: CGPointMake(383.68, 230.72) controlPoint2: CGPointMake(382.38, 230.82)];
    [path addLineToPoint: CGPointMake(18.17, 231)];
    [path addCurveToPoint: CGPointMake(14.78, 230.72) controlPoint1: CGPointMake(17.04, 230.99) controlPoint2: CGPointMake(15.89, 230.89)];
    [path addCurveToPoint: CGPointMake(9.5, 226.89) controlPoint1: CGPointMake(12.27, 230.33) controlPoint2: CGPointMake(10.62, 228.91)];
    [path addCurveToPoint: CGPointMake(7.23, 219.94) controlPoint1: CGPointMake(8.29, 224.7) controlPoint2: CGPointMake(7.7, 222.33)];
    [path addCurveToPoint: CGPointMake(5.86, 208.6) controlPoint1: CGPointMake(6.49, 216.19) controlPoint2: CGPointMake(6.12, 212.4)];
    [path addCurveToPoint: CGPointMake(5.01, 170.41) controlPoint1: CGPointMake(5.01, 195.88) controlPoint2: CGPointMake(5.02, 183.15)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(4.99, 138.89) controlPoint2: CGPointMake(5, 104.12)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.06, 65.28) controlPoint2: CGPointMake(5.23, 57.96)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(5.53, 45.5) controlPoint2: CGPointMake(5.83, 40.35)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(6.86, 31.88) controlPoint2: CGPointMake(7.37, 28.55)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(9, 24.15) controlPoint2: CGPointMake(9.57, 23.01)];
    [path addCurveToPoint: CGPointMake(15.04, 19.44) controlPoint1: CGPointMake(11.54, 20.52) controlPoint2: CGPointMake(13.11, 19.68)];
    [path addCurveToPoint: CGPointMake(18.91, 19.17) controlPoint1: CGPointMake(16.32, 19.28) controlPoint2: CGPointMake(17.62, 19.18)];
    [path addLineToPoint: CGPointMake(381.83, 19)];
    [path addCurveToPoint: CGPointMake(385.22, 19.28) controlPoint1: CGPointMake(382.96, 19.01) controlPoint2: CGPointMake(384.1, 19.11)];
    [path addCurveToPoint: CGPointMake(390.5, 23.11) controlPoint1: CGPointMake(387.73, 19.67) controlPoint2: CGPointMake(389.38, 21.09)];
    [path addCurveToPoint: CGPointMake(392.78, 30.06) controlPoint1: CGPointMake(391.71, 25.3) controlPoint2: CGPointMake(392.3, 27.67)];
    [path addCurveToPoint: CGPointMake(394.14, 41.4) controlPoint1: CGPointMake(393.52, 33.81) controlPoint2: CGPointMake(393.88, 37.6)];
    [path addCurveToPoint: CGPointMake(394.99, 79.59) controlPoint1: CGPointMake(394.99, 54.12) controlPoint2: CGPointMake(394.98, 66.86)];
    [path addCurveToPoint: CGPointMake(394.95, 177.4) controlPoint1: CGPointMake(395.01, 111.11) controlPoint2: CGPointMake(395, 145.88)];
    [path closePath];
    [path moveToPoint: CGPointMake(0, 250)];
    [path addLineToPoint: CGPointMake(400, 250)];
    [path addLineToPoint: CGPointMake(400, 0)];
    [path addLineToPoint: CGPointMake(0, 0)];
    [path addLineToPoint: CGPointMake(0, 250)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorFillPath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(381.09, 230.83)];
    [path addCurveToPoint: CGPointMake(384.96, 230.56) controlPoint1: CGPointMake(382.38, 230.82) controlPoint2: CGPointMake(383.68, 230.72)];
    [path addCurveToPoint: CGPointMake(389.61, 228.02) controlPoint1: CGPointMake(386.89, 230.32) controlPoint2: CGPointMake(388.46, 229.48)];
    [path addCurveToPoint: CGPointMake(391.44, 224.66) controlPoint1: CGPointMake(390.43, 226.99) controlPoint2: CGPointMake(391, 225.85)];
    [path addCurveToPoint: CGPointMake(393.55, 214.77) controlPoint1: CGPointMake(392.63, 221.45) controlPoint2: CGPointMake(393.14, 218.12)];
    [path addCurveToPoint: CGPointMake(394.6, 199.35) controlPoint1: CGPointMake(394.17, 209.65) controlPoint2: CGPointMake(394.47, 204.5)];
    [path addCurveToPoint: CGPointMake(394.95, 177.4) controlPoint1: CGPointMake(394.77, 192.04) controlPoint2: CGPointMake(394.94, 184.72)];
    [path addCurveToPoint: CGPointMake(394.99, 79.59) controlPoint1: CGPointMake(395, 145.88) controlPoint2: CGPointMake(395.01, 111.11)];
    [path addCurveToPoint: CGPointMake(394.14, 41.4) controlPoint1: CGPointMake(394.97, 66.85) controlPoint2: CGPointMake(394.99, 54.12)];
    [path addCurveToPoint: CGPointMake(392.78, 30.06) controlPoint1: CGPointMake(393.88, 37.6) controlPoint2: CGPointMake(393.52, 33.81)];
    [path addCurveToPoint: CGPointMake(390.5, 23.11) controlPoint1: CGPointMake(392.3, 27.67) controlPoint2: CGPointMake(391.71, 25.3)];
    [path addCurveToPoint: CGPointMake(385.22, 19.28) controlPoint1: CGPointMake(389.38, 21.09) controlPoint2: CGPointMake(387.73, 19.67)];
    [path addCurveToPoint: CGPointMake(381.83, 19) controlPoint1: CGPointMake(384.1, 19.11) controlPoint2: CGPointMake(382.96, 19.01)];
    [path addLineToPoint: CGPointMake(18.91, 19.17)];
    [path addCurveToPoint: CGPointMake(15.03, 19.44) controlPoint1: CGPointMake(17.62, 19.18) controlPoint2: CGPointMake(16.32, 19.28)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(13.11, 19.68) controlPoint2: CGPointMake(11.54, 20.52)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(9.57, 23.01) controlPoint2: CGPointMake(9, 24.15)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(7.37, 28.55) controlPoint2: CGPointMake(6.86, 31.88)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.83, 40.35) controlPoint2: CGPointMake(5.53, 45.5)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(5.23, 57.96) controlPoint2: CGPointMake(5.06, 65.28)];
    [path addCurveToPoint: CGPointMake(5.01, 170.41) controlPoint1: CGPointMake(5, 104.12) controlPoint2: CGPointMake(4.99, 138.89)];
    [path addCurveToPoint: CGPointMake(5.86, 208.6) controlPoint1: CGPointMake(5.03, 183.14) controlPoint2: CGPointMake(5.01, 195.88)];
    [path addCurveToPoint: CGPointMake(7.22, 219.94) controlPoint1: CGPointMake(6.11, 212.4) controlPoint2: CGPointMake(6.49, 216.19)];
    [path addCurveToPoint: CGPointMake(9.5, 226.89) controlPoint1: CGPointMake(7.7, 222.33) controlPoint2: CGPointMake(8.29, 224.7)];
    [path addCurveToPoint: CGPointMake(14.78, 230.72) controlPoint1: CGPointMake(10.62, 228.91) controlPoint2: CGPointMake(12.27, 230.33)];
    [path addCurveToPoint: CGPointMake(18.17, 231) controlPoint1: CGPointMake(15.9, 230.89) controlPoint2: CGPointMake(17.04, 230.99)];
    [path addLineToPoint: CGPointMake(381.09, 230.83)];
    [path closePath];
    return path;
}

static UIBezierPath *RotorStrokePath()
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(381.83, 19)];
    [path addLineToPoint: CGPointMake(18.91, 19.17)];
    [path addCurveToPoint: CGPointMake(15.03, 19.44) controlPoint1: CGPointMake(17.62, 19.18) controlPoint2: CGPointMake(16.32, 19.28)];
    [path addCurveToPoint: CGPointMake(10.39, 21.98) controlPoint1: CGPointMake(13.11, 19.68) controlPoint2: CGPointMake(11.54, 20.52)];
    [path addCurveToPoint: CGPointMake(8.56, 25.34) controlPoint1: CGPointMake(9.57, 23.01) controlPoint2: CGPointMake(9, 24.15)];
    [path addCurveToPoint: CGPointMake(6.45, 35.23) controlPoint1: CGPointMake(7.37, 28.55) controlPoint2: CGPointMake(6.86, 31.88)];
    [path addCurveToPoint: CGPointMake(5.4, 50.65) controlPoint1: CGPointMake(5.83, 40.35) controlPoint2: CGPointMake(5.53, 45.5)];
    [path addCurveToPoint: CGPointMake(5.05, 72.6) controlPoint1: CGPointMake(5.23, 57.97) controlPoint2: CGPointMake(5.06, 65.28)];
    [path addCurveToPoint: CGPointMake(5.01, 170.41) controlPoint1: CGPointMake(5, 104.12) controlPoint2: CGPointMake(4.99, 138.89)];
    [path addCurveToPoint: CGPointMake(5.86, 208.6) controlPoint1: CGPointMake(5.02, 183.15) controlPoint2: CGPointMake(5.01, 195.88)];
    [path addCurveToPoint: CGPointMake(7.22, 219.94) controlPoint1: CGPointMake(6.11, 212.4) controlPoint2: CGPointMake(6.48, 216.19)];
    [path addCurveToPoint: CGPointMake(9.5, 226.89) controlPoint1: CGPointMake(7.7, 222.33) controlPoint2: CGPointMake(8.29, 224.7)];
    [path addCurveToPoint: CGPointMake(14.78, 230.72) controlPoint1: CGPointMake(10.62, 228.91) controlPoint2: CGPointMake(12.27, 230.33)];
    [path addCurveToPoint: CGPointMake(18.17, 231) controlPoint1: CGPointMake(15.89, 230.89) controlPoint2: CGPointMake(17.04, 230.99)];
    [path addLineToPoint: CGPointMake(381.09, 230.83)];
    [path addCurveToPoint: CGPointMake(384.96, 230.56) controlPoint1: CGPointMake(382.38, 230.82) controlPoint2: CGPointMake(383.68, 230.72)];
    [path addCurveToPoint: CGPointMake(389.61, 228.02) controlPoint1: CGPointMake(386.89, 230.32) controlPoint2: CGPointMake(388.46, 229.48)];
    [path addCurveToPoint: CGPointMake(391.44, 224.66) controlPoint1: CGPointMake(390.43, 226.99) controlPoint2: CGPointMake(391, 225.85)];
    [path addCurveToPoint: CGPointMake(393.55, 214.77) controlPoint1: CGPointMake(392.63, 221.45) controlPoint2: CGPointMake(393.14, 218.12)];
    [path addCurveToPoint: CGPointMake(394.6, 199.35) controlPoint1: CGPointMake(394.17, 209.65) controlPoint2: CGPointMake(394.47, 204.5)];
    [path addCurveToPoint: CGPointMake(394.95, 177.4) controlPoint1: CGPointMake(394.77, 192.03) controlPoint2: CGPointMake(394.94, 184.72)];
    [path addCurveToPoint: CGPointMake(394.98, 79.59) controlPoint1: CGPointMake(395, 145.88) controlPoint2: CGPointMake(395.01, 111.11)];
    [path addCurveToPoint: CGPointMake(394.14, 41.4) controlPoint1: CGPointMake(394.97, 66.86) controlPoint2: CGPointMake(394.99, 54.12)];
    [path addCurveToPoint: CGPointMake(392.77, 30.06) controlPoint1: CGPointMake(393.88, 37.6) controlPoint2: CGPointMake(393.51, 33.81)];
    [path addCurveToPoint: CGPointMake(390.5, 23.11) controlPoint1: CGPointMake(392.3, 27.67) controlPoint2: CGPointMake(391.71, 25.3)];
    [path addCurveToPoint: CGPointMake(385.22, 19.28) controlPoint1: CGPointMake(389.38, 21.09) controlPoint2: CGPointMake(387.73, 19.67)];
    [path addCurveToPoint: CGPointMake(381.83, 19) controlPoint1: CGPointMake(384.1, 19.11) controlPoint2: CGPointMake(382.96, 19.01)];
    [path closePath];
    [path moveToPoint: CGPointMake(381.82, 22)];
    [path addCurveToPoint: CGPointMake(384.76, 22.25) controlPoint1: CGPointMake(382.76, 22.01) controlPoint2: CGPointMake(383.75, 22.09)];
    [path addCurveToPoint: CGPointMake(387.87, 24.56) controlPoint1: CGPointMake(386.17, 22.47) controlPoint2: CGPointMake(387.1, 23.16)];
    [path addCurveToPoint: CGPointMake(389.83, 30.64) controlPoint1: CGPointMake(388.91, 26.44) controlPoint2: CGPointMake(389.43, 28.59)];
    [path addCurveToPoint: CGPointMake(391.14, 41.6) controlPoint1: CGPointMake(390.61, 34.59) controlPoint2: CGPointMake(390.94, 38.57)];
    [path addCurveToPoint: CGPointMake(391.98, 78.53) controlPoint1: CGPointMake(391.96, 53.86) controlPoint2: CGPointMake(391.98, 66.4)];
    [path addLineToPoint: CGPointMake(391.98, 79.59)];
    [path addCurveToPoint: CGPointMake(391.95, 177.39) controlPoint1: CGPointMake(392.01, 110.81) controlPoint2: CGPointMake(392, 145.55)];
    [path addCurveToPoint: CGPointMake(391.6, 199.28) controlPoint1: CGPointMake(391.94, 184.45) controlPoint2: CGPointMake(391.79, 191.48)];
    [path addCurveToPoint: CGPointMake(390.57, 214.41) controlPoint1: CGPointMake(391.46, 204.91) controlPoint2: CGPointMake(391.12, 209.85)];
    [path addCurveToPoint: CGPointMake(388.63, 223.62) controlPoint1: CGPointMake(390.22, 217.27) controlPoint2: CGPointMake(389.76, 220.57)];
    [path addCurveToPoint: CGPointMake(387.26, 226.16) controlPoint1: CGPointMake(388.24, 224.67) controlPoint2: CGPointMake(387.8, 225.48)];
    [path addCurveToPoint: CGPointMake(384.59, 227.59) controlPoint1: CGPointMake(386.6, 226.99) controlPoint2: CGPointMake(385.76, 227.44)];
    [path addCurveToPoint: CGPointMake(381.09, 227.83) controlPoint1: CGPointMake(383.38, 227.74) controlPoint2: CGPointMake(382.19, 227.82)];
    [path addLineToPoint: CGPointMake(18.19, 228)];
    [path addCurveToPoint: CGPointMake(15.24, 227.75) controlPoint1: CGPointMake(17.25, 227.99) controlPoint2: CGPointMake(16.26, 227.91)];
    [path addCurveToPoint: CGPointMake(12.13, 225.44) controlPoint1: CGPointMake(13.83, 227.53) controlPoint2: CGPointMake(12.9, 226.84)];
    [path addCurveToPoint: CGPointMake(10.17, 219.36) controlPoint1: CGPointMake(11.09, 223.56) controlPoint2: CGPointMake(10.57, 221.41)];
    [path addCurveToPoint: CGPointMake(8.85, 208.4) controlPoint1: CGPointMake(9.39, 215.41) controlPoint2: CGPointMake(9.06, 211.43)];
    [path addCurveToPoint: CGPointMake(8.02, 171.47) controlPoint1: CGPointMake(8.03, 196.13) controlPoint2: CGPointMake(8.02, 183.59)];
    [path addLineToPoint: CGPointMake(8.01, 170.41)];
    [path addCurveToPoint: CGPointMake(8.05, 72.61) controlPoint1: CGPointMake(7.99, 139.14) controlPoint2: CGPointMake(8, 104.4)];
    [path addCurveToPoint: CGPointMake(8.4, 50.72) controlPoint1: CGPointMake(8.06, 65.56) controlPoint2: CGPointMake(8.21, 58.52)];
    [path addCurveToPoint: CGPointMake(9.43, 35.59) controlPoint1: CGPointMake(8.54, 45.09) controlPoint2: CGPointMake(8.87, 40.15)];
    [path addCurveToPoint: CGPointMake(11.37, 26.38) controlPoint1: CGPointMake(9.78, 32.73) controlPoint2: CGPointMake(10.24, 29.43)];
    [path addCurveToPoint: CGPointMake(12.74, 23.84) controlPoint1: CGPointMake(11.76, 25.33) controlPoint2: CGPointMake(12.2, 24.52)];
    [path addCurveToPoint: CGPointMake(15.41, 22.41) controlPoint1: CGPointMake(13.39, 23.01) controlPoint2: CGPointMake(14.24, 22.56)];
    [path addCurveToPoint: CGPointMake(18.91, 22.17) controlPoint1: CGPointMake(16.62, 22.26) controlPoint2: CGPointMake(17.81, 22.18)];
    [path addLineToPoint: CGPointMake(381.82, 22)];
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
