//
//  SingeltonMacro.h
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(classname)	\
\
+ (instancetype) shared##classname \



#define SINGLETON_FOR_CLASS(classname) \
\
+ (instancetype) shared##classname \
{ \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = [[self alloc] init]; \
}); \
return _sharedObject;\
}

