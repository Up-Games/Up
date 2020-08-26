//
//  UPVectorLogoView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPLogoView : UIView

@property (nonatomic, readonly) BOOL drawsBackground;

+ (UPLogoView *)vectorLogoView; // drawsBackground = NO
+ (UPLogoView *)vectorLogoViewWithDrawsBackground:(BOOL)drawsBackground;;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame drawsBackground:(BOOL)drawsBackground;

@end
