//
//  UIColor+SLFrameworkTests.m
//  SLCategories
//
//  Created by Antti Laitala on 03/03/14.
//
//

#import <XCTest/XCTest.h>

#import "UIColor+SLFramework.h"

@interface UIColor_SLFrameworkTests : XCTestCase

@end

@implementation UIColor_SLFrameworkTests

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
    const CGFloat *c;
    
    color = [UIColor colorFromHex:@"#ff05ff"];
    c = CGColorGetComponents(color.CGColor);
    XCTAssert(c[0] == 1 && c[1] * 255 == 5 && c[2] == 1 && c[3] == 1);
    
    color = [UIColor colorFromHex:@"FfaAb"];
    c = CGColorGetComponents(color.CGColor);
    XCTAssert(c[0] * 255 == 15 && c[1] * 255 == 250 && c[2] * 255 == 171 && c[3] == 1);
    
    color = [UIColor colorFromHex:@"#FF050008" format:SLColorFormatRGBA8];
    c = CGColorGetComponents(color.CGColor);
    XCTAssert(c[0] == 1 && c[1] * 255 == 5 && c[2] == 0 && c[3] * 255 == 8);
    
    NSString *hex = nil;
    
    hex = [[UIColor whiteColor] hexStringWithFormat:SLColorFormatRGBA8 prependHash:YES];
    XCTAssert([hex isEqualToString:@"#ffffffff"]);
    
    hex = [[[UIColor blueColor] colorWithAlphaComponent:50.0/255] hexStringWithFormat:SLColorFormatRGBA8 prependHash:NO];
    XCTAssert([hex isEqualToString:@"0000ff32"]);
    
    hex = [[UIColor colorWithRed:32.0/255 green:242.0/255 blue:2.0/255 alpha:12.0/255] hexStringWithFormat:SLColorFormatRGB8 prependHash:YES];
    XCTAssert([hex isEqualToString:@"#20f202"]);
}

@end
