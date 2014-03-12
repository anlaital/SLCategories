//
//  NSString+SLFramework.h
//  SLFramework
//
//  Created by Antti Laitala on 04/03/14.
//
//

#import <Foundation/Foundation.h>

/** Hash functions available for the `digest:` methods of `NSString+SLFramework`. */
typedef NS_ENUM(NSInteger, SLHashFunction) {
    SLHashFunctionSHA224,
    SLHashFunctionSHA256,
    SLHashFunctionSHA384,
    SLHashFunctionSHA512
};

@interface NSString (SLFramework)

/** Returns the hexadecimal representation of the string. UTF-8 encoding is assumed. */
- (NSString *)hex;

/** Returns the digest of the string. Hash function is SHA-256 by default. */
- (NSString *)digest;
/** Returns the digest of the string using the `SLHashFunction` specified. */
- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction;
/** Returns the digest of the string after appended `salt` using the `SLHashFunction` specified. */
- (NSString *)digestUsingHashFunction:(SLHashFunction)hashFunction salt:(NSString *)salt;

/** Returns the snake case representation of the string. */
- (NSString *)snakeCaseString;
/** Returns the screaming snake case representation of the string. */
- (NSString *)screamingSnakeCaseString;
/** Returns the spinal case representation of the string. */
- (NSString *)spinalCaseString;
/** Returns the train case representation of the string. */
- (NSString *)trainCaseString;

@end
