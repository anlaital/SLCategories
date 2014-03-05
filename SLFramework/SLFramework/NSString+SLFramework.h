//
//  NSString+SLFramework.h
//  SLFramework
//
//  Created by Antti Laitala on 04/03/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLHashFunction) {
    SLHashFunctionSHA224,
    SLHashFunctionSHA256,
    SLHashFunctionSHA384,
    SLHashFunctionSHA512
};

@interface NSString (SLFramework)

/** Returns the hexadecimal representation of this string. UTF-8 encoding is expected. */
- (NSString *)hex;

- (NSString *)digest;
- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction;
- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction salt:(NSString *)salt;

@end
