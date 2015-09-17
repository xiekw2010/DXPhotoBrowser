# DXPhotoBrowser

[![Version](https://img.shields.io/cocoapods/v/DXPhotoBrowser.svg?style=flat)](http://cocoapods.org/pods/DXPhotoBrowser)
[![License](https://img.shields.io/cocoapods/l/DXPhotoBrowser.svg?style=flat)](http://cocoapods.org/pods/DXPhotoBrowser)
[![Platform](https://img.shields.io/cocoapods/p/DXPhotoBrowser.svg?style=flat)](http://cocoapods.org/pods/DXPhotoBrowser)

Yet another photo browser of displaying images.

## Demo

![demoImage](./demo.gif)

## Bonus

1. Maybe the easist api of using.
2. Animate expand and shrink from some view.
3. Support Gesture dismiss.
4. When pull to right end, it will trigger some event if you imp the delegate.


## API

    _simplePhotoBrowser = [[DXPhotoBrowser alloc] initWithPhotosArray:@[ id<DXPhoto> ]];
    [_simplePhotoBrowser showPhotoAtIndex:someIndexWithThePhotos withThumbnailImageView:someImageViewOrNil];
    
#### Embed with SDWebImage

`id<DXPhoto>` required protocol method `loadImageWithProgressBlock:completionBlock:` could be imp like this

	- (void)loadImageWithProgressBlock:(DXPhotoProgressBlock)progressBlock completionBlock:(DXPhotoCompletionBlock)completionBlock {
	    __weak typeof(self) wself = self;
	    SDWebImageCompletionWithFinishedBlock finishBlock = ^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
	        if (completionBlock) {
	            completionBlock(wself, image);
	        }
	    };
	    
	    _operation = [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:_imageURL] options:1 progress:nil completed:finishBlock];
	}
		
	- (void)cancelLoadImage {
	    [_operation cancel];
	    _operation = nil;
	}

For more details best practises, check [DXSimplePhoto](https://github.com/xiekw2010/DXPhotoBrowser-DXSimplePhoto).

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS '~6.0'

## Installation

DXPhotoBrowser is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "DXPhotoBrowser"
```

## License

DXPhotoBrowser is available under the MIT license. See the LICENSE file for more info.
