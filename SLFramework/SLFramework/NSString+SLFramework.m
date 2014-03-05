//
//  NSString+SLFramework.m
//  SLFramework
//
//  Created by Antti Laitala on 04/03/14.
//
//

#import <CommonCrypto/CommonCrypto.h>

#import "NSString+SLFramework.h"

@implementation NSString (SLFramework)

- (NSString *)hex
{
    const char *bytes = self.UTF8String;
    size_t s = strlen(bytes);
    
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:s * 2];
    for (size_t i = 0; i < s; i++)
        [result appendFormat:@"%02x", bytes[i] & 0xFF];
    return result;
}

- (NSString *)digest
{
    return [self digestUsingHashFunction:SLHashFunctionSHA256 salt:nil];
}

- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction
{
    return [self digestUsingHashFunction:hashFunction salt:nil];
}

- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction salt:(NSString *)salt
{
    NSString *message = salt.length ? [self stringByAppendingString:salt] : self;
    
    size_t digestLength = 0;
    unsigned char *(*hashFunctionPtr)(const void *data, CC_LONG len, unsigned char *md);
    switch (hashFunction) {
        case SLHashFunctionSHA224:
            digestLength = CC_SHA224_DIGEST_LENGTH;
            hashFunctionPtr = CC_SHA224;
            break;
        case SLHashFunctionSHA256:
            digestLength = CC_SHA256_DIGEST_LENGTH;
            hashFunctionPtr = CC_SHA256;
            break;
        case SLHashFunctionSHA384:
            digestLength = CC_SHA384_DIGEST_LENGTH;
            hashFunctionPtr = CC_SHA384;
            break;
        case SLHashFunctionSHA512:
            digestLength = CC_SHA512_DIGEST_LENGTH;
            hashFunctionPtr = CC_SHA512;
            break;
        default:
            return nil;
    }
    
    unsigned char digest[digestLength];
    const char *bytes = message.UTF8String;
    hashFunctionPtr(bytes, strlen(bytes), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:digestLength * 2];
    for(int i = 0; i < digestLength; ++i)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

@end
