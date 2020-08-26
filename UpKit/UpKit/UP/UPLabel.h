//
//  UPLabel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UPKit/UIColor+UP.h>

@interface UPLabel : UIView
@property (nonatomic) NSString *string;
@property (nonatomic) NSAttributedString *attributedString;
@property (nonatomic) UIFont *font;
@property (nonatomic) UPColorCategory colorCategory;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) BOOL addsLeftwardScoot;
@property (nonatomic) BOOL wrapped;

+ (UPLabel *)label;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)init;

- (void)centerInSuperview;

@end
