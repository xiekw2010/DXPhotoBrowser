//
//  DXViewController.m
//  DXPhotoBrowser
//
//  Created by kaiwei.xkw on 09/16/2015.
//  Copyright (c) 2015 kaiwei.xkw. All rights reserved.
//

#import "DXViewController.h"
#import <DXPhotoBrowser/DXPhoto.h>
#import <DXPhotoBrowser/DXPhotoBrowser.h>
#import <SDWebImage/SDWebImageManager.h>
#import <UIScrollView+DXRefresh.h>
#import <Placeholder.h>
#import <Nimbus/NimbusCollections.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <DXPhotoBrowser/DXPullToDetailView.h>

@interface HRDemoSimplePhoto : NSObject<DXPhoto>

@property (nonatomic, strong, readonly) NSString *imageURL;

+ (instancetype)photoWithImageURL:(NSString *)imageURL imageSize:(CGSize)imageSize;

@end

@implementation HRDemoSimplePhoto {
    UIImage *_placeholder;
    NSString *_imageURL;
    id<SDWebImageOperation> _operation;
    CGSize _imageSize;
}

+ (instancetype)photoWithImageURL:(NSString *)imageURL imageSize:(CGSize)imageSize {
    HRDemoSimplePhoto *photo = [HRDemoSimplePhoto new];
    photo->_imageURL = imageURL;
    photo->_imageSize = imageSize;
    return photo;
}

- (UIImage *)placeholder {
    return _placeholder;
}

- (void)loadImageWithProgressBlock:(DXPhotoProgressBlock)progressBlock
                   completionBlock:(DXPhotoCompletionBlock)completionBlock {
    
    __weak typeof(self) wself = self;
    SDWebImageCompletionWithFinishedBlock finishBlock
    = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!error && image) {
            _placeholder = image;
            if (completionBlock) {
                completionBlock(wself, image);
            }
        }
    };
    
    _operation = [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imageURL] options:1 progress:nil completed:finishBlock];
}

- (CGSize)expectImageSize {
    return _imageSize;
}

- (void)cancelLoadImage {
    [_operation cancel];
    _operation = nil;
}

@end

@interface DXViewController ()<DXPhotoBrowserDelegate, UICollectionViewDelegate>

@property (nonatomic, strong) DXPhotoBrowser *simplePhotoBrowser;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSArray *imageSizeArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NICollectionViewModel *model;
@property (nonatomic, strong) NSMutableArray *cellObjs;

@end

@implementation DXViewController

- (DXPhotoBrowser *)simplePhotoBrowser {
    _simplePhotoBrowser = [[DXPhotoBrowser alloc] initWithPhotosArray:[self.cellObjs valueForKey:@"userInfo"]];
    _simplePhotoBrowser.delegate = self;
        
    return _simplePhotoBrowser;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SimplePhotoCell *cell = (SimplePhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    [self.simplePhotoBrowser showPhotoAtIndex:indexPath.item withThumbnailImageView:cell];
//    [self.simplePhotoBrowser showPhotoAtIndex:indexPath.item withThumbnailImageView:nil];
}

// change status bar style check -> http://stackoverflow.com/questions/19447137/changing-status-bar-style-ios-7
- (void)simplePhotoBrowserWillShow:(DXPhotoBrowser *)photoBrowser {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)simplePhotoBrowserDidHide:(DXPhotoBrowser *)photoBrowser {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
}

- (void)simplePhotoBrowserDidTriggerPullToRightEnd:(DXPhotoBrowser *)photoBrowser {
    NSLog(@"trigger something");
    [DXPhotoBrowser new];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    CGFloat const inset = 3.0;
    CGFloat const eachLineCount = 3;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = inset;
    flowLayout.minimumLineSpacing = inset;
    flowLayout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    CGFloat width = (CGRectGetWidth(self.view.bounds)-(eachLineCount+1)*inset)/eachLineCount;
    flowLayout.itemSize = CGSizeMake(width, width);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    self.imageSizeArray = @[
                            [NSValue valueWithCGSize:CGSizeMake(320.0, 200.0)],
                            [NSValue valueWithCGSize:CGSizeMake(320.0, 200.0)],
                            [NSValue valueWithCGSize:CGSizeMake(CGRectGetWidth(self.view.bounds), 200.0)],
                            [NSValue valueWithCGSize:self.view.bounds.size]
                            ];
    
    [self.collectionView addHeaderWithTarget:self action:@selector(refresh)];
    
    [self refresh];
}

- (void)refresh {
    NSMutableArray *result = [NSMutableArray array];
    for (NSUInteger i = 0; i < 100; i ++) {
        HRDemoSimplePhoto *simplePhoto = [HRDemoSimplePhoto photoWithImageURL:[Placeholder imageURL] imageSize:CGSizeZero];
        NICollectionViewCellObject *obj = [[NICollectionViewCellObject alloc] initWithCellClass:[SimplePhotoCell class] userInfo:simplePhoto]
        ;
        
        [result addObject:obj];
    }
    
    self.cellObjs = result;
    
    NICollectionViewModel *model= [[NICollectionViewModel alloc] initWithListArray:result delegate:(id)[NICollectionViewCellFactory class]];
    self.model = model;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self.model;
    
    [self.collectionView headerEndRefreshing];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation SimplePhotoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleDimensions;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
    }
    return self;
}

- (BOOL)shouldUpdateCellWithObject:(id)object {
    HRDemoSimplePhoto *item = [object userInfo];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:item.imageURL] placeholderImage:[Placeholder imageWithSize:CGSizeMake(100, 100)]];
    
    return YES;
}

@end
