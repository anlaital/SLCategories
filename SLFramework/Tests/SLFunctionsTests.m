// SLFunctionsTests.m
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

#import "SLFunctions.h"

@protocol T0Proto <NSObject>

@end

@interface T0 : NSObject

@end

@implementation T0

@end

@interface T1 : NSObject

@property (nonatomic, readonly) NSNumber *nonatomicReadonly;
@property (atomic, weak) NSString *weakAtomicString;
@property (nonatomic, readwrite) T0 *nonatomicReadWriteCustom;
@property (nonatomic, setter = customSetter:, getter = customGetter) int testCustomSetterAndGetter;
@property (nonatomic) id<T0Proto, NSCopying, NSCoding> testProtocol;

@end

@implementation T1

@end

@interface SLFramework_NSObject : XCTestCase

@end

@interface SLFunctionsTests : XCTestCase

@end

@implementation SLFunctionsTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testClassProperties
{
    NSArray *properties = [SLFunctions propertiesForClass:[T1 class]];
    XCTAssert(properties.count == 5);
    for (SLObjectProperty *property in properties) {
        if ([property.name isEqualToString:@"nonatomicReadonly"]) {
            XCTAssert(!property.atomic);
            XCTAssert(property.readonly);
        } else if ([property.name isEqualToString:@"weakAtomicString"]) {
            XCTAssert(property.weak);
            XCTAssert(!property.readonly);
            XCTAssert(property.atomic);
        } else if ([property.name isEqualToString:@"nonatomicReadWriteCustom"]) {
            XCTAssert(!property.atomic);
            XCTAssert(!property.readonly);
        } else if ([property.name isEqualToString:@"testCustomSetterAndGetter"]) {
            XCTAssert(property.customSetter == NSSelectorFromString(@"customSetter:"));
            XCTAssert(property.customGetter == NSSelectorFromString(@"customGetter"));
        } else if ([property.name isEqualToString:@"testProtocol"]) {
            XCTAssert(property.protocolNames.count == 3);
            XCTAssert([property.protocolNames containsObject:@"T0Proto"]);
            XCTAssert([property.protocolNames containsObject:@"NSCopying"]);
            XCTAssert([property.protocolNames containsObject:@"NSCoding"]);
        }
        else {
            XCTAssert(NO, @"Property with name [%@] was not expected", property.name);
        }
    }
}

@end
