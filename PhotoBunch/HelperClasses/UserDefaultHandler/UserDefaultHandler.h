//
//  UserDefaultHandler.h
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.


#import <Foundation/Foundation.h>



@interface UserDefaultHandler : NSObject

//Aut Token
+(void)setUserAccessToken:(NSString*)accessToken;
+(NSString*)getUserAccessToken;
+(void)removeAccessToken;


//Refresh Token
+(void)setRefreshToken:(NSString*)refreshToken;
+(NSString*)getRefreshToken;
+(void)removeRefreshToken;


//Device Token
+(void)setDeviceToken:(NSString*)deviceToken;
+(NSString*)getDeviceToken;
+(void)removeDeviceToken;


//Device Token
+(void)setUserInfo:(NSDictionary*)userInfo;
+(NSDictionary*)getUserInfo;
+(void)removeUserInfo;


//Device Token
+(void)setFullUserInfoInfo:(NSDictionary*)userInfo;
+(NSDictionary*)getFullInfo;
+(void)removeFullInfo;




@end
