// NSString+SLFramework.h
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

#import <Foundation/Foundation.h>

/** Hash functions available for the `digest:` methods of `NSString+SLFramework`. */
typedef NS_ENUM(NSInteger, SLHashFunction) {
    SLHashFunctionMD2,
    SLHashFunctionMD4,
    SLHashFunctionMD5,
    SLHashFunctionSHA1,
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
