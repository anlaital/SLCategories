//
//  UIColor+SLCategories.m
//  SLCategories
//
//  Created by Antti Laitala on 02/03/14.
//
//

#import "UIColor+SLCategories.h"

@implementation UIColor (SLCategories)

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

    CGFloat r, g, b, a;
    const CGFloat *c = CGColorGetComponents(self.CGColor);
    switch (CGColorSpaceGetModel(CGColorGetColorSpace(self.CGColor))) {
        case kCGColorSpaceModelMonochrome:
            r = g = b = c[0];
            a = c[1];
            break;
        case kCGColorSpaceModelRGB:
            r = c[0];
            g = c[1];
            b = c[2];
            a = c[3];
            break;
        default:
            return nil;
    }
    
    NSUInteger red = r * 255;
    NSUInteger green = g * 255;
    NSUInteger blue = b * 255;
    NSUInteger alpha = a * 255;
    
    switch (format) {
        case SLColorFormatRGB8:
            return [NSString stringWithFormat:@"%@%02x%02x%02x", prefix, red, green, blue];
        case SLColorFormatRGBA8:
            return [NSString stringWithFormat:@"%@%02x%02x%02x%02x", prefix, red, green, blue, alpha];
        default:
            return nil;
    }
}

@end
