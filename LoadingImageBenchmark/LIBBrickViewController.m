//
//  LIBBrickViewController.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBBrickViewController.h"

NSInteger numberOfRetrievedImages = 0;
NSTimeInterval totalTime = 0.;
NSTimeInterval minTime = -1.;
NSTimeInterval maxTime = 0.;

NSDate *startDate;
static NSInteger const LIBImageViewCount = 100;

@implementation LIBBrickViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [UIImageView new];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}

@end

@interface LIBBrickViewController ()

@end

@implementation LIBBrickViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self LIB_configure];
    }
    return self;
}

- (void)LIB_configure
{
    numberOfRetrievedImages = 0;
    _timeToRetrieveImages = 0.;
    totalTime = 0.;
    minTime = -1.;
    maxTime = 0.;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    startDate = [NSDate date];

    self.brickView = [[BrickView alloc] initWithFrame:self.view.bounds];
    self.brickView.dataSource = self;
    self.brickView.delegate   = self;
    [self.view addSubview:self.brickView];
}

- (CGFloat)brickView:(BrickView *)brickView heightForCellAtIndex:(NSInteger)index
{
    return 20;
}

- (NSInteger)numberOfCellsInBrickView:(BrickView *)brickView
{
    return LIBImageViewCount;
}

- (NSInteger)numberOfColumnsInBrickView:(BrickView *)brickView
{
    return 4;
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    return nil;
}


- (NSURL*)imageUrlForIndex:(NSInteger)index {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03ld.jpg", (long)index]];

    return URL;
}

#pragma mark - tracking

- (void)trackRetrieveTime:(NSTimeInterval)time
{
    NSLog(@"[%@] retrieved in %.4f",
          self.title,
          time
          );

    dispatch_async(dispatch_get_main_queue(), ^{

        numberOfRetrievedImages++;
        totalTime += time;

        if (minTime < 0 || minTime > time) {
            minTime = time;
        }
        if (maxTime < time) {
            maxTime = time;
        }

        if (numberOfRetrievedImages == LIBImageViewCount) {
            _timeToRetrieveImages = [[NSDate date] timeIntervalSinceDate:startDate];

            NSLog(@"[%@] finish to retrieve images in %.4f, average %.4f, min %.4f, max %.4f",
                  self.title,
                  self.timeToRetrieveImages,
                  totalTime/numberOfRetrievedImages,
                  minTime,
                  maxTime
                  );
        }
    });

}

@end
