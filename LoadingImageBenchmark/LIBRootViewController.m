//
//  LIBRootViewController.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBRootViewController.h"

#import "LIBImageLoaderViewController.h"
#import "LIBSDWebImageViewController.h"
#import "LIBAFNetworkingViewController.h"

@interface UIImageView (LIBRootViewController)

+ (ImageLoader *)il_sharedImageLoader;

@end

@interface LIBRootViewController ()

@end

@implementation LIBRootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Performance Test";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)resetCaches
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];

    // ImageLoader
    NSCache *cache = [[UIImageView class] il_sharedImageLoader].cache;
    [cache removeAllObjects];

    // SDWebImage
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];

    // AFNetworking
    [(NSCache *)[UIImageView sharedImageCache] removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"ImageLoader";
            break;

        case 1:
            cell.textLabel.text = @"SDWebImage";
            break;

        case 2:
            cell.textLabel.text = @"AFNetworking";
            break;
    }


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resetCaches];

    UIViewController *viewController;
    switch (indexPath.row) {
        case 0:
            viewController = [LIBImageLoaderViewController new];
            break;

        case 1:
            viewController = [LIBSDWebImageViewController new];
            break;

        case 2:
            viewController = [LIBAFNetworkingViewController new];
            break;
    }

    [self.navigationController pushViewController:viewController animated:YES];
}

@end
