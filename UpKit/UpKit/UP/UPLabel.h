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
@property (nonatomic) NSTextAlignment textAlignment;
@property (nonatomic) UPColorCategory backgroundColorCategory;
@property (nonatomic) UPColorCategory textColorCategory;

+ (UPLabel *)label;

@end
