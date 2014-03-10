//
//  SLFunctions.h
//  SLFramework
//
//  Created by Antti Laitala on 07/03/14.
//
//

#import <Foundation/Foundation.h>

@interface SLFunctions : NSObject

/** 
 * Returns the current system uptime in seconds or -1 if it cannot be determined.
 */
+ (time_t)uptime;

@end
