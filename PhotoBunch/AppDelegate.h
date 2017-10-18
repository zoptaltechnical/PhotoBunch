//
//  AppDelegate.h
//  PhotoBunch
//
//  Created by Gorav Grover on 25/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, strong) NSString *notificationType;

- (void)saveContext;
-(BOOL)hasInternetConnection;
-(void)startLoader:(UIView*)view withTitle:(NSString*)message;
- (void)stopLoader:(UIView*)view;

@end

