//
//  SLFunctionsTests.m
//  SLFramework
//
//  Created by Antti Laitala on 13/03/14.
//
//

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
