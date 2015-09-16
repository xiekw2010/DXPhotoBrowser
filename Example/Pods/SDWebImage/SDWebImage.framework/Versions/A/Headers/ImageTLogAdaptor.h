//
//  ImageTLogAdaptor.h
//  SDWebImage
//
//  Created by LeonChu on 15/8/14.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageTLogAdaptor : NSObject

+ (BOOL)isDebug;
+ (BOOL)isInfo;
+ (BOOL)isError;

+(void)printDebugLog:(NSString *) log;
+(void)printInfoLog:(NSString *) log;
+(void)printErrorLog:(NSString *) log;

@end
