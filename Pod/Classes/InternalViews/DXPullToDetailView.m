//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "DXPullToDetailView.h"

@implementation DXPullToDetailView {
    UIImageView *_arrow;
    UILabel *_textLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    frame.size.width = 200.0;
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 20.0)];
        _arrow.center = CGPointMake(15.0, CGRectGetMidY(self.bounds));
        UIImage *previewImage = [UIImage imageNamed:@"preview_indicator"];
        if (!previewImage) {
            DXArrowLayer *arrowLayer = [DXArrowLayer new];
            arrowLayer.bounds = _arrow.bounds;
            previewImage = [arrowLayer normalImage];
        }
        _arrow.image = previewImage;
        [self addSubview:_arrow];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_arrow.frame) + 10.0, 0.0, 15.0, CGRectGetHeight(self.bounds))];
        _textLabel.numberOfLines = 0.0;
        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:CGRectGetWidth(_textLabel.frame) - 1.0];
        [self addSubview:_textLabel];
    }

    return self;
}

- (void)setPulling:(BOOL)pulling animated:(BOOL)animated
{
    CGFloat duration = animated ? 0.2 : 0.0;

    if (_pulling != pulling) {
        if (pulling) {
            [UIView animateWithDuration:duration
                             animations:^{
                                 _arrow.transform = CGAffineTransformMakeRotation((M_PI));
                             }];
            _textLabel.text = _releasingText;
        }
        else {
            [UIView animateWithDuration:duration
                             animations:^{
                                 _arrow.transform = CGAffineTransformIdentity;
                             }];
            _textLabel.text = _pullingText;
        }
        _pulling = pulling;
    }
}

- (void)setPulling:(BOOL)pulling { [self setPulling:pulling animated:NO]; }

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    if (newWindow) {
        _arrow.transform = CGAffineTransformIdentity;
        _textLabel.text = _pullingText;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _arrow.center = CGPointMake(15.0, CGRectGetMidY(self.bounds));
    _textLabel.frame = CGRectMake(CGRectGetMaxX(_arrow.frame) + 10.0, 0.0, 15.0, CGRectGetHeight(self.bounds));
}

@end
