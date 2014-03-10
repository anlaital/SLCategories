//
//  SLTicker.h
//  SLFramework
//
//  Created by Antti Laitala on 05/03/14.
//
//

#import <Foundation/Foundation.h>

@class SLTicker;

@protocol SLTickerDelegate <NSObject>

- (void)ticker:(SLTicker *)ticker didTick:(NSUInteger)numTicks;

@end

@interface SLTicker : NSObject

/** Delegate for the ticker. */
@property (nonatomic, weak) id<SLTickerDelegate> delegate;
/** Tick interval in seconds. */
@property (nonatomic) NSTimeInterval tickInterval;

@property (nonatomic, getter = isTicking) BOOL ticking;

@end
