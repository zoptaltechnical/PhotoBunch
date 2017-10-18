//
//  SharedParsing.m
//  Qwykr
//
//  Created by Gorav Grover on 12/9/16.
//  Copyright © 2016 Gorav. All rights reserved.

#import "SharedParsing.h"
#import "Constant.h"
#import <AssetsLibrary/AssetsLibrary.h>


@implementation SharedParsing

SINGLETON_FOR_CLASS(SharedParsing);

-(void)assignSender:(id)sender
{
    obj = sender;
}


/*
 Add Advertisement
 */

- (void)wsCallForRegisterUser:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kRegisterUser];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


- (void)wsCallForUpdateQuickBlox:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kUpdateQuickBlox];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//All Users List
- (void)wsCallToGetAllUsers:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kUsersList];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//All Search Users
- (void)wsCallToSearchUser:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kSearchUser];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}




//FAv List
- (void)wsCallToGetAllFav:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kFavList];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Create Group
- (void)wsCreateGroup:(NSDictionary*)dict
             successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kCreateGroup];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                   
                       [self createNSUrlSessionUploadMedia1:url1 postDict:dict successBlock:completionBlock failureBlock:failure isVideo:NO parameterName:@"group_image" isUpdateProfile:NO];
                   
                   });
}


//Create Post
- (void)wsCreatePost:(NSDictionary*)dict
         successBlock:(completionBlock)completionBlock
         failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kCreatePost];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       if ([[[dict valueForKey:@"parameters"] valueForKey:@"media_type"]isEqualToString:@"Image"])
                       {
                           [self createNSUrlSessionUploadMediaMultiple:url1 postDict:dict successBlock:completionBlock failureBlock:failure isVideo:NO parameterName:@"post_medias"];
                           
                       }
                       else
                       {
                           [self createNSUrlSessionUploadMediaMultiple:url1 postDict:dict successBlock:completionBlock failureBlock:failure isVideo:YES parameterName:@"post_medias"];
  
                       }
                       
                   });
}


//Get Groups
- (void)wsGetGroups:(NSDictionary*)dict
        successBlock:(completionBlock)completionBlock
        failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetGroups];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];

                   });
}
//Get Open Groups
- (void)wsGetOpenGroups:(NSDictionary*)dict
       successBlock:(completionBlock)completionBlock
       failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetOpenGroups];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}
//Get Searched Groups
- (void)wsSearchGroups:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kSearchGroups];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}

//Get Searched Scan Groups
- (void)wsSearchScanGroup:(NSDictionary*)dict
          successBlock:(completionBlock)completionBlock
          failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kScanGroupSearch];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}





//Get Reqs Join Groups
- (void)wsGetJoinGroupReqs:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetGroupJoinReqs];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}

// Accept/Reject
- (void)wsAcceptOrRejectGroupReq:(NSDictionary*)dict
              successBlock:(completionBlock)completionBlock
              failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kAcceptorRejectGroupReq];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}



//Get Open Groups
- (void)wsGetDiscoverGroups:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetDiscoverGroups];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                       
                   });
}




//Friend List
- (void)wsCallToGetAllFriends:(NSDictionary*)dict
             successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kfriends_list];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Friend List
- (void)wsGetBlockList:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kBlockList];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}



//Friend  Req List
- (void)wsCallToGetAllFriendReqs:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kFriendRequest];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}




//MakeFav
- (void)wsCallToMakeFav:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kMakeFav];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}
//MakeUNFav
- (void)wsCallToMakeUNFav:(NSDictionary*)dict
           successBlock:(completionBlock)completionBlock
           failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kMakeUnFav];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}



//Send Friend Request
- (void)wsCallSendFriendRequest:(NSDictionary*)dict
               successBlock:(completionBlock)completionBlock
               failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kSendFriendRequest];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Unfriend
- (void)wsCallSendUnfriendRequest:(NSDictionary*)dict
                   successBlock:(completionBlock)completionBlock
                   failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kunfriend];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Reset Noti

- (void)wsCallToResetNotifications:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kResdNotifications];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//
//Logout
- (void)wsCallLogOut:(NSDictionary*)dict
                   successBlock:(completionBlock)completionBlock
                   failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kLogout];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//Update Profile
- (void)wsCallUpdateProfile:(NSDictionary*)dict
        successBlock:(completionBlock)completionBlock
        failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kUpdateProfile];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionUploadMedia1:url1 postDict:dict successBlock:completionBlock failureBlock:failure isVideo:NO parameterName:@"user_profile" isUpdateProfile:YES];
                   });
}


//Accept Friend Request
- (void)wsCallAcceptRejectRequest:(NSDictionary*)dict
                   successBlock:(completionBlock)completionBlock
                   failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kAcceptRequest];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

- (void)wsCallToGetAllUsers1:(completionBlock)completionBlock
                failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSURL *url1 = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,kUsersList]];
                       [self createNSUrlSessionForGetService:url1 postDict:nil successBlock:completionBlock failureBlock:failure];
                   });
}


//GetGroups Posts

- (void)wsCallToGetGroupWallPosts:(NSDictionary*)dict
                 successBlock:(completionBlock)completionBlock
                 failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGroupWallPosts];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}
//Get Notifications

- (void)wsCallToGetNotificaions:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetNotifications];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}




//Get User Profile

- (void)wsCallToGetUserProfile:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetUserProfile];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Get ReportSpam

- (void)wsCallReportSpam:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetReportSpam];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Get ReportSpam

- (void)wsBlockUser:(NSDictionary*)dict
            successBlock:(completionBlock)completionBlock
            failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kBlockUser];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}



//Get User Profile Posts

- (void)wsCallToGetUserProfilePosts:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetUserProfilePosts];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//Delete POst

- (void)wsCallToDeletePost:(NSDictionary*)dict
                       successBlock:(completionBlock)completionBlock
                       failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kDeleteuserpost];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}



//Get Friend Profile

- (void)wsCallToGetFriendProfile:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetFriendProfile];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Get Friend Profile Posts

- (void)wsCallToGetUserFriendPosts:(NSDictionary*)dict
                       successBlock:(completionBlock)completionBlock
                       failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetFriend_timeline];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//GetGroups Posts

- (void)wsCallToGetFeaturedGroups:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetFeaturedGroups];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//GetGroups details

- (void)wsCallToGetGroupDetail:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetGroupDetail];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//GetGroups Posts

- (void)wsCallToGetGroupPosts:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGetGroupPosts];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}







//Get Post details

- (void)wsCallToGetPostDetail:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kGet_post_detail];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}





//JoinUnjoinGroup

- (void)wsCallToJoinOrUnJoinGroup:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kJoinUnjoinGroup];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//Delete Group Member

- (void)wsCallToDeleteGroupMemberFromGroup:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kDelete_group_members];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//JoinUnjoinGroup

- (void)wsCallToDeleteGroup:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kDeleteGroup];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//Send Join Req

- (void)wsCallSendJoinGroupReq:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kSend_group_join_request];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

//Reactivate Group Join Req

- (void)wsCallReactivateGroup:(NSDictionary*)dict
                  successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,Kre_activate_group];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}


//Get Friends Posts Wall

- (void)wsCallToGetFriendsWallPosts:(NSDictionary*)dict
                     successBlock:(completionBlock)completionBlock
                     failureBlock:(failureBlock)failure
{
    dispatch_async( sharedQueue,
                   ^{
                       NSString*urlStr=[NSString stringWithFormat:@"%@%@",baseUrl,kFriendsWallPosts];
                       NSURL *url1 = [NSURL URLWithString:urlStr];
                       [self createNSUrlSessionLogin:url1 postDict:dict successBlock:completionBlock failureBlock:failure];
                   });
}

#pragma mark - CREATE NSURLSESSION -Method: POST

-(void)createNSUrlSessionLogin:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
                  failureBlock:(failureBlock)failure
{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    
    //[request setHTTPBody:[[dict valueForKey:@"infoStr"] dataUsingEncoding:NSUTF8StringEncoding]];

   // [request addValue:@"Basic Y2xpZW50YXBwOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //Json String
   // NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"URL----->>>>%@",URL);
 ////   NSLog(@"PostDict----->>>>%@",myString);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([data length] > 0 && error == nil)
        {
            
            //                                            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //                                            NSLog(@"result string: %@", newStr);
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"result json: %@", jsonArray);
            
            if (!jsonArray) {
                NSLog(@"Error is %@",[error description]);
                failure(NO,nil);
            }else
            {
                completionBlock(YES,jsonArray);
            }
            
        }
        
        else if ([data length] == 0 && error == nil){
            failure(NO,nil);
        }
        
        else if (error != nil){
            NSLog(@"Error is %@",[error description]);
            failure(NO,nil);
        }
        
    }];
    
    [postDataTask resume];
}


#pragma mark - CREATE NSURLSESSION -Method: POST

-(void)createNSUrlSession:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
             failureBlock:(failureBlock)failure
{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    
    
    NSString *accessToken;
    if ([UserDefaultHandler getUserAccessToken]!=nil)
        accessToken=[NSString stringWithFormat:@"bearer %@",[UserDefaultHandler getUserAccessToken]];
    else
        accessToken = @"Basic Y2xpZW50YXBwOjEyMzQ1Ng==";
    
    [request addValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //Json String
    NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"URL----->>>>%@",URL);
    NSLog(@"PostDict----->>>>%@",myString);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          
                                          {
                                              
                                            //NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                            NSLog(@"result string: %@", newStr);
                                              
                                              
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                              NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                              
                                              if ([httpResponse statusCode]==200||[httpResponse statusCode]==401 ||[httpResponse statusCode]==404 ) {
                                                  if ([data length] > 0 && error == nil)
                                                  {
                                                    //   NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                    //                                            NSLog(@"result string: %@", newStr);
                                                      
                                                      
                                                      NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                      NSLog(@"result json: %@", jsonArray);
                                                      
                                                      if (!jsonArray) {
                                                          NSLog(@"Error is %@",[error description]);
                                                          failure(NO,nil);
                                                      }else
                                                      {
                                                          completionBlock(YES,jsonArray);
                                                      }
                                                      
                                                  }else
                                                  {
                                                        completionBlock(YES,@[@{@"StatusCode":@"200"}]);
                                                  }
                                              }
                                           
                                              else if ([data length] == 0 && error == nil){
                                                  failure(NO,nil);
                                              }
                                              
                                              else if (error != nil){
                                                  NSLog(@"Error is %@",[error description]);
                                                  failure(NO,nil);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}

#pragma mark - CREATE NSURLSESSION -Method: GET

-(void)createNSUrlSessionForGetService:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock failureBlock:(failureBlock)failure
{
     //NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
   // [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   // [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
  //  NSString *accessToken=[NSString stringWithFormat:@"bearer %@",[UserDefaultHandler getUserAccessToken]];
  //  [request addValue:accessToken forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    
     // NSLog(@"Access TOken----->>>>%@",accessToken);
    
    
      //  NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //    //Json String
    //    NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"URL----->>>>%@",URL);
  //  [request setHTTPBody:postData];

    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
                                              if ([data length] > 0 && error == nil)
                                              {
                                                  
                                                  
                                                  //                                            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                  //                                            NSLog(@"result string: %@", newStr);
                                                  
                                                  
                                                  NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                  NSLog(@"result json: %@", jsonArray);
                                                  
                                                  if (!jsonArray) {
                                                      NSLog(@"Error is %@",[error description]);
                                                      failure(NO,nil);
                                                  }else
                                                  {
                                                      completionBlock(YES,jsonArray);
                                                  }
                                                  
                                              }
                                              
                                              else if ([data length] == 0 && error == nil){
                                                  failure(NO,nil);
                                              }
                                              
                                              else if (error != nil){
                                                  NSLog(@"Error is %@",[error description]);
                                                  failure(NO,nil);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}


#pragma mark: upload media

-(void)createNSUrlSessionUploadMedia1:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock failureBlock:(failureBlock)failure isVideo:(BOOL)isVideoUpload parameterName:(NSString*)parameterName isUpdateProfile:(BOOL)isUpdateProfile
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = @"SportuondoFormBoundary";
    
    //  [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //  [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSData *postData;
    if (isVideoUpload)
    {
        postData = [self createBodyWithBoundaryForVideo:boundary parameters:[dict objectForKey:@"parameters"] imageData:[dict objectForKey:@"video"] videoT:[dict objectForKey:@"video_image"]];
        
    }
    else
    {
        
        if (isUpdateProfile)
        {
            NSData*data;
            
            if ([dict objectForKey:@"profile_pic"])
            {
                
                data = UIImagePNGRepresentation([dict objectForKey:@"profile_pic"]);
                
            }
            NSData*data1;
            if ([dict objectForKey:@"cover_pic"])
            {
                
                data1 = UIImagePNGRepresentation([dict objectForKey:@"cover_pic"]);
                
            }
            
            postData=[self createBodyWithBoundaryUpdateProfile:boundary parameters:[dict objectForKey:@"parameters"] imageDataProfile:data paramaterName:@"user_profile" coverImageP:@"user_cover_image" imageDataCover:data1];
        }
        else
        {
            NSData*data;
            
            if ([dict objectForKey:@"profile_pic"])
            {
                
                data = UIImagePNGRepresentation([dict objectForKey:@"profile_pic"]);
                
            }
            
            postData = [self createBodyWithBoundary:boundary parameters:[dict objectForKey:@"parameters"] imageData:data paramaterName:parameterName];

        }
        
    }
    
    [request setHTTPBody:postData];
    
    //  //Json String
    // NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([data length] > 0 && error == nil)
        {
            
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"result json: %@", jsonArray);
            
            if (!jsonArray)
            {
                NSLog(@"Error is %@",[error description]);
                failure(NO,nil);
            }
            else
            {
                completionBlock(YES,jsonArray);
            }
            
        }
        
        else if ([data length] == 0 && error == nil)
        {
            failure(NO,nil);
        }
        
        else if (error != nil)
        {
            NSLog(@"Error is %@",[error description]);
            failure(NO,nil);
        }
        
    }];
    
    [postDataTask resume];
}

- (NSData *)createBodyWithBoundaryForVideo:(NSString *)boundary parameters:(NSDictionary *)parameters imageData:(NSData*)data videoT:(NSData*)videoT
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
  //  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];

    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    

    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"video", @"1.mov"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", @"video_image", @"1.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:videoT];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}
- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters imageData:(NSData*)imagedata paramaterName:(NSString*)parameterNAmeForImage
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    if (imagedata)
    {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", parameterNAmeForImage, @"1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:imagedata];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    // }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}
- (NSData *)createBodyWithBoundaryUpdateProfile:(NSString *)boundary
                        parameters:(NSDictionary *)parameters imageDataProfile:(NSData*)imagedataProfile paramaterName:(NSString*)parameterNAmeForImage coverImageP:(NSString*)coverImageP imageDataCover:(NSData*)imagedataCover
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    if (imagedataProfile)
    {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", parameterNAmeForImage, @"1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:imagedataProfile];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    if (imagedataCover)
    {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", coverImageP, @"1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:imagedataCover];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    // }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}



#pragma mark - CREATE NSURLSESSION -Method: PUT

-(void)createNSUrlSessionForUpdates:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
                       failureBlock:(failureBlock)failure
{
    NSError *error;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"PUT"];
    
    NSString *accessToken=[NSString stringWithFormat:@"bearer %@",[UserDefaultHandler getUserAccessToken]];
    [request addValue:accessToken forHTTPHeaderField:@"Authorization"];
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    //Json String
    NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    NSLog(@"URL----->>>>%@",URL);
    NSLog(@"PostDict----->>>>%@",myString);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          
                                          {
                                              
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                              NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                              
                                              if ([httpResponse statusCode]==200||[httpResponse statusCode]==401) {
                                                  if ([data length] > 0 && error == nil)
                                                  {
                                                      //   NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                      //                                            NSLog(@"result string: %@", newStr);
                                                      
                                                      
                                                      NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                      NSLog(@"result json: %@", jsonArray);
                                                      
                                                      if (!jsonArray) {
                                                          NSLog(@"Error is %@",[error description]);
                                                          failure(NO,nil);
                                                      }else
                                                      {
                                                          completionBlock(YES,jsonArray);
                                                      }
                                                      
                                                  }else
                                                  {
                                                      completionBlock(YES,@[@{@"StatusCode":@"200"}]);
                                                  }
                                              }
                                              
                                              else if ([data length] == 0 && error == nil){
                                                  failure(NO,nil);
                                              }
                                              
                                              else if (error != nil){
                                                  NSLog(@"Error is %@",[error description]);
                                                  failure(NO,nil);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}


#pragma mark - CREATE NSURLSESSION -Method: Delete

-(void)createNSUrlSessionForDeleteService:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
                          failureBlock:(failureBlock)failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSString *accessToken=[NSString stringWithFormat:@"bearer %@",[UserDefaultHandler getUserAccessToken]];
    [request addValue:accessToken forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"DELETE"];

    NSLog(@"URL----->>>>%@",URL);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          
                                          {
                                              
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                                              NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
                                              
                                              if ([httpResponse statusCode]==200||[httpResponse statusCode]==401) {
                                                  if ([data length] > 0 && error == nil)
                                                  {
                                                      //   NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                      //                                            NSLog(@"result string: %@", newStr);
                                                      
                                                      
                                                      NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                      NSLog(@"result json: %@", jsonArray);
                                                      
                                                      if (!jsonArray) {
                                                          NSLog(@"Error is %@",[error description]);
                                                          failure(NO,nil);
                                                      }else
                                                      {
                                                          completionBlock(YES,jsonArray);
                                                      }
                                                      
                                                  }else
                                                  {
                                                      completionBlock(YES,@[@{@"StatusCode":@"200"}]);
                                                  }
                                              }
                                              
                                              else if ([data length] == 0 && error == nil){
                                                  failure(NO,nil);
                                              }
                                              
                                              else if (error != nil){
                                                  NSLog(@"Error is %@",[error description]);
                                                  failure(NO,nil);
                                              }
                                              
                                          }];
    
    [postDataTask resume];
}

# pragma mark:Create NSURLSESSION:Refresh token

-(void)createNSUrlSessionRefreshToken:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock
                         failureBlock:(failureBlock)failure
{
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Basic Y2xpZW50YXBwOjEyMzQ1Ng==" forHTTPHeaderField:@"Authorization"];
    
    NSString *post =[NSString stringWithFormat:@"refresh_token=%@&grant_type=%@",[dict valueForKey:@"refresh_token"],[dict valueForKey:@"grant_type"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    //    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    
    //Json String
    //    NSString * myString = [[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding];
    //    NSLog(@"URL----->>>>%@",URL);
    //    NSLog(@"PostDict----->>>>%@",myString);
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([data length] > 0 && error == nil)
        {
            
            //        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //        NSLog(@"result string: %@", newStr);
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSLog(@"result json: %@", jsonArray);
            
            if (!jsonArray) {
                NSLog(@"Error is %@",[error description]);
                failure(NO,nil);
            }else
            {
                completionBlock(YES,jsonArray);
            }
            
        }
        
        else if ([data length] == 0 && error == nil){
            failure(NO,nil);
        }
        
        else if (error != nil){
            NSLog(@"Error is %@",[error description]);
            failure(NO,nil);
        }
        
    }];
    
    [postDataTask resume];
}

//MultipleUploads

-(void)createNSUrlSessionUploadMediaMultiple:(NSURL*)URL postDict:(NSDictionary*)dict successBlock:(completionBlock)completionBlock failureBlock:(failureBlock)failure isVideo:(BOOL)isVideoUpload parameterName:(NSString*)parameterName
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSString *boundary = @"SportuondoFormBoundary";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSData *postData;
    if (isVideoUpload)
    {
        NSData*imagedata1 =UIImageJPEGRepresentation([[dict objectForKey:@"profile_pic"] objectAtIndex:1],1.0);

        postData = [self createBodyWithBoundaryForVideoMultiple:boundary parameters:[dict objectForKey:@"parameters"] imageData:[[dict objectForKey:@"profile_pic"] objectAtIndex:0] videoT:imagedata1];
        
    }
    else
    {
        
        postData = [self createBodyWithBoundaryMultiple:boundary parameters:[dict objectForKey:@"parameters"] imageData:[dict objectForKey:@"profile_pic"] paramaterName:parameterName];
        
    }
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if ([data length] > 0 && error == nil)
        {
            
            
            NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            NSLog(@"result json: %@", jsonArray);
            
            if (!jsonArray)
            {
                NSLog(@"Error is %@",[error description]);
                failure(NO,nil);
            }
            else
            {
                completionBlock(YES,jsonArray);
            }
            
        }
        
        else if ([data length] == 0 && error == nil)
        {
            failure(NO,nil);
        }
        
        else if (error != nil)
        {
            NSLog(@"Error is %@",[error description]);
            failure(NO,nil);
        }
        
    }];
    
    [postDataTask resume];
}
- (NSData *)createBodyWithBoundaryForVideoMultiple:(NSString *)boundary parameters:(NSDictionary *)parameters imageData:(NSData*)data videoT:(NSData*)videoT
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    // ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[0]\"; filename=\"%@\"\r\n", @"post_medias", @"1.mov"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:data];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[0]\"; filename=\"%@\"\r\n", @"media_thumb", @"1.png"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
    [httpBody appendData:videoT];
    [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    
    // }
    
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}
- (NSData *)createBodyWithBoundaryMultiple:(NSString *)boundary
                        parameters:(NSDictionary *)parameters imageData:(NSArray*)imagedata paramaterName:(NSString*)parameterNAmeForImage
{
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    
        NSData*imagedata1 =UIImageJPEGRepresentation([imagedata objectAtIndex:0],0.7);
        NSData*videoT =UIImageJPEGRepresentation([imagedata objectAtIndex:1],0.7);

            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[0]\"; filename=\"%@\"\r\n", parameterNAmeForImage, @"1.jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:imagedata1];
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            
            [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@[0]\"; filename=\"%@\"\r\n", @"media_thumb", @"1.png"] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", @"multipart/form-data"] dataUsingEncoding:NSUTF8StringEncoding]];
            [httpBody appendData:videoT];
            [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
   
        [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return httpBody;
}


@end
