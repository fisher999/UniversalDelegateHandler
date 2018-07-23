//
//  MyProtocol.m
//  NSProxyExample
//
//  Created by Виктор on 30/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "MyProtocol.h"
#import <UIKit/UIKit.h>

@implementation MyProtocol

//@synthesize delegate;

-(void)doSomething {
    SEL selector = @selector(endOfSomething);
    [_delegate performSelector:selector];
}

-(void)doSomethingAfter:(double)sec {
    sleep(sec);
    [self performSelector:@selector(ShowInfoTwo)];
}

-(void)ShowInfoTwo {
    SEL selector = @selector(endOfSomethingTwo:);
     [_delegate performSelector:selector withObject:@"Something happened again"];
    
}

@end
