//
//  DXViewController.h
//  DXPhotoBrowser
//
//  Created by kaiwei.xkw on 09/16/2015.
//  Copyright (c) 2015 kaiwei.xkw. All rights reserved.
//

#import <Nimbus/NimbusCollections.h>

@import UIKit;

@interface DXViewController : UIViewController

@end

@interface SimplePhotoCell : UICollectionViewCell<NICollectionViewCell>

@property (nonatomic, strong) UIImageView *imageView;

@end
