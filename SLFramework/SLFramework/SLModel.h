//
//  SLModel.h
//  SLFramework
//
//  Created by Antti Laitala on 10/03/14.
//
//

#import <Foundation/Foundation.h>

/**
 Protocol for marking `SLModel` properties as being required.
 */
@protocol SLModelRequired <NSObject>

@end

/**
 Protocol for marking `SLModel` properties as being ignored.
 */
@protocol SLModelIgnored <NSObject>

@end

/**
 Defines an interface for models.
 
 @see `SLModelRequired`
 @see `SLModelIgnored`
 */
@interface SLModel : NSObject

/**
 Initializes the object from the given `dictionary`.
 
 @param dictionary The dictionary to use when initializing the object.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
