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

#pragma mark - SLModelWithNativeDataTypes

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

@interface SLModelWithNonNativeDataTypes : SLModel

@property (nonatomic, readonly) NSNumber *number;
@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSMutableString *mutableString;
@property (nonatomic, readonly) NSArray *array;
@property (nonatomic, readonly) NSMutableArray *mutableArray;
@property (nonatomic, readonly) NSDictionary *dictionary;
@property (nonatomic, readonly) NSMutableDictionary *mutableDictionary;

@end
@implementation SLModelWithNonNativeDataTypes @end

@interface SLModelWithRequiredProperty : SLModel

@property (nonatomic, readonly) NSNumber<SLModelRequired> *testNumber;

@end
@implementation SLModelWithRequiredProperty @end

@interface SLModelTests : XCTestCase

@end

@interface SLModelWithInheritanceA : SLModel

@property (nonatomic, readonly) NSString<SLModelRequired> *baseString;

@end
@implementation SLModelWithInheritanceA @end

@protocol SLModelWithInheritanceB @end
@interface SLModelWithInheritanceB : SLModelWithInheritanceA

@property (nonatomic, readonly) NSString *string;

@end
@implementation SLModelWithInheritanceB @end

@interface SLModelWithAnotherModelInside : SLModel

@property (nonatomic, readonly) SLModelWithInheritanceB *inherited;
@property (nonatomic, readonly) NSArray<SLModelWithInheritanceB> *array;

@end
@implementation SLModelWithAnotherModelInside @end

@interface SLModelWithIgnoredProperty : SLModel

@property (nonatomic, readonly) NSNumber<SLModelIgnored> *ignored;

@end
@implementation SLModelWithIgnoredProperty @end

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

- (void)testNonNatives
{
    NSDictionary *dictionary = @{
        @"number": @(100),
        @"string": @"foo",
        @"mutableString": @"bar",
        @"array": @[@"foo", @"bar"],
        @"mutableArray": @[@"foo", @"bar"],
        @"dictionary": @{ @"foo": @"bar" },
        @"mutableDictionary": @{ @"foo": @"bar" }
    };
    SLModelWithNonNativeDataTypes *object = [[SLModelWithNonNativeDataTypes alloc] initWithDictionary:dictionary];
    XCTAssert([object.number isKindOfClass:[NSNumber class]]);
    XCTAssert([object.number isEqualToNumber:dictionary[@"number"]]);
    XCTAssert([object.string isKindOfClass:[NSString class]]);
    XCTAssert([object.string isEqualToString:dictionary[@"string"]]);
    XCTAssert([object.mutableString isKindOfClass:[NSMutableString class]]);
    XCTAssert([object.mutableString isEqualToString:dictionary[@"mutableString"]]);
    [object.mutableString appendString:@"baz"];
    XCTAssert([object.array isKindOfClass:[NSArray class]]);
    XCTAssert([object.array isEqualToArray:dictionary[@"array"]]);
    XCTAssert([object.mutableArray isKindOfClass:[NSMutableArray class]]);
    XCTAssert([object.mutableArray isEqualToArray:dictionary[@"mutableArray"]]);
    [object.mutableArray addObject:@"baz"];
    XCTAssert([object.dictionary isKindOfClass:[NSDictionary class]]);
    XCTAssert([object.dictionary isEqualToDictionary:dictionary[@"dictionary"]]);
    XCTAssert([object.mutableDictionary isKindOfClass:[NSMutableDictionary class]]);
    XCTAssert([object.mutableDictionary isEqualToDictionary:dictionary[@"mutableDictionary"]]);
    object.mutableDictionary[@"mutable"] = @"baz";
}

- (void)testRequiredProperty
{
    SLModelWithRequiredProperty *missingRequired = [[SLModelWithRequiredProperty alloc] initWithDictionary:@{ @"foo": @"baz" }];
    XCTAssert(!missingRequired);
    
    NSDictionary *dict = @{ @"string": @"bar" };
    SLModelWithInheritanceB *missingRequiredInSuperClass = [[SLModelWithInheritanceB alloc] initWithDictionary:dict];
    XCTAssert(!missingRequiredInSuperClass);

    SLModelWithRequiredProperty *requiredIsNull = [[SLModelWithRequiredProperty alloc] initWithDictionary:@{ @"testNumber": [NSNull null] }];
    XCTAssert(!requiredIsNull);
}

- (void)testInheritance
{
    NSDictionary *dict = @{ @"baseString": @"foo", @"string": @"bar" };
    SLModelWithInheritanceB *object = [[SLModelWithInheritanceB alloc] initWithDictionary:dict];
    XCTAssert([object.baseString isEqualToString:dict[@"baseString"]]);
    XCTAssert([object.string isEqualToString:dict[@"string"]]);
}

- (void)testIgnoredProperty
{
    NSDictionary *dictionary = @{ @"ignored": @(50) };
    SLModelWithIgnoredProperty *object = [[SLModelWithIgnoredProperty alloc] initWithDictionary:dictionary];
    XCTAssert(!object.ignored);
}

- (void)testAnotherModelInside
{
    NSDictionary *dictionary = @{
        @"inherited": @{ @"baseString": @"foo" },
        @"array": @[ @{ @"baseString": @"bar" }, @{ @"baseString": @"baz" } ]
    };
    SLModelWithAnotherModelInside *object = [[SLModelWithAnotherModelInside alloc] initWithDictionary:dictionary];
    XCTAssert([object.inherited.baseString isEqualToString:@"foo"]);
    XCTAssert(object.array.count == 2);
    SLModelWithInheritanceB *first = object.array[0];
    SLModelWithInheritanceB *second = object.array[1];
    XCTAssert([first.baseString isEqualToString:@"bar"]);
    XCTAssert([second.baseString isEqualToString:@"baz"]);
}

@end
