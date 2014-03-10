//
//  SLLoggerTests.m
//  SLFramework
//
//  Created by Antti Laitala on 10/03/14.
//
//

#import <XCTest/XCTest.h>

#import "SLLogger.h"

@interface SLLoggerTests : XCTestCase

@end

@implementation SLLoggerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSLLogger
{
    SLLog(@"");
    SLLog(@"Regular string without params");
    SLLog(@"1 + 1 = %d - %@", 2, self.class);
}

@end
