// SLTicker.m
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

#import <UIKit/UIApplication.h>

#import "SLTicker.h"
#import "NSNotificationCenter+SLFramework.h"
#import "SLFunctions.h"

@implementation SLTicker
{
    time_t _backgroundTime;
}

- (id)init
{
    if (self = [super init]) {
        _backgroundTime = -1;
        _tickInterval = 1.0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] safelyRemoveObserver:self];

    self.ticking = NO;
}

- (void)setTicking:(BOOL)ticking
{
    if (_ticking == ticking) return;
    _ticking = ticking;
    if (_ticking) {
        [self queueTick];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    }
}

#pragma mark - NSNotificationCenter

- (void)didReceiveApplicationWillResignActiveNotification:(NSNotification *)note
{
    if (!self.isTicking)
        return;
    
    _backgroundTime = [SLFunctions uptime];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didReceiveApplicationDidBecomeActiveNotification:(NSNotification *)note
{
    if (!self.isTicking)
        return;
    if (_backgroundTime < 0)
        return;
    
    time_t current = [SLFunctions uptime];
    time_t delta = current - _backgroundTime;
    
    [_delegate ticker:self didTick:((CGFloat)delta / self.tickInterval)];
    
    [self queueTick];
}

#pragma mark - Private

- (void)tick
{
    [_delegate ticker:self didTick:1];
}

- (void)queueTick
{
    [self performSelector:@selector(tick) withObject:nil afterDelay:self.tickInterval inModes:@[NSRunLoopCommonModes]];
}

@end
