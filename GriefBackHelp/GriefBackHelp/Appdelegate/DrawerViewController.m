//
//  DrawerViewController.m
//  GriefBackHelp
//
//  Created by WangJun on 16/6/22.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import "DrawerViewController.h"
#import "MineInfoViewController.h"
#import "MMExampleDrawerVisualStateManager.h"


@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarController *tabBarC = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil]instantiateInitialViewController];
    
    MineInfoViewController *mineInfoVC = [[MineInfoViewController alloc]initWithNibName:@"MineInfoViewController" bundle:nil];
    
    
    self.leftDrawerViewController = mineInfoVC;
    self.centerViewController = tabBarC;
    [self setShowsShadow:NO];
//    [self setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeTapCenterView];
    
    
    [self setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
        MMDrawerControllerDrawerVisualStateBlock block;
        block = [[MMExampleDrawerVisualStateManager sharedManager]
                 drawerVisualStateBlockForDrawerSide:drawerSide];
        if(block){
            block(drawerController, drawerSide, percentVisible);
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
