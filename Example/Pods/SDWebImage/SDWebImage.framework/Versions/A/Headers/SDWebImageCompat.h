/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 * (c) Jamie Pinkham
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <TargetConditionals.h>

#ifdef __OBJC_GC__
#error SDWebImage does not support Objective-C Garbage Collection
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_5_0
#error SDWebImage doesn't support Deployement Target version < 5.0
#endif

#if !TARGET_OS_IPHONE
#import <AppKit/AppKit.h>
#ifndef UIImage
#define UIImage NSImage
#endif
#ifndef UIImageView
#define UIImageView NSImageView
#endif
#else

#import <UIKit/UIKit.h>

#endif

#ifndef NS_ENUM
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#ifndef NS_OPTIONS
#define NS_OPTIONS(_type, _name) enum _name : _type _name; enum _name : _type
#endif

#if OS_OBJECT_USE_OBJC
    #undef SDDispatchQueueRelease
    #undef SDDispatchQueueSetterSementics
    #define SDDispatchQueueRelease(q)
    #define SDDispatchQueueSetterSementics strong
#else
#undef SDDispatchQueueRelease
#undef SDDispatchQueueSetterSementics
#define SDDispatchQueueRelease(q) (dispatch_release(q))
#define SDDispatchQueueSetterSementics assign
#endif

extern UIImage *SDScaledImageForKey(NSString *key, NSObject *imageOrData);

#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    }\
    else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }


#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread])\
    {\
        block();\
    }\
    else\
    {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }


typedef NS_ENUM(NSInteger, ImageCutType) {
    ImageCutType_None,      //不裁剪
    ImageCutType_XZ,        //缩放裁剪
    //    ImageCutType_XC         //非缩放裁剪
};


typedef NS_OPTIONS(NSUInteger, SDWebImageOptions) {
    /**
     * By default, when a URL fail to be downloaded, the URL is blacklisted so the library won't keep trying.
     * This flag disable this blacklisting.
     */
    SDWebImageRetryFailed = 1 << 0,
    /**
     * By default, image downloads are started during UI interactions, this flags disable this feature,
     * leading to delayed download on UIScrollView deceleration for instance.
     */
    SDWebImageLowPriority = 1 << 1,
    /**
     * This flag disables on-disk caching
     */
    SDWebImageCacheMemoryOnly = 1 << 2,
    /**
     * This flag enables progressive download, the image is displayed progressively during download as a browser would do.
     * By default, the image is only displayed once completely downloaded.
     */
    SDWebImageProgressiveDownload = 1 << 3,
    /**
     * Even if the image is cached, respect the HTTP response cache control, and refresh the image from remote location if needed.
     * The disk caching will be handled by NSURLCache instead of SDWebImage leading to slight performance degradation.
     * This option helps deal with images changing behind the same request URL, e.g. Facebook graph api profile pics.
     * If a cached image is refreshed, the completion block is called once with the cached image and again with the final image.
     *
     * Use this flag only if you can't make your URLs static with embeded cache busting parameter.
     */
    SDWebImageRefreshCached = 1 << 4,
    
    /**
     * In iOS 4+, continue the download of the image if the app goes to background. This is achieved by asking the system for
     * extra time in background to let the request finish. If the background task expires the operation will be cancelled.
     */
    SDWebImageContinueInBackground = 1 << 5,
    /**
     * Handles cookies stored in NSHTTPCookieStore by setting
     * NSMutableURLRequest.HTTPShouldHandleCookies = YES;
     */
    SDWebImageHandleCookies = 1 << 6,
    /**
     * Enable to allow untrusted SSL ceriticates.
     * Useful for testing purposes. Use with caution in production.
     */
    SDWebImageAllowInvalidSSLCertificates = 1 << 7,
    
    /**
     * By default, image are loaded in the order they were queued. This flag move them to
     * the front of the queue and is loaded immediately instead of waiting for the current queue to be loaded (which
     * could take a while).
     */
    SDWebImageHighPriority = 1 << 8,
    
    /**
     * Don't parse the URL
     */
    SDWebImageNoParse = 1 << 9,
    
    /**
     * Curve Animation
     */
    SDWebImageAnimating = 1 << 10,
    
    /**
     * Force no WebP
     */
    SDWebImageNoWebP = 1 << 11,
    
    /**
     * Force no small copy as placeholder
     */
    SDWebImageNoSmallCopy = 1 << 12,
    
    /**
     * When refreshing the same imageView, keep the old image showing
     */
    SDWebImageKeepImageWhenRefreshing = 1 << 13,
    
    /**
     * This flag disables find from disk cache
     */
    SDWebImageNoFindFromDisk = 1 << 14
};



typedef NS_ENUM(NSInteger, SDImageCacheType) {
    /**
     * The image wasn't available the SDWebImage caches, but was downloaded from the web.
     */
    SDImageCacheTypeNone,
    /**
     * The image was obtained from the disk cache.
     */
    SDImageCacheTypeDisk,
    /**
     * The image was obtained from the memory cache.
     */
    SDImageCacheTypeMemory,
    /**
     * The image was obtained from the memory cache. but a small copy exists.
     */
    SDImageCacheTypeSmallCopy
};
