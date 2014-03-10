//
//  SLFramework+NSObject.m
//  SLFramework
//
//  Created by Antti Laitala on 10/03/14.
//
//

#import <XCTest/XCTest.h>

#import "NSObject+SLFramework.h"

@interface T0 : NSObject

@end

@implementation T0

@end

@interface T1 : NSObject

@property (nonatomic, readonly) NSNumber *nonatomicReadonly;
@property (atomic, weak) NSString *weakAtomicString;
@property (nonatomic, readwrite) T0 *nonatomicReadWriteCustom;

@end

@implementation T1

@end

@interface SLFramework_NSObject : XCTestCase

@end

@implementation SLFramework_NSObject

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
    NSArray *properties = [T1 classProperties];
    XCTAssert(properties.count == 3);
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
        } else {
            XCTAssert(NO, @"Property with name [%@] was not expected", property.name);
        }
    }
}

@end
