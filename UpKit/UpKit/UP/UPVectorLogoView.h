//
//  UPVectorLogoView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPVectorLogoView : UIView

@property (nonatomic, readonly) BOOL drawsBackground;

+ (UPVectorLogoView *)vectorLogoView; // drawsBackground = NO
+ (UPVectorLogoView *)vectorLogoViewWithDrawsBackground:(BOOL)drawsBackground;;
//+ (UPVectorLogoView *)vectorLogoViewWithHue:(int)hue drawsBackground:(BOOL)drawsBackground;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame drawsBackground:(BOOL)drawsBackground;

@end
