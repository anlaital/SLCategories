//
//  NSObject+SLFramework.h
//  SLFramework
//
//  Created by Antti Laitala on 08/03/14.
//
//

#import <Foundation/Foundation.h>

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

@end

@interface NSObject (SLFramework)

+ (NSArray *)classProperties;

@end
