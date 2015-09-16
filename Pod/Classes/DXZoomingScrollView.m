//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "DXZoomingScrollView.h"
#import "DXErrorIndicator.h"
#import "DXTapDetectingImageView.h"
#import "DXTapDetectingView.h"
#import "DXPhoto.h"


@interface DXZoomingScrollView ()<DXTapDetectingImageViewDelegate, DXTapDetectingViewDelegate> {
    DXTapDetectingView *_tapView; // for background taps
    DXTapDetectingImageView *_imageView;
    UIActivityIndicatorView *_loadingIndicator;
    CGSize _imageSize;
}

@property (nonatomic, strong) DXErrorIndicator *errorPlaceholder;

@end

@implementation DXZoomingScrollView

- (id)initWithDelegate:(id<DXZoomingScrollViewDelegate>)delegate {
    if (self = [super init]) {
        _zoomDelegate = delegate;
        _index = NSUIntegerMax;
    
        UIViewAutoresizing autoresizingMaskWidthAndHeight = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        _tapView = [[DXTapDetectingView alloc] initWithFrame:self.bounds];
        _tapView.tapDelegate = self;
        _tapView.autoresizingMask = autoresizingMaskWidthAndHeight;
        _tapView.backgroundColor = [UIColor clearColor];
        _tapView.tapDelegate = self;
        [self addSubview:_tapView];

        _imageView = [[DXTapDetectingImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.tapDelegate = self;
        _imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_imageView];
        
        // Loading indicator
        _loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _loadingIndicator.userInteractionEnabled = NO;
        _loadingIndicator.autoresizingMask
            = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
            UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_loadingIndicator];

        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = autoresizingMaskWidthAndHeight;
    }
    
    return self;
}

- (void)hideLoadingIndicator {
    [_loadingIndicator stopAnimating];
    _loadingIndicator.hidden = YES;
}

- (void)showLoadingIndicator {
    self.zoomScale = 0;
    self.minimumZoomScale = 0;
    self.maximumZoomScale = 0;
    [_loadingIndicator stopAnimating];
    [_loadingIndicator startAnimating];
    _loadingIndicator.hidden = NO;
    [_errorPlaceholder removeFromSuperview];
    _errorPlaceholder = nil;
}

- (void)updateLoadingIndicatorWithProgress:(CGFloat)progress {
    [_loadingIndicator startAnimating];
}

- (void)prepareForReuse {
    [_errorPlaceholder removeFromSuperview];
    _errorPlaceholder = nil;
    if ([_photo respondsToSelector:@selector(cancelLoadImage)]) {
        [_photo cancelLoadImage];
    }
    _photo = nil;
    _imageView.image = nil;
    _index = NSUIntegerMax;
    _imageSize = CGSizeZero;
    [self hideLoadingIndicator];
}

- (void)setPhoto:(id<DXPhoto>)photo {
    _photo = photo;
    
    [self showLoadingIndicator];
    __weak typeof(self) wself = self;
    [_photo loadImageWithProgressBlock:^(NSInteger receivedSize, NSInteger expectedSize) {
        [wself updateLoadingIndicatorWithProgress:(CGFloat)(receivedSize/expectedSize)];
    } completionBlock:^(id<DXPhoto> aPhoto, UIImage *image) {
        if (!wself) return;
        [wself hideLoadingIndicator];
        
        if (image && !CGSizeEqualToSize(image.size, CGSizeZero)) {
            [wself setupImageViewWithImage:image];
        } else {
            [wself showErrorIndicator];
        }
    }];
}

- (void)setupImageViewWithImage:(UIImage *)image {
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    _imageSize = image.size;
    //set image
    _imageView.image = image;
    
    // Setup photo frame
    CGRect photoImageViewFrame;
    photoImageViewFrame.origin = CGPointZero;
    photoImageViewFrame.size = _imageSize;
    _imageView.frame = photoImageViewFrame;
    self.contentSize = photoImageViewFrame.size;
    
    // Set zoom to minimum zoom
    [self setMaxMinZoomScalesForCurrentBounds];
}

- (void)showErrorIndicator {
    [self addSubview:self.errorPlaceholder];
    _imageView.image = [self placeholder];
}

- (UIImage *)placeholder {
    if ([_photo respondsToSelector:@selector(placeholder)]) {
        return [_photo placeholder];
    }
    
    return nil;
}

- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    // Bail if no image
    if (_imageView.image == nil) return;
    
    // Reset position
    _imageView.frame = CGRectMake(0, 0, _imageView.frame.size.width, _imageView.frame.size.height);
    
    // Sizes
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = self->_imageSize;
    
    // Calculate Min
    // the scale needed to perfectly fit the image width-wise
    CGFloat xScale = boundsSize.width / imageSize.width;
    // the scale needed to perfectly fit the image height-wise
    CGFloat yScale = boundsSize.height / imageSize.height;
    // use minimum of these to allow the image to become fully visible
    CGFloat minScale = MIN(xScale, yScale);
    
    // Calculate Max
    CGFloat maxScale = 3;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Let them go a bit bigger on a bigger screen!
        maxScale = 4;
    }
    
    // Image is smaller than screen so no zooming!
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    // Set min/max zoom
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    // Initial zoom
    self.zoomScale = [self initialZoomScaleWithMinScale];
    
    // If we're zooming to fill then centralise
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
    }
    
    // Layout
    [self setNeedsLayout];
}

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_imageView) {
        // Zoom image to fill if the aspect ratios are fairly similar
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = self->_imageSize;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        // the scale needed to perfectly fit the image width-wise
        CGFloat xScale = boundsSize.width / imageSize.width;
        // the scale needed to perfectly fit the image height-wise
        CGFloat yScale = boundsSize.height / imageSize.height;
        // Zooms standard portrait images on a 3.5in screen but not on a 4in screen.
        if (ABS(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            // Ensure we don't zoom in or out too far, just in case
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    
    return zoomScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (DXErrorIndicator *)errorPlaceholder {
    if (!_errorPlaceholder) {
        _errorPlaceholder = [[DXErrorIndicator alloc] initWithFrame:CGRectMake(0, 0, 44.0, 44.0)];
        _errorPlaceholder.center = self.center;
        [_errorPlaceholder addTarget:self action:@selector(reloadDisplay)
                    forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _errorPlaceholder;
}

- (void)reloadDisplay {
    self.photo = _photo;
}

- (void)layoutSubviews {
    // Position indicators (centre does not seem to work!)
    if (!_loadingIndicator.hidden)
        _loadingIndicator.frame
            = CGRectMake(floorf((self.bounds.size.width - _loadingIndicator.frame.size.width) / 2.),
                         floorf((self.bounds.size.height - _loadingIndicator.frame.size.height) / 2),
                         _loadingIndicator.frame.size.width,
                         _loadingIndicator.frame.size.height);
    if (_errorPlaceholder)
        _errorPlaceholder.frame
            = CGRectMake(floorf((self.bounds.size.width - _errorPlaceholder.frame.size.width) / 2.),
                         floorf((self.bounds.size.height - _errorPlaceholder.frame.size.height) / 2),
                         _errorPlaceholder.frame.size.width,
                         _errorPlaceholder.frame.size.height);
    
    // Super
    [super layoutSubviews];
    
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_imageView.frame, frameToCenter))
        _imageView.frame = frameToCenter;
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(UITouch *)touch {
    [self handleDoubleTap:[touch locationInView:imageView]];
}

// Background View
- (void)view:(UIView *)view singleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleSingleTap:CGPointMake(touchX, touchY)];
}

- (void)view:(UIView *)view doubleTapDetected:(UITouch *)touch {
    // Translate touch location to image view location
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

- (void)handleSingleTap:(CGPoint)touchPoint {
    if ([_zoomDelegate respondsToSelector:@selector(zoomingScrollViewSingleTapped:)]) {
        [_zoomDelegate zoomingScrollViewSingleTapped:self];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)handleDoubleTap:(CGPoint)touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale
        && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize)
                animated:YES];
    }
}

@end
