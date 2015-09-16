//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#define dx_ChangeLayerAnchorPointAndAjustPositionToStayFrame(layer, nowAnchorPoint) \
CGPoint dx_lastAnchor = layer.anchorPoint;\
layer.anchorPoint = nowAnchorPoint;\
layer.position \
    = CGPointMake(layer.position.x+(nowAnchorPoint.x-dx_lastAnchor.x)*layer.bounds.size.width, \
                  layer.position.y+(nowAnchorPoint.y-dx_lastAnchor.y)*layer.bounds.size.height);\

static inline CGFloat radians(CGFloat degrees) {
    return ( degrees * M_PI ) / 180.0;
}

#import "DXShapeImageLayer.h"

@implementation DXShapeImageLayer

- (instancetype)init {
    self = [super init];
    if (self) {
        _normalColor = [UIColor whiteColor];
        _highlightedColor = [UIColor darkGrayColor];
        _cellLayers = [NSMutableArray array];
    }
    return self;
}

- (UIImage *)normalImage {
    for (CALayer *layer in self.cellLayers) {
        layer.backgroundColor = self.normalColor.CGColor;
    }
    return [self toImage];
}

- (UIImage *)highlightedImage {
    for (CALayer *layer in self.cellLayers) {
        layer.backgroundColor = self.highlightedColor.CGColor;
    }
    return [self toImage];
}

- (UIImage *)toImage {
    CGSize size = self.bounds.size;
    if (CGSizeEqualToSize(size, CGSizeZero)) return nil;
    
    CGRect rect = CGRectMake(0.0, 0.0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    [self renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

@implementation DXCrossLayer {
    CALayer *_left;
    CALayer *_right;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.crossLineAngle = radians(45.0);
        self.crossLineWidth = 1.0;
        self.crossLineCornerRadius = 1.0;
        _left = [CALayer layer];
        _right = [CALayer layer];
        [self addSublayer:_left];
        [self addSublayer:_right];
        
        [self.cellLayers addObject:_left];
        [self.cellLayers addObject:_right];
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        CGRect crossFrame
        = CGRectInset(bounds, (CGRectGetWidth(bounds) - self.crossLineWidth) * 0.5, 0.0);
        _left.frame = crossFrame;
        _right.frame = crossFrame;
        _left.transform = CATransform3DMakeRotation(-self.crossLineAngle, 0.0, 0.0, 1.0);
        _right.transform = CATransform3DMakeRotation(self.crossLineAngle, 0.0, 0.0, 1.0);
        [self setNeedsDisplay];
    }
    
    [super setBounds:bounds];
}

@end

@implementation DXArrowLayer {
    CAShapeLayer *_circle;
    CALayer *_middleLine;
    CALayer *_upLine;
    CALayer *_downLine;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineWidth = 1.0;
        _circleLineWidth = 1.0;
        self.masksToBounds = NO;
        
        _circle = [CAShapeLayer new];
        _middleLine = [CALayer layer];
        _upLine = [CALayer layer];
        _downLine = [CALayer layer];
        [self addSublayer:_circle];
        [self addSublayer:_middleLine];
        [self addSublayer:_upLine];
        [self addSublayer:_downLine];
        
        [self.cellLayers addObject:_circle];
        [self.cellLayers addObject:_middleLine];
        [self.cellLayers addObject:_upLine];
        [self.cellLayers addObject:_downLine];
    }
    
    return self;
}

- (void)setBounds:(CGRect)bounds {
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        _circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(bounds, 1.0, 1.0)
                                                  cornerRadius:CGRectGetMidX(bounds)].CGPath;
        _circle.lineWidth = _circleLineWidth;
        _circle.fillColor = [UIColor clearColor].CGColor;
        _circle.strokeColor = self.normalColor.CGColor;
        
        CGFloat middleLineWidth = bounds.size.width * 0.5;
        _middleLine.frame = CGRectMake((CGRectGetWidth(bounds) - middleLineWidth) * 0.5 ,
                                       (CGRectGetHeight(bounds) - _lineWidth) * 0.5,
                                       middleLineWidth,
                                       _lineWidth);
        [self addSublayer:_middleLine];
        
        [self setupUpLine];
        [self setupDownLine];
        
        [self setNeedsDisplay];
    }
    [super setBounds:bounds];
}

- (void)setupUpLine {
    _upLine.frame = CGRectMake(CGRectGetMinX(_middleLine.frame), CGRectGetMinY(_middleLine.frame), CGRectGetWidth(_middleLine.frame) * 0.5, _lineWidth);
    _upLine.transform = CATransform3DMakeRotation(-radians(40.0), 0.0, 0.0, 1.0);
    dx_ChangeLayerAnchorPointAndAjustPositionToStayFrame(_upLine, CGPointMake(0.0, 0.5));
    [self addSublayer:_upLine];
}

- (void)setupDownLine {
    _downLine.frame = CGRectMake(CGRectGetMinX(_middleLine.frame), CGRectGetMinY(_middleLine.frame), CGRectGetWidth(_middleLine.frame) * 0.5, _lineWidth);
    _downLine.transform = CATransform3DMakeRotation(radians(40.0), 0.0, 0.0, 1.0);
    dx_ChangeLayerAnchorPointAndAjustPositionToStayFrame(_downLine, CGPointMake(0.0, 0.5));
    [self addSublayer:_downLine];
}


@end
