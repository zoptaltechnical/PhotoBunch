//
//  ImageCompress.h
//  PhotoBunch
//
//  Created by Gorav Grover on 28/06/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageCompress : NSObject


+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight;
+ (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)newSize;

@end
