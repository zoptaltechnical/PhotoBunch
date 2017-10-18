//
//  CALayer+BorderProperties.m
//  EAuction
//
//  Created by Gorav Grover on 22/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "CALayer+BorderProperties.h"
#import <QuartzCore/QuartzCore.h>

@implementation CALayer (BorderProperties)

- (void)setBorderUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}

- (UIColor *)borderUIColor {
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
