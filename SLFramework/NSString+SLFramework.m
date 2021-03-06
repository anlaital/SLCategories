// NSString+SLFramework.m
//
// Copyright (c) 2014 Antti Laitala (https://github.com/anlaital)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
        case SLHashFunctionMD2:
            digestLength = CC_MD2_DIGEST_LENGTH;
            hashFunctionPtr = CC_MD2;
            break;
        case SLHashFunctionMD4:
            digestLength = CC_MD4_DIGEST_LENGTH;
            hashFunctionPtr = CC_MD4;
            break;
        case SLHashFunctionMD5:
            digestLength = CC_MD5_DIGEST_LENGTH;
            hashFunctionPtr = CC_MD5;
            break;
        case SLHashFunctionSHA1:
            digestLength = CC_SHA1_DIGEST_LENGTH;
            hashFunctionPtr = CC_SHA1;
            break;
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
    hashFunctionPtr(bytes, (CC_LONG)strlen(bytes), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:digestLength * 2];
    for(int i = 0; i < digestLength; ++i)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}

- (NSString *)snakeCaseString
{
    return [self __casefiedStringUsingDelimiter:'_' uppercase:NO];
}

- (NSString *)screamingSnakeCaseString
{
    return [self __casefiedStringUsingDelimiter:'_' uppercase:YES];
}

- (NSString *)spinalCaseString
{
    return [self __casefiedStringUsingDelimiter:'-' uppercase:NO];
}

- (NSString *)trainCaseString
{
    return [self __casefiedStringUsingDelimiter:'-' uppercase:YES];
}

#pragma mark - Private

- (NSString *)__casefiedStringUsingDelimiter:(unichar)delimiter uppercase:(BOOL)uppercase
{
    NSMutableString *result = self.mutableCopy;
    
    NSUInteger replaceLocation = NSNotFound;
    NSUInteger replaceLength = 0;
    NSUInteger count = 0;
    
    const char *bytes = self.UTF8String;
    size_t size = strlen(bytes);
    for (int i = 0; i < size; ++i) {
        const char byte = bytes[i];
        
        if ((byte >= 'A' && byte <= 'Z')) {
            replaceLocation = MIN(replaceLocation, i + count);
            replaceLength++;
            if (i != size - 1)
                continue;
        }
        
        if (replaceLocation != NSNotFound) {
            NSRange replaceRange = NSMakeRange(replaceLocation, replaceLength);
            NSString *replacement = uppercase ? [result substringWithRange:replaceRange].uppercaseString : [result substringWithRange:replaceRange].lowercaseString;
            [result replaceCharactersInRange:replaceRange withString:replaceLocation > 0 ? [NSString stringWithFormat:@"%c%@", delimiter, replacement] : replacement];
            
            count++;
            replaceLocation = NSNotFound;
            replaceLength = 0;
        }
    }
    
    return result;
}

@end
