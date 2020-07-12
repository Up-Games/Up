//
//  UPDividerLabel.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UPDivider.h>
#import <UpKit/UPGeometry.h>

#import "UPDividerLabel.h"

@interface UPDividerLabel ()
@property (nonatomic) UPDivider *dividerView;
@end

@implementation UPDividerLabel

+ (UPDividerLabel *)label
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    
    self.dividerHeight = 2;
    self.dividerOffset = 0;

    self.dividerView = [UPDivider divider];
    [self addSubview:self.dividerView];
    
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    
    CGRect underlineFrame = bounds;
    underlineFrame.size.height = self.dividerHeight;
    underlineFrame.origin.y = up_rect_height(bounds) - self.dividerHeight + self.dividerOffset;
    self.dividerView.frame = underlineFrame;
}

#pragma mark - Update theme colors

- (void)updateThemeColors
{
    [super updateThemeColors];
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
