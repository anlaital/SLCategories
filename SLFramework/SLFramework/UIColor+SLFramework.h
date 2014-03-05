//
//  UIColor+SLFramework.h
//  SLFramework
//
//  Created by Antti Laitala on 02/03/14.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SLColorFormat) {
    SLColorFormatRGB8,
    SLColorFormatRGBA8
};

typedef struct {
    CGFloat r, g, b, a;
} SLColorComponents;

@interface UIColor (SLFramework)

+ (UIColor *)colorFromHex:(NSString *)hex;
+ (UIColor *)colorFromHex:(NSString *)hex format:(SLColorFormat)format;

- (NSString *)hexStringWithFormat:(SLColorFormat)format prependHash:(BOOL)prependHash;

- (SLColorComponents)components;

- (CGFloat)luminosity;
- (CGFloat)luminosityDifferenceWithColor:(UIColor *)color;

@end
