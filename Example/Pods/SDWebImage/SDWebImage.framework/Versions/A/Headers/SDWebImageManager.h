/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageOperation.h"
#import "SDWebImageDownloader.h"
#import "SDImageCache.h"

#define TBCDNImageModuleDefault     @"default"
#define TBCDNImageModuleDetail      @"detail"
#define TBCDNImageModuleShop        @"shop"
#define TBCDNImageModuleSearch      @"search"
#define TBCDNImageModuleWaterFlow   @"waterflow"
#define TBCDNImageModuleWeitao      @"weitao"
#define TBCDNImageModuleWeapp       @"weapp"
#define TBCDNImageModuleBala        @"bala"
#define TBCDNImageModuleHomePage    @"homepage"
#define TBCDNImageModuleWebView     @"webview"

typedef void(^SDWebImageCompletedBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType);

typedef void(^SDWebImageCompletedWithFinishedBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished);

typedef void(^SDWebImageCompletionWithFinishedBlock)(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL);

@class SDWebImageManager;

@protocol SDWebImageManagerDelegate <NSObject>

@optional

/**
 * Controls which image should be downloaded when the image is not found in the cache.
 *
 * @param imageManager The current `SDWebImageManager`
 * @param imageURL The url of the image to be downloaded
 *
 * @return Return NO to prevent the downloading of the image on cache misses. If not implemented, YES is implied.
 */
- (BOOL)imageManager:(SDWebImageManager *)imageManager shouldDownloadImageForURL:(NSURL *)imageURL;

/**
 * Allows to transform the image immediately after it has been downloaded and just before to cache it on disk and memory.
 * NOTE: This method is called from a global queue in order to not to block the main thread.
 *
 * @param imageManager The current `SDWebImageManager`
 * @param image The image to transform
 * @param imageURL The url of the image to transform
 *
 * @return The transformed image object.
 */
- (UIImage *)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL;

@end

/**
 * The SDWebImageManager is the class behind the UIImageView+WebCache category and likes.
 * It ties the asynchronous downloader (SDWebImageDownloader) with the image cache store (SDImageCache).
 * You can use this class directly to benefit from web image downloading with caching in another context than
 * a UIView.
 *
 * Here is a simple example of how to use SDWebImageManager:
 *
 * @code
 
 SDWebImageManager *manager = [SDWebImageManager sharedManager];
 [manager downloadWithURL:imageURL
 options:0
 progress:nil
 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
 {
 if (image)
 {
 // do something with image
 }
 }];
 
 * @endcode
 */
@interface SDWebImageManager : NSObject

@property (weak, nonatomic) id <SDWebImageManagerDelegate> delegate;

@property (strong, nonatomic, readonly) SDImageCache *imageCache;
@property (strong, nonatomic, readonly) SDWebImageDownloader *imageDownloader;

/**
 * The cache filter is a block used each time SDWebImageManager need to convert an URL into a cache key. This can
 * be used to remove dynamic part of an image URL.
 *
 * The following example sets a filter in the application delegate that will remove any query-string from the
 * URL before to use it as a cache key:
 *
 * @code
 
 [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url)
 {
 url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
 return [url absoluteString];
 }];
 
 * @endcode
 */
@property (strong) NSString *(^cacheKeyFilter)(NSURL *url);

/**
 * Returns global SDWebImageManager instance.
 *
 * @return SDWebImageManager shared instance
 */
+ (SDWebImageManager *)sharedManager;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 基本

/**
 *  基本静默下载图片接口
 *  注意：这个接口谨慎使用，因为是原图下载，如果过大会耗费流量
 *
 *  @param url            图片url
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  添加图片大小
 *  注意：这个接口只有在你确定图片大小，不需要底层再适配大小时使用，如果需要适配，请用楼下接口
 *
 *  @param url            图片url
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                  imageSize:(CGSize)imageSize
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加裁切类型
 *
 *  @param url            图片url
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加裁切类型
 *
 *  @param url            图片url
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 *  @param options        选项参数
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                    options:(SDWebImageOptions)options
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加裁切类型
 *
 *  @param url            图片url
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 *  @param options        选项参数
 *  @param progress       进度回调
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                    options:(SDWebImageOptions)options
                                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark 组件定位

/**
 *  基本静默下载图片接口
 *  注意：这个接口谨慎使用，因为是原图下载，如果过大会耗费流量
 *
 *  @param url            图片url
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                     module:(NSString *)module
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  添加图片大小
 *  注意：这个接口只有在你确定图片大小，不需要底层再适配大小时使用，如果需要适配，请用楼下接口
 *
 *  @param url            图片url
 *  @param module         调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                     module:(NSString *)module
                                  imageSize:(CGSize)imageSize
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加裁切类型
 *
 *  @param url            图片url
 *  @param module         调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                     module:(NSString *)module
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加选项参数
 *
 *  @param url            图片url
 *  @param module         调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 *  @param options        选项参数
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                     module:(NSString *)module
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                    options:(SDWebImageOptions)options
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  对应添加进度回调
 *
 *  @param url            图片url
 *  @param module         调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param imageSize      图像大小（注意： 如果要指定大小，需要自己处理 Retina Scale，不然可以直接用 CGSizeZero 忽略）
 *  @param cutType        指定裁剪类型
 *  @param options        选项参数
 *  @param progress       进度回调
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                     module:(NSString *)module
                                  imageSize:(CGSize)imageSize
                                    cutType:(ImageCutType)cutType
                                    options:(SDWebImageOptions)options
                                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;


/**
 *  老接口兼容
 *
 *  @param url            图片url
 *  @param options        选项参数
 *  @param progress       进度回调
 */
- (id <SDWebImageOperation>)downloadWithURL:(NSURL *)url
                                    options:(SDWebImageOptions)options
                                   progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                  completed:(SDWebImageCompletedWithFinishedBlock)completedBlock;

/**
 *  新接口适配：官方版本3.7.0以上开始使用此方法
 *
 *  @param url            图片url
 *  @param options        选项参数
 *  @param progress       进度回调
 */
- (id <SDWebImageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(SDWebImageOptions)options
                                        progress:(SDWebImageDownloaderProgressBlock)progressBlock
                                       completed:(SDWebImageCompletionWithFinishedBlock)completedBlock;



/**
 * Cancel all current opreations
 */
- (void)cancelAll;

/**
 * Check one or more operations running
 */
- (BOOL)isRunning;

/**
 * Check if image has already been cached
 */
- (BOOL)diskImageExistsForURL:(NSURL *)url;

/**
 * Get cache key for url
 */
- (NSString *)cacheKeyForURL:(NSURL *)url;

@end