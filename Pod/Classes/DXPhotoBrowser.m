//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "DXPhotoBrowser.h"
#import "UIView+DXScreenShot.h"
#import "UIImage+DXAppleBlur.h"
#import "DXPullToDetailView.h"
#import "DXZoomingScrollView.h"
#import "DXTapDetectingImageView.h"
#import "DXTapDetectingView.h"

static const CGFloat kPadding = 10.0;

static inline NSTimeInterval durationToAnimate(CGFloat pointsToAnimate, CGFloat velocity) {
    NSTimeInterval animationDuration = pointsToAnimate / ABS(velocity);
    return animationDuration;
}

static inline CGSize screenRatioSize(CGSize fullScreenSize, CGSize originViewSize) {
    CGFloat x, X, y, Y, rx, ry;
    
    x = originViewSize.width, X = fullScreenSize.width;
    y = originViewSize.height, Y = fullScreenSize.height;
    
    if (x == 0 || y == 0) {
        return CGSizeZero;
    }
    
    // we use the bigger ratio
    if (x / X > y / Y) {
        rx = X;
        ry = X / x * y;
    } else {
        ry = Y;
        rx = Y / y * x;
    }
    
    if (x <= X) {
        rx = x;
        if (y <= Y) {
            ry = y;
        } else {
            ry = rx / x * y;
        }
    }
    
    return CGSizeMake(rx, ry);
}

@interface DXPhotoBrowser ()<UIScrollViewDelegate, DXZoomingScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceView;
@property (nonatomic, strong, readonly) UIView *fullcreenView;
@property (nonatomic, strong, readonly) UIControl *backgroundView;

// if current photos.count > 10, it will hidden
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  Default is 0.3
 */
@property (nonatomic, assign) CGFloat flyInAnimationDuration;

/**
 *  Default is 0.3
 */
@property (nonatomic, assign) CGFloat flyOutAnimationDuration;


@end

@implementation DXPhotoBrowser {
    UIView *_fullscreenView;
    UIControl *_backgroundView;
    UIScrollView *_pagingScrollView;
    NSMutableSet *_visiblePages, *_recycledPages;
    NSUInteger _currentPageIndex;
    NSUInteger _photoCount;
    DXPullToDetailView *_pullToRightControl;
    UIPanGestureRecognizer *_dismissPanGesture;
    NSArray *_photosArray;
    CGRect _sourceViewHereFrame;
    CGFloat _startShowingIndex;
    BOOL _isiOS7;
    struct {
        unsigned int delegateImpWillShowObj:1;
        unsigned int delegateImpDidShowObj:1;
        unsigned int delegateImpWillHideObj:1;
        unsigned int delegateImpDidHideObj:1;
        unsigned int delegateImpTriggerPullToRight:1;
    } _delegateFlags;
    
    UIImage *_fakeAnimationPlaceholder;
    UIImageView *_fakeAnimationImageView;
}

@synthesize fullcreenView = _fullscreenView, backgroundView = _backgroundView;

#pragma -mark lifecycle
- (void)dealloc {
    [_fullscreenView removeFromSuperview];
    [_backgroundView removeFromSuperview];
    _delegate = nil;
}

- (instancetype)init {
    NSAssert(NO, @"Please use initWithPhotosArray: instead");
    
    return nil;
}

- (void)commonInit {
    UIViewAutoresizing autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    
    self.flyInAnimationDuration = 0.3;
    self.flyOutAnimationDuration = 0.3;
    self.bouncingAnimation = YES;
    
    _isiOS7 = [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending;
    
    _fullscreenView = [[UIView alloc] init];
    [_fullscreenView setAutoresizingMask:autoresizingMask];
    
    _backgroundView = [[UIControl alloc] init];
    [_backgroundView setAutoresizingMask:autoresizingMask];
    [_backgroundView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.8]];
    [_backgroundView addTarget:self action:@selector(hide)
              forControlEvents:UIControlEventTouchUpInside];
    
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = autoresizingMask;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor clearColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    _pullToRightControl = [[DXPullToDetailView alloc] initWithFrame:_pagingScrollView.bounds];
    _pullToRightControl.releasingText = @"请配置释放文案";
    _pullToRightControl.pullingText = @"请配置滑动文案";
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.userInteractionEnabled = NO;
    
    //recycle staff
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _photoCount = NSNotFound;
    _currentPageIndex = 0;
    
    _dismissPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    _dismissPanGesture.maximumNumberOfTouches = 1;
    _dismissPanGesture.minimumNumberOfTouches = 1;

    _delegateFlags.delegateImpWillShowObj = 0;
    _delegateFlags.delegateImpDidShowObj = 0;
    _delegateFlags.delegateImpWillHideObj = 0;
    _delegateFlags.delegateImpDidHideObj = 0;
    _delegateFlags.delegateImpTriggerPullToRight = 0;
}

- (instancetype)initWithPhotosArray:(NSArray *)photosArray {
    if (self = [super init]) {
        [self commonInit];
        _photosArray = photosArray;
    }

    return self;
}

- (void)setDelegate:(id<DXPhotoBrowserDelegate>)delegate {
    if (_delegate != delegate) {
        
        _delegateFlags.delegateImpWillShowObj
            = [delegate respondsToSelector:@selector(simplePhotoBrowserWillShow:)];
        
        _delegateFlags.delegateImpDidShowObj
            = [delegate respondsToSelector:@selector(simplePhotoBrowserDidShow:)];
        
        _delegateFlags.delegateImpWillHideObj
            = [delegate respondsToSelector:@selector(simplePhotoBrowserWillHide:)];
        
        _delegateFlags.delegateImpDidHideObj
            = [delegate respondsToSelector:@selector(simplePhotoBrowserDidHide:)];
        
        _delegateFlags.delegateImpTriggerPullToRight
            = [delegate respondsToSelector:@selector(simplePhotoBrowserDidTriggerPullToRightEnd:)];
        
        _delegate = delegate;
    }
}

#pragma -mark scrollView events
- (CGRect)frameForPagingScrollView {
    CGRect frame = [_fullscreenView bounds];
    frame.origin.x -= kPadding;
    frame.size.width += (2 * kPadding);
    
    return CGRectIntegral(frame);
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index * pageWidth;
    
    return CGPointMake(newOffset, 0);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * kPadding);
    pageFrame.origin.x = (bounds.size.width * index) + kPadding;
    
    return CGRectIntegral(pageFrame);
}

- (NSUInteger)numberOfPhotos {
    return _photosArray.count;
}

- (void)resetPagingScrollView {
    // Reset
    _photoCount = NSNotFound;
    
    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    
    // Update current page index
    if (numberOfPhotos > 0) {
        _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
    } else {
        _currentPageIndex = 0;
    }
    
    // Update layout
    while (_pagingScrollView.subviews.count) {
        [[_pagingScrollView.subviews lastObject] removeFromSuperview];
    }
    
    // Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    [_pagingScrollView setFrame:[self frameForPagingScrollView]];
    [_pagingScrollView setContentSize:[self contentSizeForPagingScrollView]];
    [_pagingScrollView setAlpha:0.0];
    _pagingScrollView.delegate = self;
}

- (void)tilePages {
    // Calculate which pages should be visible
    // Ignore padding as paging bounces encroach on that
    // and lead to false page loads
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger firstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds) + kPadding * 2) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex = (NSInteger)floorf((CGRectGetMaxX(visibleBounds) - kPadding * 2 - 1) / CGRectGetWidth(visibleBounds));
    
    if (firstIndex < 0) firstIndex = 0;
    if (firstIndex > [self numberOfPhotos] - 1) firstIndex = [self numberOfPhotos] - 1;
    if (lastIndex < 0) lastIndex = 0;
    if (lastIndex > [self numberOfPhotos] - 1) lastIndex = [self numberOfPhotos] - 1;
    
    // Recycle no longer needed pages
    NSInteger pageIndex;
    for (DXZoomingScrollView *page in _visiblePages) {
        pageIndex = page.index;
        if (pageIndex < firstIndex || pageIndex > lastIndex) {
            [_recycledPages addObject:page];
            [page prepareForReuse];
            [page removeFromSuperview];
        }
    }
    
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 3) // Only keep 3 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
    // Add missing pages
    for (NSUInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            // Add new page
            DXZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[DXZoomingScrollView alloc] initWithDelegate:self];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];
            [_pagingScrollView addSubview:page];
        }
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for (DXZoomingScrollView *page in _visiblePages)
        if (page.index == index) return YES;
    
    return NO;
}

- (DXZoomingScrollView *)dequeueRecycledPage {
    DXZoomingScrollView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    
    return page;
}

- (void)configurePage:(DXZoomingScrollView *)page forIndex:(NSUInteger)index {
    page.frame = [self frameForPageAtIndex:index];
    page.index = index;
    
    if (index == _startShowingIndex) {
        id<DXPhoto> photo = [self photoAtIndex:index];
        UIImage *placeholder = [photo respondsToSelector:@selector(placeholder)] ? [photo placeholder] : nil;
        if (!placeholder && _fakeAnimationPlaceholder) {
            placeholder = _fakeAnimationPlaceholder;
            page.placeholder = placeholder;
        }
    }
    page.photo = [self photoAtIndex:index];
}

- (id<DXPhoto>)photoAtIndex:(NSUInteger)index {
    id<DXPhoto> cellObj = nil;
    if (index < _photosArray.count) {
        cellObj = _photosArray[index];
    }
    if (![cellObj conformsToProtocol:@protocol(DXPhoto)]) {
        NSLog(@"DXPhotoBrowser photos array object at index %lu does conforms to protocol <HRPhoto>", (unsigned long)index);
        return nil;
    }
    return cellObj;
}

- (DXZoomingScrollView *)pageAtIndex:(NSUInteger)index {
    for (DXZoomingScrollView *page in _visiblePages) {
        if (page.index == _currentPageIndex) {
            return page;
        }
    }
    return nil;
}

- (BOOL)isSatisfiedJumpWithScrollView:(UIScrollView *)scrollView {
    BOOL satisfy
    = (scrollView.contentOffset.x + CGRectGetWidth(scrollView.bounds)
       - scrollView.contentSize.width > 60.0);
    return satisfy;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self tilePages];
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
    _currentPageIndex = index;
    _pageControl.currentPage = _currentPageIndex;
    
    // moved 60.0
    if ([self isSatisfiedJumpWithScrollView:scrollView]) {
        if (scrollView.isDragging == YES) {
            [_pullToRightControl setPulling:YES animated:YES];
        }else {
            // iOS6 当pageEnabled == YES的时候无法判断速度, 这里降级处理
            if (!_isiOS7) {
                if (_delegateFlags.delegateImpTriggerPullToRight) {
                    [self hideAnimated:NO];
                    scrollView.delegate = nil;
                    [self.delegate simplePhotoBrowserDidTriggerPullToRightEnd:self];
                }
            }
        }
    }else {
        [_pullToRightControl setPulling:NO animated:YES];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self isSatisfiedJumpWithScrollView:scrollView]) {
        if (velocity.x < 1.0) {
            if (_delegateFlags.delegateImpTriggerPullToRight) {
                [self hideAnimated:NO];
                scrollView.delegate = nil;
                [self.delegate simplePhotoBrowserDidTriggerPullToRightEnd:self];
            }
        }
    }
}

- (void)tilePagesAtIndex:(NSUInteger)index {
    CGRect bounds = _pagingScrollView.bounds;
    bounds.origin.x = [self contentOffsetForPageAtIndex:index].x;
    _pagingScrollView.bounds = bounds;
    _currentPageIndex = index;
    
    _pageControl.numberOfPages = [self numberOfPhotos];
    _pageControl.currentPage = _currentPageIndex;
    _pageControl.hidden = _pageControl.numberOfPages <= 1;
    [_pageControl sizeToFit];
    CGPoint pageCenter = _pagingScrollView.center;
    pageCenter.y = CGRectGetHeight(_pagingScrollView.bounds) - CGRectGetHeight(_pageControl.bounds);
    _pageControl.center = pageCenter;
    [self tilePages];
}

- (void)handlePan:(id)sender {
    // Initial Setup
    DXZoomingScrollView *scrollView = [self pageAtIndex:_currentPageIndex];
    static CGFloat firstX, firstY;
    CGFloat viewHeight = scrollView.frame.size.height;
    CGFloat viewHalfHeight = viewHeight / 2;
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:_fullscreenView
                               ];
    CGPoint velocity = [(UIPanGestureRecognizer*)sender velocityInView:_fullscreenView];
    // Gesture Began
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        firstX = [scrollView center].x;
        firstY = [scrollView center].y;
    }
    
    translatedPoint = CGPointMake(firstX, firstY+translatedPoint.y);
    [scrollView setCenter:translatedPoint];
    CGFloat newY = scrollView.center.y - viewHalfHeight;
    CGFloat newAlpha = 1 - ABS(newY) / viewHeight;
    
    _backgroundView.opaque = YES;
    _backgroundView.alpha = newAlpha;
    
    // Gesture Ended
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        CGFloat autoDismissOffset = 50.0;
        // if moved > autoDismissOffset
        if (scrollView.center.y > viewHalfHeight + autoDismissOffset
            || scrollView.center.y < viewHalfHeight - autoDismissOffset) {
            
            if (_sourceView && _currentPageIndex == _startShowingIndex) {
                [self hide];
                return;
            }
            
            CGFloat finalX = firstX, finalY;
            CGFloat windowsHeigt = _fullscreenView.bounds.size.height;
            if(scrollView.center.y > viewHalfHeight + 30) // swipe down
                finalY = windowsHeigt * 2;
            else // swipe up
                finalY = -viewHalfHeight;
            
            CGFloat animationDuration = durationToAnimate(windowsHeigt * 0.5, ABS(velocity.y));
            if (animationDuration < 0.1) animationDuration = 0.1;
            if (animationDuration > 0.35) animationDuration = 0.35;
            [UIView animateWithDuration:animationDuration delay:0.0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^
             {
                 [scrollView setCenter:CGPointMake(finalX, finalY)];
             }
                             completion:NULL];
            [self performSelector:@selector(hide) withObject:self
                       afterDelay:animationDuration];
            
        } else { // continue show part
            CGFloat velocityY = (.35 * velocity.y);
            CGFloat finalX = firstX;
            CGFloat finalY = viewHalfHeight;
            CGFloat animationDuration = (ABS(velocityY) * 0.0002)+ 0.2;
            
            [UIView animateWithDuration:animationDuration delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^
             {
                 [scrollView setCenter:CGPointMake(finalX, finalY)];
                 _backgroundView.alpha = 1.0;
             }
                             completion:NULL];
        }
    }
}

#pragma -mark show & hide
- (void)showPhotoAtIndex:(NSUInteger)index withThumbnailImageView:(UIView *)thumbnailView {
    if (index > _photosArray.count) {
        NSLog(@"Expected showing photo index %lu is out of range with total photos count %lu and current index", (unsigned long)index, (unsigned long)_photosArray.count);
        index = 0;
    }
    if (!_photosArray || _photosArray.count == 0) return;
    
    _startShowingIndex = index;
    
    // setup the root view
    UIView *rootViewControllerView = [[UIApplication sharedApplication] keyWindow].rootViewController.view;
    [_fullscreenView setFrame:[rootViewControllerView bounds]];
    [rootViewControllerView addSubview:_fullscreenView];
    [_fullscreenView addGestureRecognizer:_dismissPanGesture];

    // Stash away original thumbnail image view information
    if (thumbnailView) {
        _sourceView = thumbnailView;
        _sourceViewHereFrame = [_sourceView.superview convertRect:_sourceView.frame toView:_fullscreenView];
        _sourceView.hidden = YES;
    }
    
    // Configure the background view, iOS6的截图效率太低，这里使用半透明黑色背景替代
    UIColor *backgroundColor;
    if (_isiOS7) {
        UIImage *screenShotImage = [rootViewControllerView dx_screenShotImageAfterScreenUpdates:NO];
        screenShotImage = [screenShotImage dx_applyBlackEffect];
        backgroundColor = [UIColor colorWithPatternImage:screenShotImage];
    }else {
        backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    }
    _backgroundView.backgroundColor = backgroundColor;
    [_backgroundView setFrame:[_fullscreenView bounds]];
    [_backgroundView setAlpha:0];
    [_fullscreenView addSubview:_backgroundView];
    
    // reset the page scrollView
    [self resetPagingScrollView];
    CGRect finalFakeAnimationRect = [self createFakeAnimationImageViewIfNeed];
    [self tilePagesAtIndex:index];
    [_fullscreenView addSubview:_pagingScrollView];
    
    // pullToDetailView
    if (_delegateFlags.delegateImpTriggerPullToRight) {
        _pullToRightControl.frame = CGRectMake((_pagingScrollView.contentSize.width), 0,
                                               44.0, CGRectGetHeight(_pagingScrollView.bounds));
        [_pagingScrollView addSubview:_pullToRightControl];
    } else {
        [_pullToRightControl removeFromSuperview];
    }
    
    // pagecontrol
    _pageControl.hidden = _photosArray.count > 10;

    [self performAnimateFlyInWithFakeAnimationImageViewDestinationRect:finalFakeAnimationRect];
}

- (CGRect)createFakeAnimationImageViewIfNeed {
    if (!_sourceView) return CGRectZero;
    
    UIImage *scaleImage;
    id<DXPhoto> startPhoto = [self photoAtIndex:_startShowingIndex];
    if ([startPhoto respondsToSelector:@selector(placeholder)]) {
        scaleImage = [startPhoto placeholder];
    }
    if (!scaleImage) {
        scaleImage = [_sourceView dx_screenShotImageAfterScreenUpdates:NO];
    }

    // The destination imageSize, if the image has loaded we use it
    CGSize imageSize = CGSizeZero;
    if ([startPhoto respondsToSelector:@selector(expectLoadedImageSize)]) {
        imageSize = [startPhoto expectLoadedImageSize];
        imageSize = screenRatioSize(_fullscreenView.bounds.size, imageSize);
    }
    
    // last solution we use the screen size
    if (CGSizeEqualToSize(imageSize, CGSizeZero) && _sourceView) {
        imageSize = screenRatioSize(_fullscreenView.bounds.size, _sourceView.bounds.size);
    }
    
    CGRect screenBound = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    UIImageView *resizableImageView;
    CGRect finalImageViewFrame;
    if (!CGSizeEqualToSize(screenBound.size, CGSizeZero) && _sourceView) {
        CGFloat screenWidth = screenBound.size.width;
        CGFloat screenHeight = screenBound.size.height;
        
        resizableImageView = [[UIImageView alloc] initWithImage:scaleImage];
        resizableImageView.frame = _sourceViewHereFrame;
        resizableImageView.clipsToBounds = YES;
        resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_fullscreenView addSubview:resizableImageView];
        
        finalImageViewFrame = CGRectMake((CGRectGetWidth(_fullscreenView.bounds) - screenWidth) * 0.5,
                                         (CGRectGetHeight(_fullscreenView.bounds) - screenHeight) * 0.5,
                                         screenWidth,
                                         screenHeight);
        
        UIImage *placeholder = [startPhoto respondsToSelector:@selector(placeholder)] ? [startPhoto placeholder] : nil;
        if (!placeholder) {
            UIImageView *imageForDest = [[UIImageView alloc] initWithFrame:finalImageViewFrame];
            imageForDest.image = scaleImage;
            imageForDest.clipsToBounds = YES;
            imageForDest.contentMode = UIViewContentModeScaleAspectFill;
            _fakeAnimationPlaceholder = [imageForDest dx_screenShotImageAfterScreenUpdates:YES];
        }
    }
    
    _fakeAnimationImageView = resizableImageView;
    
    return finalImageViewFrame;
}

- (void)performAnimateFlyInWithFakeAnimationImageViewDestinationRect:(CGRect)destRect {
    if (_delegateFlags.delegateImpWillShowObj) {
        [_delegate simplePhotoBrowserWillShow:self];
    }
    
    dispatch_block_t animation = ^{
        [_backgroundView setAlpha:1.0];
        if (_fakeAnimationImageView) {
            _fakeAnimationImageView.layer.frame = destRect;
        } else {
            [_pagingScrollView setAlpha:1.0];
        }
    };
    
    dispatch_block_t completion = ^{
        [_fakeAnimationImageView removeFromSuperview];
        _fakeAnimationImageView = nil;
        _fakeAnimationPlaceholder = nil;
        
        [_pagingScrollView setAlpha:1.0];
        if (_delegateFlags.delegateImpDidShowObj) {
            [_delegate simplePhotoBrowserDidShow:self];
        }
    };
    
    if (self.isBouncingAnimation && _isiOS7) {
        [UIView animateWithDuration:self.flyInAnimationDuration + 0.1 delay:0.0
             usingSpringWithDamping:0.7
              initialSpringVelocity:6.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:animation
                         completion:^(BOOL finished) {
                             completion();
                         }];
    }else {
        [UIView animateWithDuration:self.flyInAnimationDuration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:animation
                         completion:^(BOOL finished) {
                             completion();
                         }];
    }
}

- (void)hide {
    [self hideAnimated:YES];
}

- (BOOL)shouldAnimateSourceViewFrame {
    return _sourceView && _currentPageIndex == _startShowingIndex;
}

- (void)hideAnimated:(BOOL)animated {
    CGFloat duration = 0.0;
    if (animated) duration = self.flyOutAnimationDuration;
    
    if ([self shouldAnimateSourceViewFrame] && duration > 0) {
        DXZoomingScrollView *scrollView = [self pageAtIndex:_currentPageIndex];
        [self performHideAnimatioWithScrollView:scrollView withDuration:duration];
    }else {
        _sourceView.hidden = NO;
    }
    
    [_pagingScrollView setAlpha:0.0];
    
    [UIView animateWithDuration:duration animations:^{
        [_backgroundView setAlpha:0];
    } completion:^(BOOL finished) {
        _sourceView.hidden = NO;
        [_pageControl removeFromSuperview];
        [_pagingScrollView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_fullscreenView removeFromSuperview];

        _pagingScrollView.alpha = 1.0;
        _pagingScrollView.transform = CGAffineTransformIdentity;
        [_fullscreenView removeGestureRecognizer:_dismissPanGesture];
        // Inform the delegate that we just hide a fullscreen photo
        if (_delegateFlags.delegateImpDidHideObj) {
            [_delegate simplePhotoBrowserDidHide:self];
        }
    }];
}

- (void)performHideAnimatioWithScrollView:(DXZoomingScrollView *)scrollView withDuration:(CGFloat)duration {
    UIImage *imageFromView = nil;
    
    if ([scrollView.photo respondsToSelector:@selector(placeholder)]) {
        imageFromView = [scrollView.photo placeholder];
    }
    
    if (!imageFromView) {
        imageFromView = [scrollView placeholder];
    }
    
    CGRect screenBound = [[[self pageAtIndex:_currentPageIndex] imageView] frame];
    UIImageView *resizableImageView;
    if (!CGSizeEqualToSize(screenBound.size, CGSizeZero)) {
        screenBound = [scrollView convertRect:screenBound toView:_fullscreenView];
        resizableImageView = [[UIImageView alloc] initWithImage:imageFromView];
        resizableImageView.frame = screenBound;
        resizableImageView.contentMode = UIViewContentModeScaleAspectFill;
        resizableImageView.backgroundColor = [UIColor clearColor];
        resizableImageView.clipsToBounds = YES;
        [_fullscreenView addSubview:resizableImageView];
    }
    
    dispatch_block_t animation = ^{
        resizableImageView.layer.frame = _sourceViewHereFrame;
    };
    
    dispatch_block_t completion = ^{
        [resizableImageView removeFromSuperview];
    };
    
    if (self.isBouncingAnimation && _isiOS7) {
        [UIView animateWithDuration:duration + 0.1 delay:0.0
             usingSpringWithDamping:0.9
              initialSpringVelocity:4.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animation
                         completion:^(BOOL finished) {
                             completion();
                         }];
    }else {
        [UIView animateWithDuration:duration
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:animation
                         completion:^(BOOL finished) {
                             completion();
                         }];
    }
}

- (void)zoomingScrollViewSingleTapped:(DXZoomingScrollView *)zoomingScrollView {
    [self hide];
}

@end
