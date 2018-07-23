//
//  MyProtocol.h
//  NSProxyExample
//
//  Created by Виктор on 30/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MyProtocolDelegateOne<NSObject>
- (void)endOfSomething;
- (void)endOfSomethingTwo:(NSString *)text;
@end

@protocol MyProtocolDelegateTwo<NSObject>
- (void)endOfSomethingForDelegateTwo;
@end

@interface MyProtocol : NSObject

@property (nonatomic,assign)id <NSObject> delegate;

-(void)doSomething;
-(void)doSomethingAfter:(CGFloat)sec;
-(void)ShowInfoTwo;

@end
