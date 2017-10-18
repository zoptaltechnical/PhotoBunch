//
//  KSPhotoBrowser.h
//  KSPhotoBrowser
//
//  Created by Kyle Sun on 12/25/16.
//  Copyright © 2016 Kyle Sun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSPhotoItem.h"
#import "KSYYImageManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KSPhotoBrowserInteractiveDismissalStyle) {
    KSPhotoBrowserInteractiveDismissalStyleRotation,
    KSPhotoBrowserInteractiveDismissalStyleScale,
    KSPhotoBrowserInteractiveDismissalStyleSlide,
    KSPhotoBrowserInteractiveDismissalStyleNone
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserBackgroundStyle) {
    KSPhotoBrowserBackgroundStyleBlurPhoto,
    KSPhotoBrowserBackgroundStyleBlur,
    KSPhotoBrowserBackgroundStyleBlack
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserPageIndicatorStyle) {
    KSPhotoBrowserPageIndicatorStyleDot,
    KSPhotoBrowserPageIndicatorStyleText
};

typedef NS_ENUM(NSUInteger, KSPhotoBrowserImageLoadingStyle) {
    KSPhotoBrowserImageLoadingStyleIndeterminate,
    KSPhotoBrowserImageLoadingStyleDeterminate
};

@protocol KSPhotoBrowserDelegate, KSImageManager;
@interface KSPhotoBrowser : UIViewController

@property (nonatomic, assign) KSPhotoBrowserInteractiveDismissalStyle dismissalStyle;
@property (nonatomic, assign) KSPhotoBrowserBackgroundStyle backgroundStyle;
@property (nonatomic, assign) KSPhotoBrowserPageIndicatorStyle pageindicatorStyle;
@property (nonatomic, assign) KSPhotoBrowserImageLoadingStyle loadingStyle;
@property (nonatomic, assign) BOOL bounces;
@property (nonatomic, weak) id<KSPhotoBrowserDelegate> delegate;
@property (nonatomic,weak) NSIndexPath*indexPath;

+ (instancetype)browserWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex typesArray:(NSArray*)typesArray  mediaPaths:(NSArray*)mediaPaths allDataDicts:(NSArray*)allDataDicts;
- (instancetype)initWithPhotoItems:(NSArray<KSPhotoItem *> *)photoItems selectedIndex:(NSUInteger)selectedIndex typesArray:(NSArray*)typesArray mediaPaths:(NSArray*)mediaPaths;
- (void)showFromViewController:(UIViewController *)vc;
+ (void)setImageManagerClass:(Class<KSImageManager>)cls;

@end

@protocol KSPhotoBrowserDelegate <NSObject>

- (void)ks_photoBrowser:(KSPhotoBrowser *)browser didSelectItem:(KSPhotoItem *)item atIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
