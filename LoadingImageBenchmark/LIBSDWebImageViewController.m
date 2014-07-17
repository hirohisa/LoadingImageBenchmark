//
//  LIBSDWebImageViewController.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBSDWebImageViewController.h"

@interface LIBSDWebImageViewController ()

@end

@implementation LIBSDWebImageViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"SDWebImage";
    }
    return self;
}

- (BrickViewCell *)brickView:(BrickView *)brickView cellAtIndex:(NSInteger)index
{
    LIBBrickViewCell *cell = [brickView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[LIBBrickViewCell alloc] initWithReuseIdentifier:@"Cell"];
    }

    NSURL *URL = [self imageUrlForIndex:index];

    NSDate *initialDate = [NSDate date];

    [cell.imageView sd_setImageWithURL:URL placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:initialDate];
        [self trackRetrieveTime:interval];
    }];

    return cell;
}

@end
