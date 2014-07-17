//
//  LIBAppDelegate.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBAppDelegate.h"
#import "LIBRootViewController.h"

@implementation LIBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    self.window.backgroundColor = [UIColor whiteColor];

    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:[[LIBRootViewController alloc] initWithStyle:UITableViewStyleGrouped]];

    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];

    return YES;
}

@end
