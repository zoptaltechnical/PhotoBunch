//
//  AppDelegate.m
//  PhotoBunch
//
//  Created by Gorav Grover on 25/05/17.
//  Copyright © 2017 Zoptal Solutions. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "Constant.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate ()
{
     BOOL  internetConn;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _notificationType=@"NoNotification";
    
    [GIDSignIn sharedInstance].clientID = @"15529296705-qucn87jfjmnlr740i01lgp1uoqs1vjgv.apps.googleusercontent.com";

    
    NSLog(@"%@",[UserDefaultHandler getUserAccessToken]);
    
    [self registerForRemoteNotifications];

    application.applicationIconBadgeNumber = 0;

    if ([[UserDefaultHandler getUserAccessToken]length]>0)
    {
        [self callToResetNotifications];

        UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
        
        UINavigationController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
        [KAppdelegate.window setRootViewController:tabBarController];
        
    
    }
    else
    {
        
    }

    // Override point for customization after application launch.
   
    return YES;
}

#pragma mark-
#pragma mark : APNS Delegates


- (void)registerForRemoteNotifications{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]){
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    //    else{
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
    //    }
#else
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound];
#endif
}



-(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings // available in iOS8
{
    [application registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString * token = [NSString stringWithFormat:@"%@", deviceToken];
    //Format token :
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSLog(@"%@",token);
    [UserDefaultHandler setDeviceToken:token];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    UIApplicationState state = [application applicationState];
    application.applicationIconBadgeNumber = 0;
    
    NSDictionary*notificationDict=[userInfo valueForKey:@"aps"];

    if (state == UIApplicationStateInactive)
    {
        
        if ([[notificationDict valueForKey:@"type"]isEqualToString:@"group_join_invitation"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=3;
            _notificationType=@"group_join_invitation";

            [KAppdelegate.window setRootViewController:tabBarController];
            
            
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"re_open_group"])
        {
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"new_post_in_group"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=0;
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
           
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_new_post"])
        {
            
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=0;
            KAppdelegate.notificationType=@"friend_new_post";
            [KAppdelegate.window setRootViewController:tabBarController];
            
           
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"group_join_request"])
        {
            
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=3;
            _notificationType=@"group_join_request";
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_request_received"])
        {
         
                    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
                    UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
                    tabBarController.selectedIndex=1;
            
                    [KAppdelegate.window setRootViewController:tabBarController];
            
            
        }
        else if ([[notificationDict valueForKey:@"type"]isEqualToString:@"friend_request_accepted"])
        {
            UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
            
            UITabBarController *tabBarController = [st instantiateViewControllerWithIdentifier:@"MainTabControllerID"];
            tabBarController.selectedIndex=1;
            
            [KAppdelegate.window setRootViewController:tabBarController];
            
           
        }
        
    }
    else if (state == UIApplicationStateActive)
    {
        NSDictionary *options = @{
                                  kCRToastTextKey : [notificationDict valueForKey:@"alert"],
                                  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                                  kCRToastBackgroundColorKey : [UIColor greenColor],
                                  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                                  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
                                  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
                                  };
        [CRToastManager showNotificationWithOptions:options
                                    completionBlock:^{
                                        NSLog(@"Completed");
                                    }];

    }
    
}


-(void)callToResetNotifications
{
    //access_token
    
    NSDictionary* registerInfo = @{
                                   @"access_token":[UserDefaultHandler getUserAccessToken],
                                };
    
    if ([KAppdelegate hasInternetConnection])
    {
        [KSharedParsing wsCallToResetNotifications:registerInfo successBlock:^(BOOL succeeded, NSArray *resultArray) {
            
                      
        } failureBlock:^(BOOL succeeded, NSArray *failureArray)
         {
             
             
         }];
    }
    else
    {
        
    }
    
    
}


-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Error:%@",error);
    [UserDefaultHandler setDeviceToken:@"1e4a119fced63f20be2b5f74df99d3af bbf32b7717ae65da735cfba937970f11"];
    
}

#pragma mark  Loader 

-(void)startLoader:(UIView*)view withTitle:(NSString*)message
{
    [self.window setUserInteractionEnabled:FALSE];
    [GMDCircleLoader setOnView:self.window withTitle:@"" animated:YES];
    
}

- (void)stopLoader:(UIView*)view
{
    [self.window setUserInteractionEnabled:TRUE];
    [GMDCircleLoader hideFromView:self.window animated:YES];
    
}

#pragma mark - Check For Internet Connection

-(BOOL)hasInternetConnection
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    [self stringFromStatus:status];
    if (internetConn)
    {
        return YES;
    }
    else
    {
    }
    return NO;
    
}
#pragma mark - Check Network Status

-(void)stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    switch(status)
    {
        case NotReachable:
            string = @"Not Reachable";
            internetConn=NO;
            break;
        case ReachableViaWiFi:
            string = @"Reachable via WiFi";
            internetConn=YES;
            break;
        case ReachableViaWWAN:
            string = @"Reachable via WWAN";
            internetConn=YES;
            break;
        default:
            string = @"Unknown";
            internetConn=YES;
            break;
    }
    
}



#pragma mark : Url Scheme method

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *,id> *)options
{
    if ([[url absoluteString] rangeOfString:@"fb1701866856509602"].location != NSNotFound)
    {
        //Facebook
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                           annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    else if ([[url absoluteString]containsString:@"com.googleusercontent.apps.15529296705-qucn87jfjmnlr740i01lgp1uoqs1vjgv"]){
        //Google Sign In
        return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }

 
    return YES;
}

-(BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([[url absoluteString] rangeOfString:@"fb1701866856509602"].location != NSNotFound)
    {
        
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else if ([[url absoluteString]containsString:@"com.googleusercontent.apps.15529296705-qucn87jfjmnlr740i01lgp1uoqs1vjgv"]){
        //Google Sign In
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:sourceApplication
                                          annotation:annotation];
    }

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"PhotoBunch"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
