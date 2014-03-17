// SLModelPropertyNameTransformer.h
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

@class SLObjectProperty;

/**
 Defines protocol for transforming model property names to dictionary keys.
 */
@protocol SLModelPropertyNameTransformer <NSObject>

/**
 Transform the name of the given `property` to its dictionary key.
 */
- (NSString *)dictionaryKeyForProperty:(SLObjectProperty *)property;

@end

/**
 Defines the interface for accessing model property name transformations.
 */
@interface SLModelPropertyNameTransform : NSObject

/**
 The default property name transformer to use. This may be overridden for specific classes by using `registerTransformer:forModel:`. The default value is nil.
 */
@property (nonatomic) id<SLModelPropertyNameTransformer> defaultTransformer;

/**
 Snake case property name transformer. Maps property names to their snake case presentation.
 */
@property (nonatomic, readonly) id<SLModelPropertyNameTransformer> snakeCaseTransformer;

/**
 Null property name transformer. Passes property names through unmodified.
 */
@property (nonatomic, readonly) id<SLModelPropertyNameTransformer> nullTransformer;

/**
 Returns the shared property name transform instance.
 
 @return Shared property name transform instance.
 */
+ (instancetype)sharedInstance;

/**
 Registers the given `transformer` to be used by instances of `modelClass`. This overrides the `defaultTransformer` property if set.
 
 @param transformer Transformer to set or `nullTransformer` if no transformer should be used. Providing a nil as `transformer` removes the existing transformer.
 @param modelClass Class of the model for which the transformer is registered.
 */
- (void)registerTransformer:(id<SLModelPropertyNameTransformer>)transformer forModelClass:(Class)modelClass;

/**
 Returns the transformer for the given `modelClass`.
 
 @param modelClass Class of the model for which to return the registered transformer.
 @return Transformer registered to `modelClass`. This can be either nil if no transformer is registered for the model or `[NSNull null]` if a null transformer is explicitly registered for the model.
 */
- (id<SLModelPropertyNameTransformer>)transformerForModelClass:(Class)modelClass;

/**
 Removes all registered transformers.
 */
- (void)removeAllTransformers;

@end
