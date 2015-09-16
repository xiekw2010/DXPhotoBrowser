/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageCompat.h"
#import "SDWebImageManager.h"

@interface UIButton (WebCache)

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 按钮图

#pragma mark 基本

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param options      选项
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
                options:(SDWebImageOptions)options;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progressBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 结束回调

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progressBlock
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  SD 老接口兼容
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
       placeholderImage:(UIImage *)placeholder
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progressBlock
              completed:(SDWebImageCompletedBlock)completedBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 组件定位

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
       placeholderImage:(UIImage *)placeholder
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options
              completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setImageWithURL:(NSURL *)url
               forState:(UIControlState)state
                 module:(NSString *)module
       placeholderImage:(UIImage *)placeholder
              imageSize:(CGSize)imageSize
                cutType:(ImageCutType)cutType
                options:(SDWebImageOptions)options
               progress:(SDWebImageDownloaderProgressBlock)progressBlock
              completed:(SDWebImageCompletedBlock)completedBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 背景图

#pragma mark 基本

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param options      选项
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                          options:(SDWebImageOptions)options;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options
                         progress:(SDWebImageDownloaderProgressBlock)progressBlock;


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 结束回调

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options
                         progress:(SDWebImageDownloaderProgressBlock)progressBlock
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  SD 老接口兼容
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param placeholder  占位图
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                 placeholderImage:(UIImage *)placeholder
                          options:(SDWebImageOptions)options
                         progress:(SDWebImageDownloaderProgressBlock)progressBlock
                        completed:(SDWebImageCompletedBlock)completedBlock;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark 组件定位

/**
 *  基本图片请求调用
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加占位图
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                 placeholderImage:(UIImage *)placeholder
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加裁剪信息参数
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加图片大小
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加options参数选项
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 *  添加progress回调
 *
 *  @param url          图片请求链接
 *  @param state        button状态
 *  @param module       调用组件模块名，为了对不同模块进行不同配置，默认则写TBCDNImageModuleDefault
 *  @param placeholder  占位图
 *  @param imageSize    指定图片大小（注意：一般情况下不需要指定或可以直接设置为 CGSizeZero。当你调用接口时 imageView 的 frame 还未初始化，用这个指定。指定时必须自己处理 Retina Scale）
 *  @param cutType      指定裁剪类型
 *  @param options      参数选项
 *  @param progressBlock 进度回调
 */
- (void)setBackgroundImageWithURL:(NSURL *)url
                         forState:(UIControlState)state
                           module:(NSString *)module
                 placeholderImage:(UIImage *)placeholder
                        imageSize:(CGSize)imageSize
                          cutType:(ImageCutType)cutType
                          options:(SDWebImageOptions)options
                         progress:(SDWebImageDownloaderProgressBlock)progressBlock
                        completed:(SDWebImageCompletedBlock)completedBlock;

/**
 * Cancel the current download
 */
- (void)cancelCurrentImageLoad;

@end
