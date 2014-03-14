//
//  SLError.h
//  SLFramework
//
//  Created by Antti Laitala on 14/03/14.
//
//

#import <Foundation/Foundation.h>

extern NSString *const SLErrorDomain;
extern NSString *const SLErrorReason;
extern NSString *const SLErrorObject;

@interface SLError : NSError

+ (instancetype)errorWithUserInfo:(NSDictionary *)userInfo;

@end
