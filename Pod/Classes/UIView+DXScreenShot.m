//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "UIView+DXScreenShot.h"

@implementation UIView (DXScreenShot)

- (UIImage *)dx_screenShotImageWithBounds:(CGRect)selfBounds afterScreenUpdates:(BOOL)update {
    UIGraphicsBeginImageContextWithOptions(selfBounds.size, NO, 0);
    
    // The ios7 faster screenshot image method
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [self drawViewHierarchyInRect:CGRectMake(-selfBounds.origin.x, -selfBounds.origin.y,
                                                 CGRectGetWidth(self.bounds),
                                                 CGRectGetHeight(self.bounds))
                   afterScreenUpdates:update];
    }else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

- (UIImage *)dx_screenShotImage {
    return [self dx_screenShotImageWithBounds:self.bounds afterScreenUpdates:NO];
}

- (UIImage *)dx_screenShotImageAfterScreenUpdates:(BOOL)update {
    return [self dx_screenShotImageWithBounds:self.bounds afterScreenUpdates:update];
}

@end
