//
//  UPSharedGameRequest.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UPKit/UPGameKey.h>
#import <UPKit/UPStringTools.h>

#import "UPSharedGameRequest.h"

using UP::GameKey;
using UP::cpp_str;

@interface UPSharedGameRequest ()
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) BOOL valid;
@end

@implementation UPSharedGameRequest

+ (UPSharedGameRequest *)sharedGameRequestWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    return [[self alloc] _initWithGameKey:gameKey score:score];
}

+ (UPSharedGameRequest *)sharedGameRequestWithURL:(NSURL *)URL
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
    NSString *string = [NSString stringWithFormat:@"upspell:///%@?s=%d", self.gameKey.string, self.score];
    self.URL = [NSURL URLWithString:string];
}

- (void)_setComponentsFromURL
{
    self.valid = NO;

    int validVotes = 0;
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:self.URL resolvingAgainstBaseURL:NO];
    NSArray<NSString *> *pathComponents = [components.path pathComponents];
    if (pathComponents.count != 2 || ![pathComponents.firstObject isEqualToString:@"/"]) {
        return;
    }
    NSString *gameKeyString = [pathComponents lastObject];
    if (!GameKey::is_well_formed(cpp_str(gameKeyString))) {
        self.gameKey = [UPGameKey gameKeyWithValue:0];
    }
    else {
        self.gameKey = [UPGameKey gameKeyWithString:gameKeyString];
        validVotes++;
    }
    for (NSURLQueryItem *queryItem in components.queryItems) {
        if ([queryItem.name isEqualToString:@"s"]) {
            NSString *input = queryItem.value;
            if (input.length > 0) {
                NSScanner *scanner = [NSScanner scannerWithString:input];
                NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
                NSString *scoreString = nil;
                [scanner scanCharactersFromSet:skips intoString:&scoreString];
                if (input.length == scoreString.length) {
                    self.score = [scoreString intValue];
                    validVotes++;
                }
            }
        }
    }
    if (validVotes == 2) {
        self.valid = YES;
    }
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"<UPSharedGameRequest: "];
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
