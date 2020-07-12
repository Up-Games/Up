//
//  UPDividerLabel.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UPLabel.h>

@interface UPDividerLabel : UPLabel

@property (nonatomic) CGFloat dividerOffset;
@property (nonatomic) CGFloat dividerHeight;

+ (UPDividerLabel *)label;

@end
