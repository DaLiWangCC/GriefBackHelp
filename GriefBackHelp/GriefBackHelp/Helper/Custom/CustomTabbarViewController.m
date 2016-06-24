//
//  CustomTabbarViewController.m
//  griefhelp
//
//  Created by pc-01 on 16/5/4.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "CustomTabbarViewController.h"
#import "CustomTabbarView.h"

@interface CustomTabbarViewController ()

@end

@implementation CustomTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self configTabbarView];
}


- (void)configTabbarView {
    
    self.tabBar.hidden=YES;//隐藏掉系统的bar
    __weak __block CustomTabbarViewController *blockSelf = self;
    CustomTabbarView * tabbarView = [CustomTabbarView getInstance];
    [tabbarView setBlock:^(NSInteger tag) {
        [blockSelf setSelectedIndex:tag];
    }];
    [self.view addSubview:tabbarView];
    
}


@end
