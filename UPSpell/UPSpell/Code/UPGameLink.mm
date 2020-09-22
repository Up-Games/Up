//
//  UPGameLink.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <string>
#import <arpa/inet.h>

#import <UPKit/UPAssertions.h>
#import <UPKit/UPGameKey.h>
#import <UPKit/UPMath.h>
#import <UPKit/UPRandom.h>
#import <UPKit/UPStringTools.h>

#import "UPGameLink.h"

static NSString * const UPGameLinkURLPrefix = @"https://upgames.dev/t/";

using UP::GameKey;
using UP::cpp_str;

@interface UPGameLink ()
@property (nonatomic, readwrite) UPGameLinkType type;
@property (nonatomic, readwrite) UPGameKey *gameKey;
@property (nonatomic, readwrite) int score;
@property (nonatomic, readwrite) NSURL *URL;
@property (nonatomic, readwrite) BOOL valid;
@end

@implementation UPGameLink

+ (UPGameLink *)challengeGameLinkWithGameKey:(UPGameKey *)gameKey score:(int)score
{
    return [[self alloc] _initWithType:UPGameLinkTypeChallenge gameKey:gameKey score:score];
}

+ (UPGameLink *)duelGameLinkWithGameKey:(UPGameKey *)gameKey
{
    return [[self alloc] _initWithType:UPGameLinkTypeDuel gameKey:gameKey score:0];
}

+ (UPGameLink *)gameLinkWithURL:(NSURL *)URL
{
    return [[self alloc] _initWithURL:URL];
}

- (instancetype)_initWithType:(UPGameLinkType)type gameKey:(UPGameKey *)gameKey score:(int)score
{
    self = [super init];
    self.type = type;
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
    LOG(General, "clarify:   %@", [UPGameLink _clarifiedPath:pathString]);
    NSString *URLString = [NSString stringWithFormat:@"%@%@", UPGameLinkURLPrefix, pathString];
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
    NSString *clarifiedString = [UPGameLink _clarifiedPath:pathString];
    LOG(General, "clarify: %@ => %@", pathString, clarifiedString);
    if (!clarifiedString) {
        return;
    }
    
    NSArray *clarifiedComponents = [clarifiedString componentsSeparatedByString:@"/"];
    NSString *gameKeyString = nil;
    NSString *scoreString = nil;
    NSString *typeString = nil;
    if (clarifiedComponents.count == 2) {
        gameKeyString = clarifiedComponents[0];
        scoreString = clarifiedComponents[1];
        typeString = @"c";
    }
    else if (clarifiedComponents.count == 3) {
        gameKeyString = clarifiedComponents[0];
        scoreString = clarifiedComponents[1];
        typeString = clarifiedComponents[2];
    }

    if ([typeString isEqualToString:@"c"]) {
        self.type = UPGameLinkTypeChallenge;
    }
    else if ([typeString isEqualToString:@"d"]) {
        self.type = UPGameLinkTypeDuel;
    }
    else {
        return;
    }
    
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
    [result appendString:@"<UPGameLink: "];
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

static constexpr size_t UPGameLinkSaltLength = 1;
static constexpr size_t UPGameLinkVersionLength = 1;
static constexpr size_t UPGameLinkTypeLength = 1;
static constexpr size_t UPGameLinkDataLength =
    UPGameLinkSaltLength + UPGameLinkVersionLength + sizeof(uint32_t) + sizeof(uint16_t) + UPGameLinkTypeLength;

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
    uint8_t salt[UPGameLinkSaltLength];
    salt[0] = saltByte;
    [input appendBytes:salt length:UPGameLinkSaltLength];

    uint8_t versionByte = 2;
    uint8_t version[1];
    version[0] = versionByte;
    [input appendBytes:version length:1];

    uint32_t gameKeyValue = htonl(self.gameKey.value);
    [input appendBytes:&gameKeyValue length:sizeof(uint32_t)];

    uint16_t gameScore = htons(self.score);
    [input appendBytes:&gameScore length:sizeof(uint16_t)];

    uint8_t typeByte[1];
    typeByte[0] = self.type;
    [input appendBytes:typeByte length:1];

    uint8_t inputBytes[UPGameLinkDataLength];
    [input getBytes:inputBytes range:NSMakeRange(0, UPGameLinkDataLength)];
    
    uint8_t output[UPGameLinkDataLength];
    output[0] = saltByte;
    output[1] = versionByte;
    for (size_t i = 2; i < UPGameLinkDataLength; i++) {
        output[i] = inputBytes[i] ^ saltByte;
    }
    
    NSData *outputData = [NSData dataWithBytesNoCopy:output length:UPGameLinkDataLength freeWhenDone:NO];
    NSString *base64String = [outputData base64EncodedStringWithOptions:0];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"_"];
    NSString *result = base64String;
    
    return result;
}

+ (NSString *)_clarifiedPath:(NSString *)obfuscatedPath
{
    if (obfuscatedPath.length != 11 && obfuscatedPath.length != 12) {
        return nil;
    }

    NSMutableString *base64String = [NSMutableString stringWithString:obfuscatedPath];
    [base64String replaceOccurrencesOfString:@"-" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    [base64String replaceOccurrencesOfString:@"_" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    if (obfuscatedPath.length == 11) {
        [base64String appendString:@"="];
    }
    NSData *input = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    if (!input) {
        return nil;
    }
    uint8_t inputBytes[UPGameLinkDataLength];
    [input getBytes:inputBytes range:NSMakeRange(0, input.length)];

    uint8_t output[UPGameLinkDataLength];
    uint8_t saltByte = inputBytes[0];
    uint8_t versionByte = inputBytes[1];

    output[0] = saltByte;
    output[1] = versionByte;
    NSString *result = nil;
    
    UPGameKey *gameKey = nil;
    uint16_t gameScore = 0;

    if (versionByte == 1 || versionByte == 2) {
        for (size_t i = 2; i < UPGameLinkDataLength; i++) {
            output[i] = inputBytes[i] ^ saltByte;
        }
        uint32_t gameKeyValue = ntohl(*(reinterpret_cast<uint32_t *>(output + UPGameLinkSaltLength + UPGameLinkVersionLength)));
        gameKey = [UPGameKey gameKeyWithValue:gameKeyValue];
        gameScore = ntohs(*(reinterpret_cast<uint16_t *>(output + UPGameLinkSaltLength + UPGameLinkVersionLength + sizeof(uint32_t))));
    }
    if (versionByte == 1) {
        result = [NSString stringWithFormat:@"%@/%d/c", gameKey.string, gameScore];
    }
    else if (versionByte == 2) {
        uint8_t typeByte = output[UPGameLinkDataLength - 1];
        if (typeByte == 0) {
            result = [NSString stringWithFormat:@"%@/%d/c", gameKey.string, gameScore];
        }
        else if (typeByte == 1) {
            result = [NSString stringWithFormat:@"%@/0/d", gameKey.string];
        }
    }

    return result;
}



@end
