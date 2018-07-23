//
//  UniversalDelegateHandler.m
//  ExampleOfNSProxy
//
//  Created by Виктор on 19/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import <objc/runtime.h>
#import "UniversalDelegateHandler.h"
#import "NSThread+Extensions.h"
#import "NSPointerArray+Extensions.h"

@interface UniversalDelegateHandler ()

@property(nonatomic, strong) Protocol *theProtocol;
@property(nonatomic, strong) NSPointerArray *listeners;
@property(nonatomic, strong) NSMapTable *delegateThreads;
@property(nonatomic, strong) NSObject *lockObject;

@end

@implementation UniversalDelegateHandler

+ (UniversalDelegateHandler *)handlerForProtocol:(Protocol *)aProtocol {
    UniversalDelegateHandler *instance = [UniversalDelegateHandler alloc];
    instance.theProtocol = aProtocol;
    instance.listeners = [NSPointerArray weakObjectsPointerArray];
    instance.delegateThreads = [NSMapTable weakToWeakObjectsMapTable]; // because NSMapTable doesn't copy its keys
    instance.lockObject = [NSObject new];
    return instance;
}

- (void)addListener:(id <NSObject>)listener thread:(NSThread *)thread {
    @synchronized (self.lockObject) {
        for (id existingListener in self.listeners) {
            if (existingListener == listener) {
                return;
            }
        }
        
        [self.listeners addPointer:(__bridge void *) listener];
        [self.listeners compact];
        
        if (thread) {
            NSMapTable *newDelegateThreads = [self.delegateThreads copy];
            [newDelegateThreads setObject:thread forKey:listener];
            self.delegateThreads = newDelegateThreads;
        }
    }
}

- (void)addListener:(id <NSObject>)listener {
    [self addListener:listener thread:nil];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    for (id listener in _listeners) {
        if ([listener respondsToSelector:aSelector]) {
            return listener;
        }
    }
        return nil;
    
}

- (void)removeListener:(id <NSObject>)listener {
    @synchronized (self.lockObject) {
        [self.listeners removePointerAndCompact:listener];
        NSMapTable *newDelegateThreads = [self.delegateThreads copy];
        [newDelegateThreads removeObjectForKey:listener];
        self.delegateThreads = newDelegateThreads;
    }
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self methodSignatureForSelector:aSelector] != nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation retainArguments];
    NSArray *listeners = nil;
    NSMapTable *delegateThreads = nil;
    @synchronized (self.lockObject) {
        listeners = self.listeners.elementsArray;
        delegateThreads = self.delegateThreads;
    }
    
    for (id listener in listeners) {
        if ([listener respondsToSelector:invocation.selector]) {
            NSThread *thread = [delegateThreads objectForKey:listener];
            if (thread == nil || thread == [NSThread currentThread]) {
                [invocation invokeWithTarget:listener];
            } else {
                [thread performBlock:^{
                    [invocation invokeWithTarget:listener];
                }];
            }
        }
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    struct objc_method_description methodDescription =
    protocol_getMethodDescription(self.theProtocol, aSelector, YES, YES);
    if (!methodDescription.name){
        methodDescription = protocol_getMethodDescription(self.theProtocol, aSelector, NO, YES);
        if (!methodDescription.name)
            return nil;
    }
    return [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
}


@end
