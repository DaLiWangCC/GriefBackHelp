//
//  LoginViewController.m
//  griefhelp.ios
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _usernameTF.delegate = self;
    _passwordTF.delegate = self;
    [self whetherKeepUsername];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_usernameTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
}

#pragma mark -- textField代理

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _passwordTF) {
        
        NSLog(@"开始编辑密码");
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark -- 登录方法

- (void)whetherKeepUsername
{
    // 得到上次用户名密码
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    //    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"date"];
    
    if (username && lastDate) {
        // 计算时间差
        NSDate *currentDate = [NSDate date];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        NSDateComponents *components = [calendar components:unitFlags fromDate:lastDate toDate:currentDate options:0];
        
        long sec = [components hour]*3600+[components minute]*60+[components second];
        NSLog(@"上次登录 %ld 秒前",sec);
        
        // 48小时
        if (sec > 172800) {
            // 重新登录
            _usernameTF.text = @"";
        }
        else {
            _usernameTF.text = username;
        }
        
    }
}

- (IBAction)LoginAction:(id)sender {
    
    NSString* message = nil;
    
    if (0 == [_usernameTF.text length])
    {
        message = @"登录名不能为空";
    }
    else if (0 == [_passwordTF.text length])
    {
        message = @"登录密码不能为空";
    }
    else ;
    
    if (message)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }]];
        
        [self presentViewController:alert animated:YES completion:^{
            //
        }];
    }
    else
    {
        [self sendLoginRequest:_usernameTF.text Password:_passwordTF.text];
    }
}

// 登录请求
- (void)sendLoginRequest:(NSString*)username Password:(NSString*)pwd
{
    NSString *urlStr = [NSString stringWithFormat:@"%@vocinno/user/login?primaryKey=%@&password=%@&phoneType=1&platform=4",kLoginUrl,username,pwd];
    
    [[RequestManager sharedRequestManager] getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic,NSString *codeStr) {
        NSLog(@"登录验证成功  code = %@",codeStr);
        
        [self enterTabBarVC];
        if (requestDic[@"token"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            [user setObject:requestDic[@"token"] forKey:@"token"];
            [user setObject:_passwordTF.text forKey:@"password"];
            [user setObject:_usernameTF.text forKey:@"username"];
            [user setObject:[NSDate date] forKey:@"date"];
        }
    } failure:^(NSString *errorInfo) {
        NSLog(@"code码 %@",errorInfo);
        if ([errorInfo isEqualToString:@"0"]) {
            [self showNormalAlertView:Alert_Title_Notice Message:NoInternet_Error CancelTitle:Alert_Cancel_Title];
            
        }
    }];
    
}


// 跳转至tabbarVC
- (void)enterTabBarVC
{
    UIStoryboard * stryBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    [appDelegate.nav setViewControllers:@[[stryBoard instantiateInitialViewController]] animated:YES];
    
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
