//
//  UPLogoView.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPLogoView : UIView

@property (nonatomic, readonly) BOOL drawsBackground;

+ (UPLogoView *)logoView; // drawsBackground = NO
+ (UPLogoView *)logoViewWithDrawsBackground:(BOOL)drawsBackground;;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame drawsBackground:(BOOL)drawsBackground;

@end
