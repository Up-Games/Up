//
//  UPGradientView.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPNeedsUpdater.h>

typedef NS_ENUM(NSInteger, UPGradientType) {
    UPGradientTypeDefault,
    UPGradientTypeLinear,
    UPGradientTypeRadial,
    UPGradientTypeConic,
};

@interface UPGradientView : UIView
@property (nonatomic, readonly) CAGradientLayer *gradientLayer;
@property (nonatomic) NSArray<UIColor *> *colors;
@property (nonatomic) NSArray<NSNumber *> *locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) UPGradientType type;

+ (UPGradientView *)gradientView;
+ (UPGradientView *)gradientViewWithFrame:(CGRect)frame;

@end
