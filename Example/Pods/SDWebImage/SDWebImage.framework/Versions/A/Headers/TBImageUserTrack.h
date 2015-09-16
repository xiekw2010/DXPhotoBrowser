//
//  TBImageUserTrack.h
//  TBCDNImage
//
//  Created by 贾复 on 14/8/4.
//  Copyright (c) 2014年 Taobao lnc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TBImageUserTrack : NSObject

+ (TBImageUserTrack*)shareTrack;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 缓存性能

//- (void)increaseMemoryHit;
//- (void)increaseDiskHit;
//- (void)increaseRemoteHit;
//- (void)appendWriteTotalBytes:(NSUInteger)bytes;
//- (void)appendWriteTimeCost:(NSTimeInterval)cost;
//- (void)appendReadTotalBytes:(NSUInteger)bytes;
//- (void)appendReadTimeCost:(NSTimeInterval)cost;

- (void)startTrackIfNeeded;
- (void)restore;
- (void)store;

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 全链路性能



/*
 *  图片链路埋点 的起始点
 *
 *  @param url      所在页面
 *  @param modlue    调用图片库的模块名称
 *  @param userInfo  上传的数据字典
 */
- (void)beginImageTrace:(NSString *)url module:(NSString *)module userInfo:(NSDictionary *)userInfo;


/*
 针对业务过程中的某个中间时间点进行一条打点，调用后，在end的时候，会在args里增加一条@“phase-start”,或者 @“phase-phase0”的耗时的记录
 Begin________A_______B_______C_______End,
 调用 addPerformancePhase:A, addPerformancePhase:B, addPerformancePhase:C, 在UT记录里就会记录A-begin:耗时，B-A:耗时，C-B:耗时，这样的信息
 主要用于解决串行时各时间点的时间差
 */
- (void)addPhase:(NSString *)phase url:(NSString *)url userInfo:(NSDictionary *)userInfo;


/*!
 *  全链路埋点：Image数据来源监控
 *
 *  @param dataFrom  数据来源：网络(Network)，内存缓存(MemCache)，磁盘精确匹配(DiskCache)，缓存裁剪(DiskCacheCut)
 *  @param page      所在页面
 *  @param eventType 事件类型，eg:load、click
 *  @param eventId   埋点事件id
 */
- (void)addDataFrom:(NSString *)dataFrom url:(NSString *)url;


/**
 *  全链路埋点 的结束点，自动调用clear, 这里的page和eventType 需要和start调用中匹配。加参数，解决不同业务交叉调用start的情况，但对于同个业务连续调多次start还是无法处理，若要解决需要开放内部token
 *	@param 	page        所在页面
 *  @param 	eventType 	事件类型，eg:load、click
 *  @param 	eventId 	埋点事件id
 *  @param 	userInfo 	放入args中的数据
 */
- (void)endImageTrace:(NSString *)url userInfo:(NSDictionary *)userInfo;


- (void)commitErrorMonitor:(NSString *)url  error:(NSError *)error;



@end
