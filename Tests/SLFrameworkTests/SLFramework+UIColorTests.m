// SLFramework+UIColorTests.m
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
