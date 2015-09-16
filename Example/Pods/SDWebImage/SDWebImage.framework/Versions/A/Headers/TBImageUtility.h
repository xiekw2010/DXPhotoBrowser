//
//  TBImageUtility.h
//  SDWebImage
//
//  Created by 贾复 on 14/11/19.
//  Copyright (c) 2014年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBImageUtility : NSObject

+ (CGSize)imageSizeFromURLString:(NSString *)urlString;
+ (NSString *)imageBaseUrlStringFromURLString:(NSString *)urlString;

// 检查并补齐URL Schema
+ (NSURL*)checkURLSchema:(NSURL *)inputUrl;

@end
