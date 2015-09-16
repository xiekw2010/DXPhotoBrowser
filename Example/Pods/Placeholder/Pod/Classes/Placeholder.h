//
//  ALFLEXBOXUtils.h
//  all_layouts
//
//  Created by xiekw on 15/7/6.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^PlaceholderBlock)(NSArray *models, NSError *error);

@interface UIColor (PH_Colorful)

+ (UIColor *)randomColor;
+ (UIColor *)randomColorWithAlpha:(CGFloat)alpha;

@end

@interface Placeholder : NSObject

+ (NSString *)textWithRange:(NSRange)range;
+ (UIImage *)imageWithSize:(CGSize)size;
+ (NSString *)imageURL;
+ (NSString *)paragraph;

@end

@interface PlaceholderModel : NSObject

+ (instancetype)randomModel;
+ (NSArray *)randomModelWithRange:(NSRange)range;
+ (void)asyncRandomModelWithRange:(NSRange)range completionBlock:(PlaceholderBlock)block;

@end

@interface PHFeedUser : PlaceholderModel

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) NSString *avatarURL;

+ (instancetype)randomModel;

@end

@interface PHFeedComment : PlaceholderModel

@property (nonatomic, strong) PHFeedUser *user;
@property (nonatomic, strong) NSString *commentDate;
@property (nonatomic, strong) NSString *commentContent;
@property (nonatomic, strong) NSArray *imageURLs;

+ (instancetype)randomModel;

@end

@interface PHFeed : PlaceholderModel

@property (nonatomic, strong) PHFeedUser *user;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSArray *tags;
@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSArray *imageURLs;
@property (nonatomic, assign) CGFloat currentPrice;
@property (nonatomic, assign) CGFloat originPrice;
@property (nonatomic, assign) NSUInteger soldedCount;
@property (nonatomic, assign, getter=isLiked) BOOL liked;

+ (instancetype)randomModel;

@end

