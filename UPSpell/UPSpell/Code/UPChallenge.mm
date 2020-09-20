//
//  UPChallenge.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <string>
#import <arpa/inet.h>

#import <UPKit/UPAssertions.h>
#import <UPKit/UPGameKey.h>
#import <UPKit/UPMath.h>
#import <UPKit/UPRandom.h>
#import <UPKit/UPStringTools.h>

#import "UPChallenge.h"

static NSString * const UPChallengeURLPrefix = @"https://upgames.dev/t/";

using UP::GameKey;
using UP::cpp_str;

@interface UPChallenge ()
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) BOOL valid;
@end

@implementation UPChallenge

+ (UPChallenge *)challengeWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    return [[self alloc] _initWithGameKey:gameKey score:score];
}

+ (UPChallenge *)challengeWithURL:(NSURL *)URL
{
    return [[self alloc] _initWithURL:URL];
}

- (instancetype)_initWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    self = [super init];
    self.gameKey = gameKey;
    self.score = score;
    self.valid = YES;
    [self _setURLFromComponents];
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

- (void)_setURLFromComponents
{
    NSString *pathString = [self _obfuscatedPath];
    LOG(General, "obfuscate: %@/%d => %@", self.gameKey.string, self.score, pathString);
    LOG(General, "clarify:   %@", [UPChallenge _clarifiedPath:pathString]);
    NSString *URLString = [NSString stringWithFormat:@"%@%@", UPChallengeURLPrefix, pathString];
    self.URL = [NSURL URLWithString:URLString];
}

- (void)_setComponentsFromURL
{
    self.valid = NO;

    NSURLComponents *components = [NSURLComponents componentsWithURL:self.URL resolvingAgainstBaseURL:NO];
    NSArray<NSString *> *pathComponents = [components.path pathComponents];
    if (pathComponents.count != 3 || (![pathComponents[0] isEqualToString:@"/"] || ![pathComponents[1] isEqualToString:@"t"])) {
        return;
    }
    
    NSString *pathString = pathComponents[2];
    NSString *clarifiedString = [UPChallenge _clarifiedPath:pathString];
    LOG(General, "clarify: %@ => %@", pathString, clarifiedString);
    if (!clarifiedString) {
        return;
    }
    
    NSArray *clarifiedComponents = [clarifiedString componentsSeparatedByString:@"/"];
    if (clarifiedComponents.count != 2) {
        return;
    }
    NSString *gameKeyString = clarifiedComponents[0];
    NSString *scoreString = clarifiedComponents[1];

    if (![UPGameKey isWellFormedGameKeyString:gameKeyString]) {
        return;
    }

    self.gameKey = [UPGameKey gameKeyWithString:gameKeyString];
    self.score = (int)UPClampT(NSInteger, [scoreString integerValue], 0, UP::GameKey::Permutations);
    self.valid = YES;
}

- (NSString *)description
{
    NSMutableString *result = [NSMutableString string];
    [result appendString:@"<UPChallenge: "];
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

static constexpr size_t UPChallengeSaltLength = 1;
static constexpr size_t UPChalengeVersionLength = 1;
static constexpr size_t UPChalengeDataLength = UPChallengeSaltLength + UPChalengeVersionLength + sizeof(uint32_t) + sizeof(uint16_t);

- (NSString *)_obfuscatedPath
{
    if (!self.valid) {
        return @"";
    }

    NSMutableData *input = [NSMutableData data];

    uint8_t slash[1];
    slash[0] = '/';

    UP::Random &r = UP::Random::instance();
    uint8_t saltByte = r.byte();
    uint8_t salt[UPChallengeSaltLength];
    salt[0] = saltByte;
    [input appendBytes:salt length:UPChallengeSaltLength];

    uint8_t versionByte = 1;
    uint8_t version[1];
    version[0] = versionByte;
    [input appendBytes:version length:1];

    uint32_t gameKeyValue = htonl(self.gameKey.value);
    [input appendBytes:&gameKeyValue length:sizeof(uint32_t)];

    uint16_t gameScore = htons(self.score);
    [input appendBytes:&gameScore length:sizeof(uint16_t)];

    uint8_t inputBytes[UPChalengeDataLength];
    [input getBytes:inputBytes range:NSMakeRange(0, UPChalengeDataLength)];
    
    uint8_t output[UPChalengeDataLength];
    output[0] = saltByte;
    output[1] = versionByte;
    for (size_t i = 2; i < UPChalengeDataLength; i++) {
        output[i] = inputBytes[i] ^ saltByte;
    }

    NSData *outputData = [NSData dataWithBytesNoCopy:output length:UPChalengeDataLength freeWhenDone:NO];
    NSString *base64String = [outputData base64EncodedStringWithOptions:0];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"_"];
    NSString *result = [base64String substringToIndex:11];
    
    return result;
}

+ (NSString *)_clarifiedPath:(NSString *)obfuscatedPath
{
    if (obfuscatedPath.length != 11) {
        return nil;
    }

    NSMutableString *base64String = [NSMutableString stringWithString:obfuscatedPath];
    [base64String replaceOccurrencesOfString:@"-" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    [base64String replaceOccurrencesOfString:@"_" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    [base64String appendString:@"="];
    NSData *input = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    if (!input) {
        return nil;
    }
    uint8_t inputBytes[UPChalengeDataLength];
    [input getBytes:inputBytes range:NSMakeRange(0, UPChalengeDataLength)];

    uint8_t output[UPChalengeDataLength];
    uint8_t saltByte = inputBytes[0];
    uint8_t versionByte = inputBytes[1];

    output[0] = saltByte;
    output[1] = versionByte;
    NSString *result = nil;
    if (versionByte == 1) {
        for (size_t i = 2; i < UPChalengeDataLength; i++) {
            output[i] = inputBytes[i] ^ saltByte;
        }
        uint32_t gameKeyValue = ntohl(*(reinterpret_cast<uint32_t *>(output + UPChallengeSaltLength + UPChalengeVersionLength)));
        UPGameKey *gameKey = [UPGameKey gameKeyWithValue:gameKeyValue];
        uint16_t gameScore = ntohs(*(reinterpret_cast<uint16_t *>(output + UPChallengeSaltLength + UPChalengeVersionLength + sizeof(uint32_t))));
        int effectiveGameScore = gameScore == 65535 ? -1 : gameScore;
        result = [NSString stringWithFormat:@"%@/%d", gameKey.string, effectiveGameScore];
    }

    return result;
}



@end
