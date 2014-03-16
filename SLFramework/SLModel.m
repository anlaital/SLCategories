// SLModel.m
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
            SLLog(@"Failed to initialize model `%@` from dictionary `%@` with error `%@`", self.class, dictionary, error);
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

        // Determine if the value is an NSNull.
        if (value == [NSNull null]) {
            // NSNulls are implicitly converted to nils as they provide no benefits and are a likely source of uncaught exceptions when handling data coming remote backends.
            value = nil;
        }
        
        BOOL isRequiredProperty = [property.protocolNames containsObject:NSStringFromProtocol(@protocol(SLModelRequired))];

        // Determine if the property needs to be instantiated from another model.
        if ([property.classDataType isSubclassOfClass:[SLModel class]]) {
            // Property is directly another model.
            if (![value isKindOfClass:[NSDictionary class]]) {
                // SLModels can only be instantiated from dictionaries.
                *error = [SLError errorWithUserInfo:@{ SLErrorReason: [NSString stringWithFormat:@"Property named `%@` is a model but value `%@` is not a dictionary", property.name, value], SLErrorObject: self }];
                return;
            }
            value = [[property.classDataType alloc] initWithDictionary:value];
        } else if ([property.classDataType isSubclassOfClass:[NSArray class]]) {
            // Determine if the array conforms to a protocol that has a model with the same name.
            Class modelClass = nil;
            for (NSString *protocolName in property.protocolNames) {
                modelClass = NSClassFromString(protocolName);
                if (modelClass)
                    break;
            }
            if (modelClass) {
                // Instantiate models from the array data.
                if (![value isKindOfClass:[NSArray class]]) {
                    // SLModel arrays can only be instantiated from arrays.
                    *error = [SLError errorWithUserInfo:@{ SLErrorReason: [NSString stringWithFormat:@"Property named `%@` is an array of models but value `%@` is not an array", property.name, value], SLErrorObject: self }];
                    return;
                }
                
                NSMutableArray *models = [NSMutableArray new];
                for (id dict in value) {
                    if (![dict isKindOfClass:[NSDictionary class]]) {
                        // SLModels can only be instantiated from dictionaries.
                        *error = [SLError errorWithUserInfo:@{ SLErrorReason: [NSString stringWithFormat:@"Property named `%@` is an array of models but value `%@` is not a dictionary", property.name, value], SLErrorObject: self }];
                        return;
                    }
                    id model = [[modelClass alloc] initWithDictionary:dict];
                    if (model)
                        [models addObject:model];
                }
                value = models;
            }
        }
        
        // Perform property nil value checks.
        if (!value) {
            if (isRequiredProperty) {
                // Required property was not found from the dictionary.
                *error = [SLError errorWithUserInfo:@{ SLErrorReason: [NSString stringWithFormat:@"Required property named `%@` not found in dictionary", property.name], SLErrorObject: self }];
                return;
            }
            continue;
        }
        
        // Determine if the property is mutable.
        if ([property.classDataType conformsToProtocol:@protocol(NSMutableCopying)]) {
            // If the data type is a class and it implements the NSMutableCopying protocol, then make a mutable copy of it.
            value = [value mutableCopy];
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
