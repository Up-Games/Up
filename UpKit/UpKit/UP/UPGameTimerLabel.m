//
//  UPGameTimerLabel.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <CoreText/CoreText.h>

#import "UPGameTimerLabel.h"
#import "UPMath.h"

static NSString * const _StringDummy = @"X:XXX";
static const NSUInteger _StringLength = 5;

@interface UPGameTimerLabel ()
@property (nonatomic) NSMutableString *formattedTimeString;
@property (nonatomic) NSMutableAttributedString *attributedTimeString;
@property (nonatomic) BOOL autoHidesSecondsInTenths;
@property (nonatomic) BOOL effectiveHidesSecondsInTenths;
@property (nonatomic) NSInteger previousMinutes;
@property (nonatomic) NSInteger previousSecondsTens;
@property (nonatomic) NSInteger previousSecondsOnes;
@property (nonatomic) BOOL previousEffectiveHidesSecondsInTenths;
@end

@implementation UPGameTimerLabel

+ (UPGameTimerLabel *)label
{
    return [[self alloc] init];
}

- (instancetype)init
{
    self = [super init];
    self.formattedTimeString = [NSMutableString string];
    self.attributedTimeString = [[NSMutableAttributedString alloc] initWithString:_StringDummy];
    return self;
}

- (void)_updateLabel:(CFTimeInterval)remainingTime gameTimerIsRunning:(BOOL)gameTimerIsRunning
{
    double integer_part;
    double fractional_part = modf(remainingTime, &integer_part);
    NSInteger t = integer_part;
    NSInteger minutes = t / 60;
    t -= (minutes * 60);
    NSInteger secondsTens = t / 10;
    t -= (secondsTens * 10);
    NSInteger secondsOnes = t;
    NSInteger secondsTenths = fractional_part * 10;
    self.autoHidesSecondsInTenths = (secondsOnes == 0 && secondsTenths == 0) || integer_part > 4;
    self.effectiveHidesSecondsInTenths = self.autoHidesSecondsInTenths;
    
    if (self.formattedTimeString.length != 0 &&
        minutes == self.previousMinutes &&
        secondsTens == self.previousSecondsTens &&
        secondsOnes == self.previousSecondsOnes &&
        self.effectiveHidesSecondsInTenths == self.previousEffectiveHidesSecondsInTenths &&
        self.effectiveHidesSecondsInTenths) {
        return;
    }
    
    self.previousMinutes = minutes;
    self.previousSecondsTens = secondsTens;
    self.previousSecondsOnes = secondsOnes;
    self.previousEffectiveHidesSecondsInTenths = self.effectiveHidesSecondsInTenths;
    
    unichar chars[_StringLength];
    chars[0] = minutes + '0';
    chars[1] = ':';
    chars[2] = secondsTens + '0';
    chars[3] = secondsOnes + '0';
    chars[4] = secondsTenths + '0';
    NSString *string = [[NSString alloc] initWithCharacters:chars length:_StringLength];
    [self.formattedTimeString setString:string];
    [self updateThemeColors];
}

- (void)updateThemeColors
{
    [super updateThemeColors];
    
    if (self.formattedTimeString.length != 0) {
        NSRange range = NSMakeRange(0, _StringLength);
        NSRange kernRange = NSMakeRange(_StringLength - 2, 1);
        NSRange tenthsRange = NSMakeRange(_StringLength - 1, 1);
        UIColor *textColor = [UIColor themeColorWithCategory:self.colorCategory];
        
        [self.attributedTimeString beginEditing];
        [self.attributedTimeString replaceCharactersInRange:range withString:self.formattedTimeString];
        [self.attributedTimeString addAttribute:NSFontAttributeName value:self.font range:range];
        [self.attributedTimeString addAttribute:NSForegroundColorAttributeName value:textColor range:range];
        [self.attributedTimeString addAttribute:NSKernAttributeName value:@(self.superscriptKerning) range:kernRange];
        [self.attributedTimeString addAttribute:(NSString *)kCTBaselineOffsetAttributeName value:@(self.superscriptBaselineAdjustment) range:tenthsRange];
        [self.attributedTimeString addAttribute:NSFontAttributeName value:self.superscriptFont range:tenthsRange];
        if (self.effectiveHidesSecondsInTenths) {
            [self.attributedTimeString addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:tenthsRange];
        }
        [self.attributedTimeString endEditing];
        self.attributedString = self.attributedTimeString;
    }
}

#pragma mark - UPGameTimerObserver

- (void)gameTimerStarted:(UPGameTimer *)gameTimer
{
    [self.formattedTimeString setString:@""];
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

- (void)gameTimerStopped:(UPGameTimer *)gameTimer
{
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

- (void)gameTimerReset:(UPGameTimer *)gameTimer
{
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

- (void)gameTimerUpdated:(UPGameTimer *)gameTimer
{
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

- (void)gameTimerExpired:(UPGameTimer *)gameTimer
{
    [self.formattedTimeString setString:@""];
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

- (void)gameTimerCanceled:(UPGameTimer *)gameTimer
{
    [self.formattedTimeString setString:@""];
    [self _updateLabel:gameTimer.remainingTime gameTimerIsRunning:gameTimer.isRunning];
}

@end
