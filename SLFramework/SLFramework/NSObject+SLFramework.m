//
//  NSObject+SLFramework.m
//  SLFramework
//
//  Created by Antti Laitala on 08/03/14.
//
//

#import <objc/runtime.h>

#import "NSObject+SLFramework.h"

@implementation SLObjectProperty

- (id)initWithProperty:(objc_property_t)property
{
    if (self = [super init]) {
        _name = [NSString stringWithUTF8String:property_getName(property)];
        
        _atomic = YES;
        NSArray *attributes = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","];
        for (NSString *attribute in attributes) {
            NSString *type = attribute.length ? [attribute substringToIndex:1] : nil;
            if ([type isEqualToString:@"T"]) {
                // TODO: Parse type specifier?
            } else if ([type isEqualToString:@"R"]) {
                _readonly = YES;
            } else if ([type isEqualToString:@"C"]) {
                _copiesValue = YES;
            } else if ([type isEqualToString:@"&"]) {
                _retainsValue = YES;
            } else if ([type isEqualToString:@"N"]) {
                _atomic = NO;
            } else if ([type isEqualToString:@"D"]) {
                _dynamic = YES;
            } else if ([type isEqualToString:@"W"]) {
                _weak = YES;
            } else if ([type isEqualToString:@"P"]) {
                // Garbage collection attribute is not supported.
            }
        }
    }
    return self;
}

@end

@implementation NSObject (SLFramework)

+ (NSArray *)classProperties
{
    NSMutableArray *result = [NSMutableArray new];
    
    unsigned int numProperties = 0;
    objc_property_t *properties = class_copyPropertyList([self class], &numProperties);
    for (int i = 0; i < numProperties; ++i)
        [result addObject:[[SLObjectProperty alloc] initWithProperty:properties[i]]];
    free(properties);
    
    return result;
}

@end
