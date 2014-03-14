// SLFunctions.m
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

#import <sys/sysctl.h>
#import <objc/runtime.h>

#import "SLFunctions.h"

@implementation SLObjectProperty

- (id)initWithProperty:(objc_property_t)property
{
    if (self = [super init]) {
        _name = [NSString stringWithUTF8String:property_getName(property)];
        _atomic = YES;
        
        NSError *error = nil;
        NSArray *attributes = [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","];
        for (NSString *attribute in attributes) {
            [self __parseAttribute:attribute error:&error];
            NSParameterAssert(!error);
            if (error)
                return nil;
        }
    }
    return self;
}

#pragma mark - Private

- (void)__parseAttribute:(NSString *)attribute error:(NSError **)error;
{
    unichar attributeType = [attribute characterAtIndex:0];
    if (attributeType == 'T') {
        unichar kind = [attribute characterAtIndex:1];
        if (kind == 'c') {
            _primitiveDataType = SLPrimitiveDataTypeChar;
        } else if (kind == 'C') {
            _primitiveDataType = SLPrimitiveDataTypeUnsignedChar;
        } else if (kind == 's') {
            _primitiveDataType = SLPrimitiveDataTypeShort;
        } else if (kind == 'S') {
            _primitiveDataType = SLPrimitiveDataTypeUnsignedShort;
        } else if (kind == 'i') {
            _primitiveDataType = SLPrimitiveDataTypeInt;
        } else if (kind == 'I') {
            _primitiveDataType = SLPrimitiveDataTypeUnsignedInt;
        } else if (kind == 'l') {
            _primitiveDataType = SLPrimitiveDataTypeLong;
        } else if (kind == 'L') {
            _primitiveDataType = SLPrimitiveDataTypeUnsignedLong;
        } else if (kind == 'q') {
            _primitiveDataType = SLPrimitiveDataTypeLongLong;
        } else if (kind == 'Q') {
            _primitiveDataType = SLPrimitiveDataTypeUnsignedLongLong;
        } else if (kind == 'f') {
            _primitiveDataType = SLPrimitiveDataTypeFloat;
        } else if (kind == 'd') {
            _primitiveDataType = SLPrimitiveDataTypeDouble;
        } else if (kind == '@') {
            NSString *name = [[attribute substringToIndex:attribute.length - 1] substringFromIndex:3];

            // Parse protocols.
            NSUInteger protoStartLocation = [name rangeOfString:@"<"].location;
            if (protoStartLocation != NSNotFound) {
                NSString *protos = [name substringFromIndex:protoStartLocation];
                protos = [protos stringByReplacingOccurrencesOfString:@"<" withString:@""];
                protos = [protos substringToIndex:protos.length - 1];
                
                _protocolNames = [protos componentsSeparatedByString:@">"];

                name = [name substringToIndex:protoStartLocation];
            }
            
            if (name.length) {
                _classDataType = NSClassFromString(name);
                NSParameterAssert(_classDataType);
                if (!_classDataType) {
                    // TODO:
                }
            } else {
                _primitiveDataType = SLPrimitiveDataTypeId;
            }
        } else {
            // TODO:
        }
    } else if (attributeType == 'R') {
        _readonly = YES;
    } else if (attributeType == 'C') {
        _copiesValue = YES;
    } else if (attributeType == '&') {
        _retainsValue = YES;
    } else if (attributeType == 'N') {
        _atomic = NO;
    } else if (attributeType == 'D') {
        _dynamic = YES;
    } else if (attributeType == 'W') {
        _weak = YES;
    } else if (attributeType == 'P') {
        // Garbage collection attribute is not supported.
    } else if (attributeType == 'G') {
        _customGetter = NSSelectorFromString([attribute substringFromIndex:1]);
    } else if (attributeType == 'S') {
        _customSetter = NSSelectorFromString([attribute substringFromIndex:1]);
    } else {
        // TODO:
    }
}

@end

@implementation SLFunctions

+ (time_t)uptime
{
    struct timeval boottime;
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    size_t size = sizeof(boottime);
    time_t now;
    time_t uptime = -1;
    
    (void)time(&now);
    
    if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0)
        uptime = now - boottime.tv_sec;
    return uptime;
}

+ (NSArray *)propertiesForClass:(Class)class
{
    NSMutableArray *result = [NSMutableArray new];
    
    unsigned int numProperties = 0;
    objc_property_t *properties = class_copyPropertyList(class, &numProperties);
    for (int i = 0; i < numProperties; ++i)
        [result addObject:[[SLObjectProperty alloc] initWithProperty:properties[i]]];
    free(properties);
    
    return result;
}

+ (NSArray *)propertiesForClass:(Class)class recursivelyUpToClass:(Class)baseClass
{
    NSMutableArray *result = [NSMutableArray new];
    while (class && class != baseClass) {
        [result addObjectsFromArray:[SLFunctions propertiesForClass:class]];
        class = class_getSuperclass(class);
    }
    return result;
}

@end
