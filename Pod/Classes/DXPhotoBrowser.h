//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXPhoto.h"

@protocol DXPhotoBrowserDelegate;
@class DXPullToDetailView;

@interface DXPhotoBrowser : NSObject

/**
 *  Desigated intializer
 *
 *  @param photosArray an array of id<DXPhoto>
 *
 */
- (instancetype)initWithPhotosArray:(NSArray *)photosArray;

@property (nonatomic, strong, readonly) NSArray *photosArray;

// if you imp the delegate method "simplePhotoBrowserDidTriggerPullToRightEnd:", then maybe you need to set the text
@property (nonatomic, strong, readonly) DXPullToDetailView *pullToRightControl;

// if current photos.count > 10, it will hidden
@property (nonatomic, strong, readonly) UIPageControl *pageControl;

@property (nonatomic, weak) id<DXPhotoBrowserDelegate> delegate;

/**
 *  The showing photo api
 *
 *  @param index         the index of within the photosArray
 *  @param thumbnailView the animation from view, if set to nil, it will display without the expand animation
 */
- (void)showPhotoAtIndex:(NSUInteger)index withThumbnailImageView:(UIView *)thumbnailView;
- (void)hide;

@end

@protocol DXPhotoBrowserDelegate <NSObject>

@optional
/**
 *
 *  如果要改变当前statusBarStyle的话, 这些delegate可以用到。
 *  记得在info.plist里添加`UIViewControllerBasedStatusBarAppearance == NO`
 *
 */
- (void)simplePhotoBrowserWillShow:(DXPhotoBrowser *)photoBrowser;

- (void)simplePhotoBrowserDidShow:(DXPhotoBrowser *)photoBrowser;

- (void)simplePhotoBrowserWillHide:(DXPhotoBrowser *)photoBrowser;

- (void)simplePhotoBrowserDidHide:(DXPhotoBrowser *)photoBrowser;

- (void)simplePhotoBrowserDidTriggerPullToRightEnd:(DXPhotoBrowser *)photoBrowser;

@end
