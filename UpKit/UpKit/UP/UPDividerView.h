//
//  UPDividerView.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UIColor+UP.h>

@interface UPDivider : UIView

@property (nonatomic) UPColorCategory colorCategory;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
