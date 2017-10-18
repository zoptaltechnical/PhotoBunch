//
//  RunOnMainThread.m
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.


#import "RunOnMainThread.h"

@implementation RunOnMainThread

/**
  *  Check if we are on the main thread or not.
  *  If not then Dispatch it on the main queue
  **/
+ (void)runBlockInMainQueueIfNecessary:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        
        dispatch_queue_t mainqueue=dispatch_get_main_queue();
        dispatch_async(mainqueue, block);
    }
}

@end
