//
//  NSThread+Extensions.h
//  ExampleOfNSProxy
//
//  Created by Виктор on 19/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSThread ( NSThreadCategory )
- (void)performBlock:(void(^)(void))block;
@end

@implementation NSThread ( PerformBlock )
- (void)performBlock:(void(^)(void))block{
    dispatch_block_perform(DISPATCH_BLOCK_ASSIGN_CURRENT, block);
}
@end



