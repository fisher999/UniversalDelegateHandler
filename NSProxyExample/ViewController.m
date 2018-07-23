//
//  ViewController.m
//  NSProxyExample
//
//  Created by Виктор on 29/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import "ViewController.h"
#import "UniversalDelegateHandler.h"
#import "NSThread+Extensions.h"
#import "NSPointerArray+Extensions.h"
#import "MyProtocol.h"
#import <UIKit/UIKit.h>






@interface ViewController () <MyProtocolDelegateOne,MyProtocolDelegateTwo>


@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    MyProtocol *myProtocol = [MyProtocol new];
    UniversalDelegateHandler *delegateHandler = [UniversalDelegateHandler handlerForProtocol:myProtocol];
    ViewController<MyProtocolDelegateOne> *delegateOne = [ViewController new];
    ViewController<MyProtocolDelegateTwo> *delegateTwo = [ViewController new];
    [delegateHandler addListener:delegateOne];
    [delegateHandler addListener:delegateTwo];
    myProtocol.delegate = delegateHandler;
    [myProtocol doSomething];
    [myProtocol doSomethingAfter:5];
}

- (void)endOfSomething {
    NSLog(@"Something happened");
}

- (void)endOfSomethingTwo:(NSString *)text {
    NSLog(@"%@", text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (void)endOfSomethingForDelegateTwo {
    NSLog(@"Something happened for DelegateTwo");
}



@end
