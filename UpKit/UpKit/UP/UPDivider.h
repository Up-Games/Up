//
//  UPDivider.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UIColor+UP.h>

@interface UPDivider : UIView

@property (nonatomic) UPColorCategory colorCategory;

+ (UPDivider *)divider;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
