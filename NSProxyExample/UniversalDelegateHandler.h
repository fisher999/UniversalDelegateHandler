//
//  UniversalDelegateHandler.h
//  ExampleOfNSProxy
//
//  Created by Виктор on 19/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UniversalDelegateHandler : NSProxy

+ (UniversalDelegateHandler *)handlerForProtocol:(Protocol *)aProtocol;

- (void)addListener:(id<NSObject>)listener thread:(NSThread *)thread;

- (void)addListener:(id<NSObject>)listener;

- (void)removeListener:(id<NSObject>)listener;



@end

