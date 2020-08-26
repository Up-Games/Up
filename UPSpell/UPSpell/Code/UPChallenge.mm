//
//  UPChallenge.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <CommonCrypto/CommonCryptor.h>

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
    NSString *pathString = [self _encryptedPath];
    LOG(General, "encrypt: %@/%d => %@", self.gameKey.string, self.score, pathString);
    LOG(General, "decrypt: %@", [UPChallenge _decryptPath:pathString]);
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
    NSString *decryptedString = [UPChallenge _decryptPath:pathString];
    LOG(General, "decrypt: %@ => %@", pathString, decryptedString);
    if (!decryptedString) {
        return;
    }
    
    NSArray *decryptedComponents = [decryptedString componentsSeparatedByString:@"/"];
    if (decryptedComponents.count != 2) {
        return;
    }
    NSString *gameKeyString = decryptedComponents[0];
    NSString *scoreString = decryptedComponents[1];

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

static const uint8_t UPPepper[] = {
    0x5B, 0x54, 0x5D, 0x68, 0x61, 0x74, 0x20, 0x77, 0x65, 0x20, 0x68, 0x65, 0x72, 0x65, 0x20, 0x68,
    0x69, 0x67, 0x68, 0x6C, 0x79, 0x20, 0x72, 0x65, 0x73, 0x6F, 0x6C, 0x76, 0x65, 0x20, 0x74, 0x68
};

static constexpr size_t UPSaltLength = 2;

- (NSString *)_encryptedPath
{
    if (!self.valid) {
        return @"";
    }

    NSMutableData *input = [NSMutableData data];

    uint8_t slash[1];
    slash[0] = '/';

    UP::Random &r = UP::Random::instance();
    uint8_t salt[UPSaltLength];
    salt[0] = r.byte();
    salt[1] = r.byte();
    [input appendBytes:salt length:UPSaltLength];

    uint8_t version[1];
    version[0] = 0;
    [input appendBytes:version length:1];

    uint32_t gameKeyValue = htonl(self.gameKey.value);
    [input appendBytes:&gameKeyValue length:sizeof(uint32_t)];

    uint16_t gameScore = htons(self.score);
    [input appendBytes:&gameScore length:sizeof(uint16_t)];

    size_t actualOutputLength;
    size_t outputLength = ((input.length / kCCBlockSizeAES128) + 1) * kCCBlockSizeAES128;
    uint8_t output[outputLength];
    NSString *result = nil;
    
    uint8_t iv[kCCBlockSizeAES128];
    memset(iv, 0, sizeof(iv));
    
    CCCryptorStatus status = CCCrypt(kCCEncrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                     static_cast<const void *>(UPPepper), kCCKeySizeAES256, static_cast<const void *>(iv),
                                     static_cast<const void *>(input.bytes), input.length,
                                     output, outputLength, &actualOutputLength);
    if (status == kCCSuccess) {
        NSData *outputData = [NSData dataWithBytesNoCopy:output length:actualOutputLength freeWhenDone:NO];
        NSString *base64String = [outputData base64EncodedStringWithOptions:0];
        base64String = [base64String stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
        base64String = [base64String stringByReplacingOccurrencesOfString:@"+" withString:@"_"];
        result = [base64String substringToIndex:22];
    }
    
    return result;
}

+ (NSString *)_decryptPath:(NSString *)encryptedPath
{
    if (encryptedPath.length != 22) {
        return nil;
    }

    NSMutableString *base64String = [NSMutableString stringWithString:encryptedPath];
    [base64String replaceOccurrencesOfString:@"-" withString:@"/" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    [base64String replaceOccurrencesOfString:@"_" withString:@"+" options:NSLiteralSearch range:NSMakeRange(0, base64String.length)];
    [base64String appendString:@"=="];
    NSData *input = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
    size_t actualOutputLength;
    size_t outputLength = 4 * ceil(((double)input.length / 3));
    uint8_t output[outputLength];
    NSString *result = nil;
    
    uint8_t iv[kCCBlockSizeAES128];
    memset(iv, 0, sizeof(iv));
    
    CCCryptorStatus status = CCCrypt(kCCDecrypt, kCCAlgorithmAES, kCCOptionPKCS7Padding,
                                     static_cast<const void *>(UPPepper), kCCKeySizeAES256, static_cast<const void *>(iv),
                                     static_cast<const void *>(input.bytes), input.length,
                                     output, outputLength, &actualOutputLength);
    if (status == kCCSuccess) {
        uint8_t version = output[UPSaltLength];
        if (version == 0) {
            uint32_t gameKeyValue = ntohl(*(reinterpret_cast<uint32_t *>(output + UPSaltLength + 1)));
            UPGameKey *gameKey = [UPGameKey gameKeyWithValue:gameKeyValue];
            uint16_t gameScore = ntohs(*(reinterpret_cast<uint16_t *>(output + UPSaltLength + 1 + sizeof(uint32_t))));
            result = [NSString stringWithFormat:@"%@/%d", gameKey.string, gameScore];
        }
    }
    
    return result;
}



@end
