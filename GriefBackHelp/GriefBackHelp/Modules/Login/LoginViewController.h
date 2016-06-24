//
//  LoginViewController.h
//  griefhelp.ios
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic,copy) NSString * accountStr;
@property (nonatomic,copy) NSString * passwordStr;

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end
