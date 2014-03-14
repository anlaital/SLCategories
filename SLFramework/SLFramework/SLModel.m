//
//  SLModel.m
//  SLFramework
//
//  Created by Antti Laitala on 10/03/14.
//
//

#import <objc/runtime.h>

#import "SLModel.h"
#import "SLFunctions.h"
#import "SLLogger.h"
#import "SLError.h"

#define __invokeSelector(selector, argType, arg) \
    IMP __imp = [self methodForSelector:selector]; \
    void *(*__impFunc)(id, SEL, argType) = (void *)__imp; \
    __impFunc(self, selector, arg)

@implementation SLModel

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        NSError *error = nil;
        [self __parsePropertiesFromDictionary:dictionary error:&error];
        if (error) {
            SLLog(@"Failed to initialize SLModel from dictionary `%@` with error `%@`", dictionary, error);
            return nil;
        }
    }
    return self;
}

#pragma mark - Private

- (void)__parsePropertiesFromDictionary:(NSDictionary *)dictionary error:(NSError **)error
{
    NSArray *properties = [SLFunctions propertiesForClass:self.class recursivelyUpToClass:[SLModel class]];
    for (SLObjectProperty *property in properties) {
        if ([property.protocolNames containsObject:NSStringFromProtocol(@protocol(SLModelIgnored))]) {
            // Do not process properties marked to be ignored.
            continue;
        }
        
        id value = dictionary[property.name];
        if (!value) {
            if ([property.protocolNames containsObject:NSStringFromProtocol(@protocol(SLModelRequired))]) {
                // Required property was not found from the dictionary.
                *error = [SLError errorWithUserInfo:@{
                    SLErrorReason: [NSString stringWithFormat:@"Required property named `%@` not found in dictionary", property.name],
                    SLErrorObject: self
                }];
                return;
            }
            continue;
        }
        
        if (value == NSNull.null) {
            // Ignore null values.
            continue;
        }
        
        SEL setter = property.customSetter ?: NSSelectorFromString([NSString stringWithFormat:@"set%@:", [[property.name substringToIndex:1].uppercaseString stringByAppendingString:[property.name substringFromIndex:1]]]);
        if (![self respondsToSelector:setter]) {
            // Fail if property has a custom setter but doesn't respond to its selector.
            if (property.customSetter) {
                *error = [SLError errorWithUserInfo:@{
                    SLErrorReason: [NSString stringWithFormat:@"Property named `%@` defines custom setter `%@` but does not respond to it", property.name, NSStringFromSelector(setter)],
                    SLErrorObject: self
                }];
                return;
            }

            // KVO is used to set values for read-only properties.
            if (property.isReadonly) {
                [self setValue:value forKey:property.name];
                continue;
            }
            
            *error = [SLError errorWithUserInfo:@{
                SLErrorReason: [NSString stringWithFormat:@"Property named `%@` does not respond to synthesized setter `%@`", property.name, NSStringFromSelector(setter)],
                SLErrorObject: self
            }];
        }
        
        IMP imp = [self methodForSelector:setter];
        
        if (property.primitiveDataType == SLPrimitiveDataTypeNone || property.primitiveDataType == SLPrimitiveDataTypeId) {
            void *(*impFunc)(id, SEL, id) = (void *)imp;
            impFunc(self, setter, value);
        } else {
            if (![value isKindOfClass:[NSNumber class]]) {
                *error = [SLError errorWithUserInfo:@{
                    SLErrorReason: [NSString stringWithFormat:@"Property named `%@` is a native data type but its class `%@` is not a number", property.name, [value class]],
                    SLErrorObject: self
                }];
                return;
            }
            
            NSNumber *number = value;
            if (property.primitiveDataType == SLPrimitiveDataTypeChar) {
                __invokeSelector(setter, char, number.charValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeUnsignedChar) {
                __invokeSelector(setter, unsigned char, number.unsignedCharValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeShort) {
                __invokeSelector(setter, short, number.shortValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeUnsignedShort) {
                __invokeSelector(setter, unsigned short, number.unsignedShortValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeInt) {
                __invokeSelector(setter, int, number.intValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeUnsignedInt) {
                __invokeSelector(setter, unsigned int, number.unsignedIntValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeLong) {
                __invokeSelector(setter, long, number.longValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeUnsignedLong) {
                __invokeSelector(setter, unsigned long, number.unsignedLongValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeLongLong) {
                __invokeSelector(setter, long long, number.longLongValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeUnsignedLongLong) {
                __invokeSelector(setter, unsigned long long, number.unsignedLongLongValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeFloat) {
                __invokeSelector(setter, float, number.floatValue);
            } else if (property.primitiveDataType == SLPrimitiveDataTypeDouble) {
                __invokeSelector(setter, double, number.doubleValue);
            } else {
                *error = [SLError errorWithUserInfo:@{
                    SLErrorReason: [NSString stringWithFormat:@"Missing implementation for primitive data type `%d`", property.primitiveDataType],
                    SLErrorObject: self
                }];
                return;
            }
        }
    }
}

@end
