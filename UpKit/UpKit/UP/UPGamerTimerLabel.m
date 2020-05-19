//
//  UPGamerTimerLabel.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UPGameTimerLabel.h"

@implementation UPGameTimerLabel

#pragma mark - UPGameTimerObserver

- (void)gameTimerStarted:(UPGameTimer *)gameTimer
{
    NSLog(@"gameTimerStarted");
}

- (void)gameTimerStopped:(UPGameTimer *)gameTimer
{
    NSLog(@"gameTimerStopped");
}

- (void)gameTimerReset:(UPGameTimer *)gameTimer
{
    NSLog(@"gameTimerReset");
}

- (void)gameTimerPeriodicUpdate:(UPGameTimer *)gameTimer
{
    NSLog(@"gameTimerPeriodicUpdate: %.2f", gameTimer.remainingTime);
    
    double integer_part;
    double fractional_part = modf(gameTimer.remainingTime, &integer_part);
    NSInteger t = integer_part;
    NSInteger minutes = t / 60;
    t -= (minutes * 60);
    NSInteger secondsTens = t / 10;
    t -= (secondsTens * 10);
    NSInteger secondsOnes = t;
    NSInteger secondsTenths = fractional_part * 10;;
    
    NSString *timerValueString = [NSString stringWithFormat:@"%ld:%ld%ld%ld", minutes, secondsTens, secondsOnes, secondsTenths];;
    
    NSMutableAttributedString *timeString = [[NSMutableAttributedString alloc] initWithString:timerValueString];
    [timeString setAttributes:@{ NSFontAttributeName : self.font } range:NSMakeRange(0, timeString.length - 1)];
    [timeString setAttributes:@{
        NSFontAttributeName : self.superscriptFont,
        (NSString *)kCTBaselineOffsetAttributeName : @(28 * (56.0 / 82.0)),
        NSKernAttributeName : @(1.0)
    } range:NSMakeRange(timeString.length - 1, 1)];
    if (integer_part > 4) {
        [timeString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(timeString.length - 1, 1)];
    }
    self.attributedString = timeString;
}

@end
