//
//  SLTicker.m
//  SLFramework
//
//  Created by Antti Laitala on 05/03/14.
//
//

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
