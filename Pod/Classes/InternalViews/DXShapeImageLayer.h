//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface DXShapeImageLayer : CALayer

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *highlightedColor;

/**
 *  This shape which maded by this cells.
 *  When subclass, remember to add you cells into this array
 */
@property (nonatomic, strong) NSMutableArray *cellLayers;

- (UIImage *)normalImage;
- (UIImage *)highlightedImage;

@end

@interface DXCrossLayer : DXShapeImageLayer

/**
 *  Default is 1.0
 */
@property (nonatomic, assign) CGFloat crossLineWidth;

/**
 *  Use 45.0, 90.0 instead of PI
 */
@property (nonatomic, assign) CGFloat crossLineAngle;

/**
 *  Default is 1.0
 */
@property (nonatomic, assign) CGFloat crossLineCornerRadius;

@end

@interface DXArrowLayer : DXShapeImageLayer

/**
 *  default is 1.0
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 *  default is 1.0
 */
@property (nonatomic, assign) CGFloat circleLineWidth;

@end