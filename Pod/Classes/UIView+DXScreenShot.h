//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DXScreenShot)

- (UIImage *)dx_screenShotImage;
- (UIImage *)dx_screenShotImageAfterScreenUpdates:(BOOL)update;
- (UIImage *)dx_screenShotImageWithBounds:(CGRect)selfBounds afterScreenUpdates:(BOOL)update;

@end
