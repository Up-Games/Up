//
//  UPLabel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UPLabel : UIView
@property (nonatomic) NSString *string;
@property (nonatomic) UIFont *font;
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) UIColor *backgroundColor;
@property (nonatomic) UIColor *textColor;

+ (UPLabel *)label;

@end
