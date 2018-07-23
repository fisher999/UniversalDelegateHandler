//
//  NSPointerArray+Extensions.h
//  ExampleOfNSProxy
//
//  Created by Виктор on 19/06/2018.
//  Copyright © 2018 Виктор. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPointerArray ()
@property(nonatomic, strong,readonly) NSArray *elementsArray;
@end

@interface NSPointerArray ( RemovePointer )
- (void)removePointerAndCompact: (id <NSObject>)listener;
@end


@implementation NSPointerArray ( NSPointerCategory )
- (NSArray*) elementsArray {
    NSMutableArray *tempArray = [NSMutableArray new];
    for (id pointer in self) {
        if (pointer != nil) {
            [tempArray addObject:pointer];
        }
    }
    return tempArray;
}

- (void)removePointerAndCompact:(id <NSObject>)listener {
    int index = 0;
    bool listenerWasFinded = NO;
    for (id pointer in self) {
        if (pointer == listener) {
            listenerWasFinded = YES;
            break;
        }
        index ++;
    }
    
    if (listenerWasFinded) {
        [self removePointerAtIndex:index];
        [self compact];
    }
    else {
        NSLog(@"Cant find listener");
    }
    
}

@end
