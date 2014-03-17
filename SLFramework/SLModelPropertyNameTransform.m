// SLModelPropertyNameTransformer.m
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

#import "SLModelPropertyNameTransform.h"
#import "SLFunctions.h"
#import "NSString+SLFramework.h"

#pragma mark - SLSnakeCasePropertyNameTransformer

@interface SLSnakeCasePropertyNameTransformer : NSObject <SLModelPropertyNameTransformer>

@end

@implementation SLSnakeCasePropertyNameTransformer

- (NSString *)dictionaryKeyForProperty:(SLObjectProperty *)property
{
    return property.name.snakeCaseString;
}

@end

#pragma mark - SLNullPropertyNameTransforme

@interface SLNullPropertyNameTransformer : NSObject <SLModelPropertyNameTransformer>

@end

@implementation SLNullPropertyNameTransformer

- (NSString *)dictionaryKeyForProperty:(SLObjectProperty *)property
{
    return property.name;
}

@end

#pragma mark - SLModelPropertyNameTransform

@implementation SLModelPropertyNameTransform
{
    NSMutableDictionary *_transformers;
}

@synthesize snakeCaseTransformer = _snakeCaseTransformer;
@synthesize nullTransformer = _nullTransformer;

#pragma mark - Life

+ (instancetype)sharedInstance
{
    static SLModelPropertyNameTransform *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SLModelPropertyNameTransform new];
    });
    return instance;
}

- (id)init
{
    if (self = [super init]) {
        _transformers = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark - Public

- (id<SLModelPropertyNameTransformer>)snakeCaseTransformer
{
    if (!_snakeCaseTransformer)
        _snakeCaseTransformer = [SLSnakeCasePropertyNameTransformer new];
    return _snakeCaseTransformer;
}

- (id<SLModelPropertyNameTransformer>)nullTransformer
{
    if (!_nullTransformer)
        _nullTransformer = [SLNullPropertyNameTransformer new];
    return _nullTransformer;
}

- (void)registerTransformer:(id<SLModelPropertyNameTransformer>)transformer forModelClass:(Class)modelClass
{
    if (transformer)
        _transformers[NSStringFromClass(modelClass)] = transformer;
    else
        [_transformers removeObjectForKey:NSStringFromClass(modelClass)];
}

- (id<SLModelPropertyNameTransformer>)transformerForModelClass:(Class)modelClass
{
    return _transformers[NSStringFromClass(modelClass)];
}

- (void)removeAllTransformers
{
    [_transformers removeAllObjects];
}

@end
