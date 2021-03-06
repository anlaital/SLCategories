// SLTicker.h
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

#import <Foundation/Foundation.h>

@class SLTicker;

@protocol SLTickerDelegate <NSObject>

- (void)ticker:(SLTicker *)ticker didTick:(NSUInteger)numTicks;

@end

@protocol SLTickerProxyDelegate <NSObject>

- (void)performTick;

@end

@interface SLTicker : NSObject <SLTickerProxyDelegate>

/** Delegate for the ticker. */
@property (nonatomic, weak) id<SLTickerDelegate> delegate;
/** Tick interval in seconds. */
@property (nonatomic) NSTimeInterval tickInterval;

@property (nonatomic, getter = isTicking) BOOL ticking;

@end
