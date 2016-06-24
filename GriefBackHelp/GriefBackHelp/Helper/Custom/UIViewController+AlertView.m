//
//  UIViewController+AlertView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "UIViewController+AlertView.h"

@implementation UIViewController (AlertView)

- (void)showNormalAlertView:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)canceltitle
{
    UIAlertController* alertctrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertctrl addAction:[UIAlertAction actionWithTitle:canceltitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //
    }]];
    
    [self presentViewController:alertctrl animated:YES completion:^{
        //
    }];
}

- (void)showAlterView:(NSString*)title Message:(NSString*)message Actions:(NSArray*)actions
{
    UIAlertController* alertctrl = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (UIAlertAction* action in actions)
    {
        [alertctrl addAction:action];
    }
    
    [self presentViewController:alertctrl animated:YES completion:^{
        //
    }];
}

@end
