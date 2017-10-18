//
//  SingletonClass.m
//  Atlas
//
//  Created by Gaurav Singh on 7/23/15.
//  Copyright (c) 2015 Sandeep Kumar. All rights reserved.
//

#import "SingletonClass.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "Constant.h"

#define ACCEPTABLE_CHARACTERS @"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define ALPHANUMERIC @"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ -0123456789"
#define ALPHANUMERIC_WITHSPECIALCHARACTER @"abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ -0123456789()#,""/"
#define NUMERICE @"0123456789+(),"

@implementation SingletonClass
@synthesize bibblesArray,categroiesArray;
#pragma mark - Shared Instance
+(instancetype)sharedInstance
{
    static SingletonClass *_sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedInstance = [[SingletonClass alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - Show Alert/Label
-(void)showAlert:(NSString*)msg withDelegate:(UIViewController*)delegate withCancelTitle:(NSString*)cancel otherTitle:(NSString*)otherTitle
{
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"Photobunch" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction
                               actionWithTitle:NSLocalizedString(cancel, @"Cancel action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {

                                   }];
    [alertController addAction:action1];

    if (otherTitle)
    {
        UIAlertAction *action2 = [UIAlertAction
                                  actionWithTitle:NSLocalizedString(otherTitle, @"Ok action")
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *action)
                                  {

                                  }];
        [alertController addAction:action2];
    }

    [delegate presentViewController:alertController animated:YES completion:NULL];
}



-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    /* UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
     [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
     UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     return newImage;*/
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //  UIImage* newImage=[self compressImage:img];
    // NSData *imageData = UIImageJPEGRepresentation(img, 1);
    //UIImage* newImage=[UIImage imageWithData:imageData];
    
    UIGraphicsEndImageContext();
    return newImage;;
}

-(void)showNoDataLabel:(UIViewController *)delegate
{
    UILabel *noDataLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,170, 50)];
//    [noDataLabel setTextColor:KTextBlueColor];
//    noDataLabel.font=OpenSans_SemiBold(15);
    noDataLabel.text=@"No Data Available";
    noDataLabel.tag= 555;
    noDataLabel.backgroundColor=[UIColor clearColor];
    noDataLabel.center=delegate.view.center;
    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [delegate.view addSubview:noDataLabel];
}

#pragma mark - Check for Internet
-(BOOL)checkForInternetConnection
{
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection]currentReachabilityStatus];
    BOOL isInternetActive = YES;
    if(netStatus == NotReachable)
        isInternetActive = NO;
    return isInternetActive;
}

#pragma mark - Download and Get Image
-(void)downloadImage:(NSString*)photoPath  onCompletion:(completion)completion onFailure:(failure)failure
{
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        NSURL *imageURL=[NSURL URLWithString:[photoPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSData *tempData=[NSData dataWithContentsOfURL:imageURL];
        UIImage *tImage=[UIImage imageWithData:tempData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (tImage==nil)
                failure(tImage);
            else
                completion(tImage);
        });
    });
}

#pragma mark - Get Date/String
-(NSString*)validStringDateFormate:(NSString*)dateString
{
    //Getting date from string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [[NSDate alloc] init];
    date = [dateFormatter dateFromString:dateString];
    // converting into our required date format
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *reqDateString = [dateFormatter stringFromDate:date];
    NSLog(@"date is %@", reqDateString);
    return reqDateString;
}

-(NSDate*)dateFormStringPrefield:(NSString*)dateStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [formatter setLocale:[NSLocale systemLocale]];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSDate * date = [formatter dateFromString:dateStr];
    
    return date;
}

-(NSString*)getPostTime:(NSString *)createdAt updatedAt:(NSString*)updateTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //GET START DATE AND END DATE
    NSDate *startDate = [dateFormatter dateFromString:createdAt];
    NSDate *endDate = [dateFormatter dateFromString:updateTime];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    //GET TIME DURATION
    NSTimeInterval distanceBetweenDates = [endDate timeIntervalSinceDate:startDate];
    int totalTimeTaken=distanceBetweenDates;
    int forHours = totalTimeTaken / 3600;
    int  remainder = totalTimeTaken % 3600;
    int  forMinutes = remainder / 60;
    int  forSeconds = remainder % 60;
    NSString *totalTime = @"";
    
    if(forHours == 0 && forMinutes == 0)
    {
        if(forSeconds>30)
            totalTime=[NSString stringWithFormat:@"%dm",1];
        else
            totalTime=[NSString stringWithFormat:@"%ds",forSeconds];
    }
    else
    {
        if(forSeconds>30)
        {
            forMinutes=forMinutes+1;
            if (forMinutes==60)
            {
                forMinutes=0;
                forHours=forHours+1;
            }
        }
        
        if (forHours==0)
            totalTime=[NSString stringWithFormat:@"%dm",forMinutes];
        else if (forHours>24)
        {
            [dateFormatter setDateFormat:@"dd MMM yyyy"];
            NSString *displayDate = [dateFormatter stringFromDate:startDate];
            totalTime=displayDate;
        }
        else
            totalTime=[NSString stringWithFormat:@"%dh %dm",forHours,forMinutes];
    }
    
    return totalTime;
}

#pragma mark - Get String Height
-(float)calculateHeightOfText:(NSString*)text withFont:(UIFont*)font withWidth:(float)width
{
    CGRect suggestedSize = [text boundingRectWithSize:CGSizeMake(width, 999) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:font} context:nil];
    return suggestedSize.size.height;
}


#pragma mark - Validations Methods
-(BOOL)NumericValidation:(NSString*)str
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:NUMERICE] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [str isEqualToString:filtered];
}

-(BOOL)AlphaNumericWirhSpecialCharValidation:(NSString*)str
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUMERIC_WITHSPECIALCHARACTER] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [str isEqualToString:filtered];
}

-(BOOL)AlphabetsValidation:(NSString*)str
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [str isEqualToString:filtered];
}

-(BOOL)AlphaNumericValidation:(NSString*)str
{
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUMERIC] invertedSet];
    
    NSString *filtered = [[str componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [str isEqualToString:filtered];
}

-(BOOL)validateEmail:(NSString*)strEmail
{
    NSString *emailRegex= @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    BOOL valid=[emailTest evaluateWithObject:strEmail];
    return valid;
}

#pragma mark - MD5 Encription
- (NSString*)md5HexDigest:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    strlen(str);
    
    CC_MD5(str, (CC_LONG)strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
        [ret appendFormat:@"%02x",result[i]];
    
    return ret;
}


-(void)deleteMedia:(NSString*)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *folderPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:path];
    
    NSError *error;
    [fileManager removeItemAtPath:folderPath error:&error];
}


@end
