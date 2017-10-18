//
//  CustomTextView.h
//  YesWow
//
//  Created by Gorav Grover on 17/02/17.
//  Copyright © 2017 Eshan Cheema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CustomTextView : UITextView
@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

-(void)textChanged:(NSNotification*)notification;

@end
