//
//  UPTaunt.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UPKit/UPGameKey.h>
#import <UPKit/UPStringTools.h>

#import "UPTaunt.h"

using UP::GameKey;
using UP::cpp_str;

@interface UPTaunt ()
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) BOOL valid;
@end

@implementation UPTaunt

+ (UPTaunt *)tauntWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    return [[self alloc] _initWithGameKey:gameKey score:score];
}

+ (UPTaunt *)tauntWithURL:(NSURL *)URL
{
    return [[self alloc] _initWithURL:URL];
}

- (instancetype)_initWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    self = [super init];
    self.gameKey = gameKey;
    self.score = score;
    self.valid = NO;
    if (self.gameKey) {
        [self _setURL];
        self.valid = YES;
    }
    else {
        self.gameKey = [UPGameKey gameKeyWithValue:0];
    }
    return self;
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

- (void)_setURL
{
    NSString *string = [NSString stringWithFormat:@"https://upgames.dev/t/?g=upspell&k=%@s=%d", self.gameKey.string, self.score];
    self.URL = [NSURL URLWithString:string];
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
    [result appendString:@"<UPTaunt: "];
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
