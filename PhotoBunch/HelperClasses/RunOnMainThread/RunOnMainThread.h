//
//  RunOnMainThread.h
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.

#import <Foundation/Foundation.h>

@interface RunOnMainThread : NSObject

/**
  *  Create Block to check the Thread.
  **/
+ (void)runBlockInMainQueueIfNecessary:(void (^)(void))block;
@end
