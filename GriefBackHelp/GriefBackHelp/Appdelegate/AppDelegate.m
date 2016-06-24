//
//  AppDelegate.m
//  griefhelp.ios
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "JPUSHService.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _window = [[UIWindow alloc] init];
    _window.frame = [UIScreen mainScreen].bounds;
    
    DisguiserViewController *loginVC = [[DisguiserViewController alloc]init];
    
    UINavigationController* navctrl = [[UINavigationController alloc]initWithRootViewController:loginVC];
    navctrl.navigationBar.hidden = YES;
    
    _nav = navctrl;
    _window.rootViewController = navctrl;
    [_window makeKeyAndVisible];
    
    
    //e8f740784b2d93f49da84218 JPush
    [self JPushWithLaunchOption:launchOptions];
    
    return YES;
}


- (void)JPushWithLaunchOption:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
}

// 推送注册返回
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"注册 %@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;// 清除应用程序的角标
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end


@implementation UINavigationController (griefhelp)

- (void)pushLoginCotrller:(UIViewController*)controller
{
    
    [self pushViewController:controller animated:YES];
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[LoginViewController class]] && animated)
    {
        NSArray* ctrls = self.viewControllers;
        [self setViewControllers:@[[ctrls firstObject], viewController] animated:NO];
    }
    else if ([viewController isKindOfClass:[DisguiserViewController class]] && animated)
    {
        NSArray* ctrls = self.viewControllers;
        [self setViewControllers:@[[ctrls firstObject], viewController] animated:NO];
    }
}

@end
