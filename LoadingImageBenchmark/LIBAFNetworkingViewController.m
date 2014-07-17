//
//  LIBAFNetworkingViewController.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBAFNetworkingViewController.h"

@interface LIBAFNetworkingViewController ()

@end

@implementation LIBAFNetworkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"AFNetworking";
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

    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    [cell.imageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.imageView.image = image;

        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:initialDate];
        [self trackRetrieveTime:interval];
    } failure:NULL];

    return cell;
}

@end
