//
//  LIBBrickViewController.h
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BrickView/BrickView.h>

@interface LIBBrickViewCell : BrickViewCell

@property (nonatomic, readonly) UIImageView *imageView;

@end

@interface LIBBrickViewController : UIViewController <BrickViewDataSource, BrickViewDelegate>

@property (nonatomic, strong) BrickView *brickView;

@property (nonatomic, readonly) NSTimeInterval timeToRetrieveImages;

- (NSURL*)imageUrlForIndex:(NSInteger)index;
- (void)trackRetrieveTime:(NSTimeInterval)time;

@end
