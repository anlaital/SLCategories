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
    
    NSCharacterSet *whitelist = [NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"];

    NSScanner *scanner = [NSScanner scannerWithString:hex];
    scanner.charactersToBeSkipped = whitelist.invertedSet;
    scanner.caseSensitive = NO;

    unsigned int value;
    if ([scanner scanHexInt:&value]) {
        CGFloat r, g, b, a;
        switch (format) {
            case SLColorFormatRGB8:
            default:
                r = (value & 0xFF0000) >> 16;
                g = (value & 0x00FF00) >> 8;
                b = (value & 0x0000FF);
                a = 255.0;
                break;
        }
        result = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a/255];
    }
    
    return result;
}

@end
