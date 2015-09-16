//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DXZoomingScrollView, DXTapDetectingImageView;
@protocol DXPhoto;

@protocol DXZoomingScrollViewDelegate <NSObject>

- (void)zoomingScrollViewSingleTapped:(DXZoomingScrollView *)zoomingScrollView;

@end

@interface DXZoomingScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, strong) id<DXPhoto> photo;
@property (nonatomic, weak, readonly) id<DXZoomingScrollViewDelegate>zoomDelegate;
@property (nonatomic, strong, readonly) DXTapDetectingImageView *imageView;

- (id)initWithDelegate:(id<DXZoomingScrollViewDelegate>)delegate;
- (void)prepareForReuse;

@end
