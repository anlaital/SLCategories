//
//  NSNotificationCenter+SLFramework.m
//  SLFramework
//
//  Created by Antti Laitala on 03/03/14.
//
//

#import "NSNotificationCenter+SLFramework.h"

@implementation NSNotificationCenter (SLFramework)

- (BOOL)safelyRemoveObserver:(id)observer
{
    @try {
        [self removeObserver:observer];
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

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

- (BOOL)safelyRemoveObserver:(id)observer name:(NSString *)aName object:(id)anObject
{
    @try {
        [self removeObserver:observer name:aName object:anObject];
    } @catch (NSException *exception) {
        return NO;
    }
    return YES;
}

@end
