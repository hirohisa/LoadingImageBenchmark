//
//  LIBAppDelegate.m
//  LoadingImageBenchmark
//
//  Created by Hirohisa Kawasaki on 2014/07/17.
//  Copyright (c) 2014年 Hirohisa Kawasaki. All rights reserved.
//

#import "LIBAppDelegate.h"
#import "LIBRootViewController.h"

#include <mach/mach.h>

float maxCPUUsage = 0;
float totalCPUUsage = 0;
int numberOfCPUCycles = 0;

float maxMemoryUsage = 0;
float totalMemoryUsage = 0;
int numberOfMemoryCycles = 0;

@implementation LIBAppDelegate (PerformanceTest)

- (void)resetUsage
{
    maxCPUUsage = 0;
    totalCPUUsage = 0;
    numberOfCPUCycles = 0;

    maxMemoryUsage = 0;
    totalMemoryUsage = 0;
    numberOfMemoryCycles = 0;
}

- (void)updateUsage:(NSString *)title
{
    float cpuUsage = cpu_usage();
    if (cpuUsage) {
        numberOfCPUCycles++;
        totalCPUUsage += cpuUsage;

        if (cpuUsage > maxCPUUsage) {
            maxCPUUsage = cpuUsage;
        }

        NSLog(@"[%@] CPU Usage: %.4f, average %.4f, max %.4f", title, cpuUsage, totalCPUUsage/numberOfCPUCycles, maxCPUUsage);
    }

    float memoryUsage = memory_usage_in_megabytes();
    if (memoryUsage) {
        numberOfMemoryCycles++;
        totalMemoryUsage += memoryUsage;

        if (memoryUsage > maxMemoryUsage) {
            maxMemoryUsage = memoryUsage;
        }

        NSLog(@"[%@] Memory Usage: %.4F, average %.4f, max %.4f", title, memoryUsage, totalMemoryUsage/numberOfMemoryCycles, maxMemoryUsage);
    }
}

void free_up_memory() {

}

// from http://www.g8production.com/post/68155681673/get-cpu-usage-in-ios
float cpu_usage() {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;

    basic_info = (task_basic_info_t)tinfo;

    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    }

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return tot_cpu;
}

// http://stackoverflow.com/questions/787160/programmatically-retrieve-memory-usage-on-iphone
float memory_usage_in_megabytes() {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        return info.resident_size / (1024 * 1024);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    return 0;
}

@end


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
