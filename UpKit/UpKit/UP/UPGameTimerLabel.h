//
//  UPGameTimerLabel.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPGameTimer.h>
#import <UpKit/UPLabel.h>

@interface UPGameTimerLabel : UPLabel <UPGameTimerObserver>
@property (nonatomic) UIFont *superscriptFont;
@property (nonatomic) CGFloat superscriptBaselineAdjustment;
@property (nonatomic) CGFloat superscriptKerning;

+ (UPGameTimerLabel *)label;

@end
