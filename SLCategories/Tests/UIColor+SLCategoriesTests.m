//
//  UIColor+SLCategoriesTests.m
//  SLCategories
//
//  Created by Antti Laitala on 03/03/14.
//
//

#import <XCTest/XCTest.h>

#import "UIColor+SLCategories.h"

@interface UIColor_SLCategoriesTests : XCTestCase

@end

@implementation UIColor_SLCategoriesTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testHex
{
    UIColor *color;
    const CGFloat *components;
    
    color = [UIColor colorFromHex:@"#ffffff"];
    components = CGColorGetComponents(color.CGColor);
    XCTAssert(components[0] == 1.0 && components[1] == 1.0 && components[2] == 1.0 && components[3] == 1.0);
}

@end
