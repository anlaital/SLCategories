//
//  SLError.m
//  SLFramework
//
//  Created by Antti Laitala on 14/03/14.
//
//

#import "SLError.h"

NSString *const SLErrorDomain = @"SLFrameworkErrorDomain";
NSString *const SLErrorReason = @"SLErrorReason";
NSString *const SLErrorObject = @"SLErrorObject";

@implementation SLError

+ (instancetype)errorWithUserInfo:(NSDictionary *)userInfo
{
    return [NSError errorWithDomain:SLErrorDomain code:0 userInfo:userInfo];
}

@end
