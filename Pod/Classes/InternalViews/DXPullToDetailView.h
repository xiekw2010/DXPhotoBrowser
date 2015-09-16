//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DXPullToDetailView : UIView

@property (nonatomic, assign) BOOL pulling;
@property (nonatomic, strong) NSString *pullingText;
@property (nonatomic, strong) NSString *releasingText;
@property (nonatomic, strong, readonly) UILabel *textLabel;

- (void)setPulling:(BOOL)pulling animated:(BOOL)animated;

@end
