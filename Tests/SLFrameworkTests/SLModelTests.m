// SLModelTests.m
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

#import <XCTest/XCTest.h>

#import "SLModel.h"

@interface SLModelWithNativeDataTypes : SLModel

@property (nonatomic) char test_char;
@property (nonatomic) unsigned char test_unsigned_char;
@property (nonatomic) short test_short;
@property (nonatomic, readonly) unsigned short test_unsigned_short;
@property (nonatomic, readonly) int test_int;
@property (nonatomic, readonly) unsigned int test_unsigned_int;
@property (nonatomic, readonly) long test_long;
@property (nonatomic, readonly) unsigned long test_unsigned_long;
@property (nonatomic, readonly) long long test_long_long;
@property (nonatomic, readonly) unsigned long long test_unsigned_long_long;

@property (nonatomic, readonly) float test_float;
@property (nonatomic, readonly) double test_double;

@property (nonatomic, readonly) NSInteger test_NSInteger;
@property (nonatomic, readonly) NSUInteger test_NSUInteger;

@end
@implementation SLModelWithNativeDataTypes @end

@interface SLModelWithRequiredProperty : SLModel

@property (nonatomic, readonly) NSNumber<SLModelRequired> *testNumber;

@end
@implementation SLModelWithRequiredProperty @end

@interface SLModelTests : XCTestCase

@end

@implementation SLModelTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testNatives
{
    NSDictionary *dictionary = @{
        @"test_char": @(80),
        @"test_unsigned_char": @(254),
        @"test_short": @(-50005),
        @"test_unsigned_short": @(39429),
        @"test_int": @(-1500),
        @"test_unsigned_int": @(1610),
        @"test_long": @(-273424878),
        @"test_unsigned_long": @(387428374),
        @"test_long_long": @(-928394829384),
        @"test_unsigned_long_long": @(32842384934323434),
        @"test_float": @(-525525.58),
        @"test_double": @(94859285.29569),
        @"test_NSInteger": @(-3948934),
        @"test_NSUInteger": @(24234234)
    };
    SLModelWithNativeDataTypes *object = [[SLModelWithNativeDataTypes alloc] initWithDictionary:dictionary];
    XCTAssert(object.test_char == [dictionary[@"test_char"] charValue]);
    XCTAssert(object.test_unsigned_char == [dictionary[@"test_unsigned_char"] unsignedCharValue]);
    XCTAssert(object.test_short == [dictionary[@"test_short"] shortValue]);
    XCTAssert(object.test_unsigned_short == [dictionary[@"test_unsigned_short"] unsignedShortValue]);
    XCTAssert(object.test_int == [dictionary[@"test_int"] intValue]);
    XCTAssert(object.test_unsigned_int == [dictionary[@"test_unsigned_int"] unsignedIntValue]);
    XCTAssert(object.test_long == [dictionary[@"test_long"] longValue]);
    XCTAssert(object.test_unsigned_long == [dictionary[@"test_unsigned_long"] unsignedLongValue]);
    XCTAssert(object.test_long_long == [dictionary[@"test_long_long"] longLongValue]);
    XCTAssert(object.test_unsigned_long_long == [dictionary[@"test_unsigned_long_long"] unsignedLongLongValue]);
    XCTAssert(object.test_float == [dictionary[@"test_float"] floatValue]);
    XCTAssert(object.test_double == [dictionary[@"test_double"] doubleValue]);
    XCTAssert(object.test_NSInteger == [dictionary[@"test_NSInteger"] integerValue]);
    XCTAssert(object.test_NSUInteger == [dictionary[@"test_NSUInteger"] unsignedIntegerValue]);
}

- (void)testRequiredProperty
{
    SLModelWithRequiredProperty *obj = [[SLModelWithRequiredProperty alloc] initWithDictionary:@{ @"foo": @"baz" }];
    XCTAssert(!obj);
}

@end
