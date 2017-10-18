//
//  SingletonClass.h
//  Atlas
//
//  Created by Gaurav Singh on 7/23/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef void (^completion) (UIImage *image);
typedef void (^failure) (UIImage *image);
typedef void (^imageSuccessBlock) (UIImage *previewImage);
typedef void (^completionHandler) (BOOL succeeded,NSMutableArray *array);
typedef void (^resultBlock) (NSMutableDictionary *mDict);

@interface SingletonClass : NSObject

@property (strong) NSString *str_DeviceToken;
@property (strong) NSString *notificationID;

#pragma mark - Shared Instance
+(instancetype)sharedInstance;

@property (nonatomic,strong) NSMutableArray *bibblesArray;
@property (nonatomic,strong) NSMutableDictionary *profileDict;
@property (nonatomic,strong) NSMutableArray  *categroiesArray;
@property (assign) BOOL  isTopicSearch;

#pragma mark - Show Alert/Label
-(void)showAlert:(NSString*)msg withDelegate:(UIViewController*)delegate withCancelTitle:(NSString*)cancel otherTitle:(NSString*)otherTitle;
-(void)showNoDataLabel:(UIViewController *)delegate;
-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width;

#pragma mark - Check for Internet
-(BOOL)checkForInternetConnection;

#pragma mark - Download and Get Image
-(void)downloadImage:(NSString*)photoPath  onCompletion:(completion)completion onFailure:(failure)failure;

#pragma mark - Get Date/String
-(NSString*)validStringDateFormate:(NSString*)dateString;
-(NSDate*)dateFormStringPrefield:(NSString*)dateStr;
-(NSString*)getPostTime:(NSString *)createdAt updatedAt:(NSString*)updateTime;

#pragma mark - Get String Height
-(float) calculateHeightOfText:(NSString*)text withFont:(UIFont*)font withWidth:(float)width;

#pragma mark - Validations Methods
-(BOOL)validateEmail:(NSString*)strEmail;
-(BOOL)AlphabetsValidation:(NSString*)str;
-(BOOL)AlphaNumericValidation:(NSString*)str;
-(BOOL)AlphaNumericWirhSpecialCharValidation:(NSString*)str;
-(BOOL)NumericValidation:(NSString*)str;

#pragma mark - MD5 Encription
- (NSString*)md5HexDigest:(NSString*)input;

#pragma mark - Media Upload
-(void)wsCallForMediaUpload:(NSString*)bibbleID withMedia:(NSMutableArray*)selectedMediaItemsArray;
//-(void)showBottomToastWithText:(NSString *)message;
//-(void)showCenterToastWithText:(NSString *)message;
@end
