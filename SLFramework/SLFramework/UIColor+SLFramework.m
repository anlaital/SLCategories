//
//  UIColor+SLFramework.m
//  SLFramework
//
//  Created by Antti Laitala on 02/03/14.
//
//

#import "UIColor+SLFramework.h"

@implementation UIColor (SLFramework)

+ (UIColor *)colorFromHex:(NSString *)hex
{
    return [UIColor colorFromHex:hex format:SLColorFormatRGB8];
}

+ (UIColor *)colorFromHex:(NSString *)hex format:(SLColorFormat)format
{
    UIColor *result = nil;
    
    static NSCharacterSet *charactersToBeSkipped = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        charactersToBeSkipped = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdefABCDEF"] invertedSet];
    });

    NSScanner *scanner = [NSScanner scannerWithString:hex];
    scanner.charactersToBeSkipped = charactersToBeSkipped;

    NSUInteger value;
    if ([scanner scanHexInt:&value]) {
        CGFloat r, g, b, a = 255;
        switch (format) {
            case SLColorFormatRGBA8:
                r = (value & 0xFF000000) >> 24;
                g = (value & 0x00FF0000) >> 16;
                b = (value & 0x0000FF00) >> 8;
                a = (value & 0x000000FF);
                break;
            case SLColorFormatRGB8:
                r = (value & 0xFF0000) >> 16;
                g = (value & 0x00FF00) >> 8;
                b = (value & 0x0000FF);
                break;
            default:
                return nil;
        }
        result = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a/255];
    }
    
    return result;
}

- (NSString *)hexStringWithFormat:(SLColorFormat)format prependHash:(BOOL)prependHash
{
    NSString *prefix = prependHash ? @"#" : @"";

    SLColorComponents c = self.components;
    NSUInteger r = c.r * 255;
    NSUInteger g = c.g * 255;
    NSUInteger b = c.b * 255;
    NSUInteger a = c.a * 255;
    
    switch (format) {
        case SLColorFormatRGB8:
            return [NSString stringWithFormat:@"%@%02x%02x%02x", prefix, r, g, b];
        case SLColorFormatRGBA8:
            return [NSString stringWithFormat:@"%@%02x%02x%02x%02x", prefix, r, g, b, a];
        default:
            return nil;
    }
}

- (SLColorComponents)components
{
    SLColorComponents components;
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
        case kCGColorSpaceModelMonochrome:
            components.r = components.g = components.b = c[0];
            components.a = c[1];
            break;
        case kCGColorSpaceModelRGB:
            components.r = c[0];
            components.g = c[1];
            components.b = c[2];
            components.a = c[3];
            break;
        default:
            break;
    }
    return components;
}

- (CGFloat)luminosity
{
    SLColorComponents c = self.components;
    return 0.2126 * pow(c.r, 2.2) + 0.7152 * pow(c.g, 2.2) + 0.0722 * pow(c.b, 2.2);
}

- (CGFloat)luminosityDifferenceWithColor:(UIColor *)color
{
    CGFloat myLuminosity = self.luminosity;
    CGFloat otherLuminosity = color.luminosity;
    if (myLuminosity > otherLuminosity)
        return (myLuminosity + 0.05) / (otherLuminosity + 0.05);
    return (otherLuminosity + 0.05) / (myLuminosity + 0.05);
}

@end
