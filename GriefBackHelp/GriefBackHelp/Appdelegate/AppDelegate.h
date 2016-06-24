//
//  AppDelegate.h
//  griefhelp.ios
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define appDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


// JPush
static NSString *appKey = @"11ba96efc8a9c0d6b382f9e1";
static NSString *channel = @"Publish channel";
static BOOL isProduction = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong,readonly) UINavigationController *nav;

@end

@interface UINavigationController (griefhelp) <UINavigationControllerDelegate>

- (void)pushLoginCotrller:(UIViewController*)controller;

@end