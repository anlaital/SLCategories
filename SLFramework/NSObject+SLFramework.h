//
//  NSObject+SLFramework.h
//  SLFrameworkTests
//
//  Created by Antti Laitala on 15/03/14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (SLFramework)

/**
 Removes an observer from receiving key-value changes. This catches the exception thrown by `removeObserver:forKeyPath:` if the observer is not registered.
 
 @return YES if an observer was removed, NO otherwise.
 */
- (BOOL)safelyRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

/**
 Removes an observer from receiving key-value changes. This catches the exception thrown by `removeObserver:forKeyPath:context:` if the observer is not registered.
 
 @return YES if an observer was removed, NO otherwise.
 */
- (BOOL)safelyRemoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;

@end
