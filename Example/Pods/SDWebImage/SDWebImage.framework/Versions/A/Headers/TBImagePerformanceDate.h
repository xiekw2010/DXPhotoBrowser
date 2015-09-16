//
//  TBImagePerformanceDate.h
//  SDWebImage
//
//  Created by zhangtianshun on 15/4/8.
//  Copyright (c) 2015年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TBImagePerformanceDate : NSObject

@property (nonatomic, strong) NSMutableDictionary* userInfo;


@property (nonatomic, strong) NSDate       *beginDate;
@property (nonatomic, strong) NSDate       *endDate;
@property (nonatomic, strong) NSString     *url;
@property (nonatomic, strong) NSString     *eventType;
@property (nonatomic, strong) NSString     *bizName;
@property (nonatomic, strong) NSError      *error;
@property (nonatomic, strong) NSString     *dataFrom; // 图片来源：0.网络，1.memcache，2.磁盘精确匹配，3缓存裁剪
@property (nonatomic, assign) NSUInteger   eventId;

@property (nonatomic, strong) NSDate       *prePhaseDate;
@property (nonatomic, strong) NSString     *prePhaseName;
@property (nonatomic, strong) NSMutableArray *normalPhaseArray;


- (void)initWithParam:(NSString *)url module:(NSString *)module;

//- (void)endPerformanceUserTrack;

- (id)objectByKey:(NSString *)key;

- (NSString *)getDataFromCode;
- (NSString *)getErrorCode;

@end
