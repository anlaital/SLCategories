//
//  SLFunctions.m
//  SLFramework
//
//  Created by Antti Laitala on 07/03/14.
//
//

#import <sys/sysctl.h>

#import "SLFunctions.h"

@implementation SLFunctions

+ (time_t)uptime
{
    struct timeval boottime;
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
        uptime = now - boottime.tv_sec;
    return uptime;
}

@end
