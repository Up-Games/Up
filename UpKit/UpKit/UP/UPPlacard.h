//
//  UPPlacard.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UIColor+UP.h>

@interface UPPlacard : UIView

@property (nonatomic) NSAttributedString *attributedString;
@property (nonatomic) UPColorCategory colorCategory;
@property (nonatomic) BOOL enabled;

+ (UPPlacard *)placard;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init;

@end
