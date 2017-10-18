//
//  SharedParsing.h
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.


#import <Foundation/Foundation.h>
#import "SingeltonMacro.h"

typedef void (^completionBlock) (BOOL succeeded, NSArray *resultArray);
typedef void (^failureBlock) (BOOL succeeded, NSArray *failureArray);

@interface SharedParsing : NSObject{
    id obj;
}


-(void)assignSender:(id)sender;


// Driver Profile Module 


- (void)wsCallForRegisterUser:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure;

- (void)wsCallToGetAllUsers:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure;
- (void)wsCallToGetAllUsers:(completionBlock)completionBlock
                      failureBlock:(failureBlock)failure;
- (void)wsCallSendFriendRequest:(NSDictionary*)dict
                   successBlock:(completionBlock)completionBlock
                   failureBlock:(failureBlock)failure;

- (void)wsCallLogOut:(NSDictionary*)dict
        successBlock:(completionBlock)completionBlock
        failureBlock:(failureBlock)failure;



- (void)wsCallToGetAllFav:(NSDictionary*)dict
             successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure;


- (void)wsCallAcceptRejectRequest:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure;

- (void)wsCreateGroup:(NSDictionary*)dict
         successBlock:(completionBlock)completionBlock
         failureBlock:(failureBlock)failure;

- (void)wsCallToGetAllFriends:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure;

- (void)wsCallToGetGroupWallPosts:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure;



- (void)wsCallToGetFeaturedGroups:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure;


- (void)wsCallToGetFriendsWallPosts:(NSDictionary*)dict
                       successBlock:(completionBlock)completionBlock
                       failureBlock:(failureBlock)failure;

- (void)wsCreatePost:(NSDictionary*)dict
        successBlock:(completionBlock)completionBlock
        failureBlock:(failureBlock)failure;

- (void)wsGetGroups:(NSDictionary*)dict
       successBlock:(completionBlock)completionBlock
       failureBlock:(failureBlock)failure;


- (void)wsGetOpenGroups:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure;
- (void)wsGetDiscoverGroups:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure;


- (void)wsCallToGetGroupDetail:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure;


- (void)wsCallToJoinOrUnJoinGroup:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure;



- (void)wsCallToGetPostDetail:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure;

- (void)wsCallToGetGroupPosts:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure;


- (void)wsCallToGetUserProfile:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure;

- (void)wsCallToGetUserProfilePosts:(NSDictionary*)dict
                       successBlock:(completionBlock)completionBlock
                       failureBlock:(failureBlock)failure;
- (void)wsCallUpdateProfile:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure;


- (void)wsCallToMakeFav:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure;


- (void)wsGetJoinGroupReqs:(NSDictionary*)dict
              successBlock:(completionBlock)completionBlock
              failureBlock:(failureBlock)failure;

- (void)wsAcceptOrRejectGroupReq:(NSDictionary*)dict
              successBlock:(completionBlock)completionBlock
              failureBlock:(failureBlock)failure;


- (void)wsCallSendJoinGroupReq:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure;


- (void)wsCallToGetFriendProfile:(NSDictionary*)dict
                    successBlock:(completionBlock)completionBlock
                    failureBlock:(failureBlock)failure;


- (void)wsCallForUpdateQuickBlox:(NSDictionary*)dict
                    successBlock:(completionBlock)completionBlock
                    failureBlock:(failureBlock)failure;


- (void)wsCallToGetUserFriendPosts:(NSDictionary*)dict
                      successBlock:(completionBlock)completionBlock
                      failureBlock:(failureBlock)failure;


- (void)wsCallToGetNotificaions:(NSDictionary*)dict
                   successBlock:(completionBlock)completionBlock
                   failureBlock:(failureBlock)failur;

- (void)wsCallSendUnfriendRequest:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure;

- (void)wsCallToMakeUNFav:(NSDictionary*)dict
             successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure;



- (void)wsCallToSearchUser:(NSDictionary*)dict
              successBlock:(completionBlock)completionBlock
              failureBlock:(failureBlock)failure;
- (void)wsCallToGetAllFriendReqs:(NSDictionary*)dict
                    successBlock:(completionBlock)completionBlock
                    failureBlock:(failureBlock)failure;


- (void)wsCallToDeleteGroup:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure;
- (void)wsCallToResetNotifications:(NSDictionary*)dict
                      successBlock:(completionBlock)completionBlock
                      failureBlock:(failureBlock)failure;

- (void)wsCallToDeletePost:(NSDictionary*)dict
              successBlock:(completionBlock)completionBlock
              failureBlock:(failureBlock)failure;


- (void)wsSearchGroups:(NSDictionary*)dict
          successBlock:(completionBlock)completionBlock
          failureBlock:(failureBlock)failure;

- (void)wsCallReactivateGroup:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure;
- (void)wsCallToDeleteGroupMemberFromGroup:(NSDictionary*)dict
                              successBlock:(completionBlock)completionBlock
                              failureBlock:(failureBlock)failure;


- (void)wsSearchScanGroup:(NSDictionary*)dict
             successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure;

- (void)wsCallReportSpam:(NSDictionary*)dict
            successBlock:(completionBlock)completionBlock
            failureBlock:(failureBlock)failure;



- (void)wsBlockUser:(NSDictionary*)dict
       successBlock:(completionBlock)completionBlock
       failureBlock:(failureBlock)failure;


- (void)wsGetBlockList:(NSDictionary*)dict
          successBlock:(completionBlock)completionBlock
          failureBlock:(failureBlock)failure;

SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SharedParsing);


@end

