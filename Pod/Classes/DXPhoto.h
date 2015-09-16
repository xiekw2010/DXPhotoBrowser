//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol DXPhoto <NSObject>

typedef void (^DXPhotoProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);
typedef void (^DXPhotoCompletionBlock)(id<DXPhoto>, UIImage *image);

@required

- (void)loadImageWithProgressBlock:(DXPhotoProgressBlock)progressBlock
                   completionBlock:(DXPhotoCompletionBlock)completionBlock;


@optional

- (UIImage *)placeholder;

- (void)cancelLoadImage;

/**
 *  Uses animation for expand and shrink, if not provide default is screenBounds.
 *  Uses pixels size instead of point
 *
 *  @return an expectLoadedImageSize;
 */
- (CGSize)expectLoadedImageSize;

@end


