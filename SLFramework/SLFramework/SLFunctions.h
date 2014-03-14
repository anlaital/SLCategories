//
//  SLFunctions.h
//  SLFramework
//
//  Created by Antti Laitala on 07/03/14.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SLPrimitiveDataType) {
    /** Property is not a primitive data type. */
    SLPrimitiveDataTypeNone,
    /** Property is `char`. */
    SLPrimitiveDataTypeChar,
    /** Property is `unsigned char`. */
    SLPrimitiveDataTypeUnsignedChar,
    /** Property is `short`. */
    SLPrimitiveDataTypeShort,
    /** Property is `unsigned short`. */
    SLPrimitiveDataTypeUnsignedShort,
    /** Property is `int`. */
    SLPrimitiveDataTypeInt,
    /** Property is `unsigned int`. */
    SLPrimitiveDataTypeUnsignedInt,
    /** Property is `long`. */
    SLPrimitiveDataTypeLong,
    /** Property is `unsigned long`. */
    SLPrimitiveDataTypeUnsignedLong,
    /** Property is `long long`. */
    SLPrimitiveDataTypeLongLong,
    /** Property is `unsigned long long`. */
    SLPrimitiveDataTypeUnsignedLongLong,
    /** Property is `float`. */
    SLPrimitiveDataTypeFloat,
    /** Property is `double`. */
    SLPrimitiveDataTypeDouble,
    /** Property is `id`. */
    SLPrimitiveDataTypeId
};

@interface SLObjectProperty : NSObject

/** Name of the property. */
@property (nonatomic, readonly) NSString *name;
/** The property is read-only (`readonly`). */
@property (nonatomic, readonly, getter = isReadonly) BOOL readonly;
/** The property is atomic (`atomic`). */
@property (nonatomic, readonly, getter = isAtomic) BOOL atomic;
/** The property is a copy of the value last assigned (`copy`). */
@property (nonatomic, readonly) BOOL copiesValue;
/** The property is a reference to the value last assigned (`retain`). */
@property (nonatomic, readonly) BOOL retainsValue;
/** The property is dynamic (`@dynamic`). */
@property (nonatomic, readonly, getter = isDynamic) BOOL dynamic;
/** The property is a weak reference (`__weak`). */
@property (nonatomic, readonly, getter = isWeak) BOOL weak;
/** Selector of the custom setter method or nil if none. */
@property (nonatomic, readonly) SEL customSetter;
/** Selector of the custom getter method or nil if none. */
@property (nonatomic, readonly) SEL customGetter;
/** Primitive data type as defined by `SLPrimitiveDataType`. `SLPrimitiveDataTypeNone` if not a primitive data type. */
@property (nonatomic, readonly) SLPrimitiveDataType primitiveDataType;
/** Class data type or nil if none. */
@property (nonatomic, readonly) Class classDataType;
/** Names of the protocols implemented by the property or nil if none. */
@property (nonatomic, readonly) NSArray *protocolNames;

@end

@interface SLFunctions : NSObject

/** Returns the current system uptime in seconds or -1 if it cannot be determined. */
+ (time_t)uptime;

/** Returns the properties for the given class as wrapped by `SLObjectProperty`. This does not return properties inherited from super classes. */
+ (NSArray *)propertiesForClass:(Class)aClass;
/** Returns the properties for `class` and all its super classes up to `baseClass`. If `class` is not a descendand of `baseClass`, then all properties are returned. */
+ (NSArray *)propertiesForClass:(Class)aClass recursivelyUpToClass:(Class)baseClass;

@end
