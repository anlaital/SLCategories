//
//  NSObject+SLFramework.m
//  SLFrameworkTests
//
//  Created by Antti Laitala on 15/03/14.
//
//

#import "NSObject+SLFramework.h"

@implementation NSObject (SLFramework)

- (BOOL)safelyRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    @try {
        [self removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

- (BOOL)safelyRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context
{
    @try {
        [self removeObserver:observer forKeyPath:keyPath context:context];
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

@end
