//
//  DXPhotoBrowser
//
//  Created by xiekw on 15/5/30.
//  Copyright (c) 2015年 xiekw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (dx_AppleBlur)

// apple wwdc session code for the blur
- (UIImage *)dx_applyLightEffect;
- (UIImage *)dx_applyExtraLightEffect;
- (UIImage *)dx_applyDarkEffect;
- (UIImage *)dx_applyGrayEffect;
- (UIImage *)dx_applyTintEffectWithColor:(UIColor *)tintColor;
- (UIImage *)dx_applyBlackEffect;
- (UIImage *)dx_applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage;

@end

@interface UIImage (dx_Light)

- (UIImage *)dx_cropImageWithRect:(CGRect)cropRect;
- (BOOL)dx_isLight;
- (UIColor *)dx_averageColor;

@end
