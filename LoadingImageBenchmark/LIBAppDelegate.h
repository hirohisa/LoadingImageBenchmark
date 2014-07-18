//
//  LIBAppDelegate.h
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

@interface LIBAppDelegate (PerformanceTest)

// https://github.com/bpoplauschi/ImageCachingBenchmark
- (void)resetUsage;
- (void)updateUsage:(NSString *)title;

@end
