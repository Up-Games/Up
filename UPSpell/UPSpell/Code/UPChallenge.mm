//
//  UPChallenge.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UPKit/UPGameKey.h>
#import <UPKit/UPStringTools.h>

#import "UPChallenge.h"

using UP::GameKey;
using UP::cpp_str;

@interface UPChallenge ()
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) BOOL valid;
@end

@implementation UPChallenge

+ (UPChallenge *)challengeWithURL:(NSURL *)URL
{
    return [[self alloc] _initWithURL:URL];
}

- (instancetype)_initWithURL:(NSURL *)URL
{
    self = [super init];
    self.URL = URL;
    self.valid = NO;
    [self _setComponentsFromURL];
    if (self.gameKey) {
        self.valid = YES;
    }
    return self;
}

- (void)_setComponentsFromURL
{
    self.valid = NO;

    int validVotes = 0;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.URL resolvingAgainstBaseURL:NO];
    NSArray<NSString *> *pathComponents = [components.path pathComponents];
    if (pathComponents.count != 3 ||
        (![pathComponents[0] isEqualToString:@"/"] ||
         ![pathComponents[1] isEqualToString:@"t"] ||
         ![pathComponents[2] isEqualToString:@"/"])) {
        return;
    }
    
    BOOL gotG = NO;
    BOOL gotK = NO;
    BOOL gotS = NO;
    for (NSURLQueryItem *q in components.queryItems) {
        if ([q.name isEqualToString:@"g"]) {
            if (gotG) {
                break;
            }
            gotG = YES;
            if ([q.value isEqualToString:@"upspell"]) {
                validVotes++;
            }
        }
        else if ([q.name isEqualToString:@"k"]) {
            if (gotK) {
                break;
            }
            gotK = YES;
            NSString *gameKeyString = q.value;
            if (!GameKey::is_well_formed(cpp_str(gameKeyString))) {
                self.gameKey = [UPGameKey gameKeyWithValue:0];
                break;
            }
            else {
                self.gameKey = [UPGameKey gameKeyWithString:gameKeyString];
                validVotes++;
            }
        }
        else if ([q.name isEqualToString:@"s"]) {
            if (gotS) {
                break;
            }
            gotS = YES;
            NSString *scoreInput = q.value;
            if (scoreInput.length == 0) {
                break;
            }
            else {
                NSScanner *scanner = [NSScanner scannerWithString:scoreInput];
                NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
                NSString *scoreString = nil;
                [scanner scanCharactersFromSet:skips intoString:&scoreString];
                if (scoreInput.length == scoreString.length) {
                    self.score = [scoreString intValue];
                    validVotes++;
                }
                else {
                    break;
                }
            }
        }
    }

    if (validVotes == 3) {
        self.valid = YES;
    }
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"<UPShare: "];
    [result appendString:[NSString stringWithFormat:@"%p: ", self]];
    if (!self.valid) {
        [result appendString:@"invalid>"];
    }
    else {
        [result appendString:self.gameKey.string];
        [result appendString:@" : "];
        [result appendString:[NSString stringWithFormat:@"%d", self.score]];
        [result appendString:@">"];
    }
    return result;
}

@end
