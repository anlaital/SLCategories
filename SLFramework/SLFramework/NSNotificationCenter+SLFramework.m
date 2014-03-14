// NSNotificationCenter+SLFramework.m
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
