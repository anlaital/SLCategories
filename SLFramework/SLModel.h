// SLModel.h
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

#import <Foundation/Foundation.h>

@protocol SLModel <NSObject>

/**
 Initializes the object from the given `dictionary`.
 
 @related `dictionaryForMappingPropertyNames`
 
 @param dictionary The dictionary to use when initializing the object.
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/**
 Returns the dictionary presentation of the model.
 */
- (NSDictionary *)dictionaryPresentation;

@end

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
 
 @related `SLModelRequired`
 @related `SLModelIgnored`
 */
@interface SLModel : NSObject <SLModel>

/**
 Provides an optional dictionary for mapping the model's property names to dictionary keys. This dictionary is used by `initWithDictionary:` and may contain only a subset of the model's property names. The model always checks this dictionary for custom mapping first and if no custom mapping is found, then the default name-to-name mapping is used.
 
 @return Dictionary for mapping the model's property names to dictionary keys or nil if none.
 */
- (NSDictionary *)dictionaryForMappingPropertyNames;

@end

/**
 This is just to make all objects conform to the protocols supported by the model to prevent compiler warnings.
 */
@interface NSObject (SLModel) <SLModelRequired, SLModelIgnored> @end
