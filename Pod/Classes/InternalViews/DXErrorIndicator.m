//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import "DXErrorIndicator.h"

@implementation DXErrorIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        DXCrossLayer *cross = [DXCrossLayer new];
        cross.bounds = self.bounds;
        [self setImage:cross.normalImage forState:UIControlStateNormal];
    }
    
    return self;
}

@end
