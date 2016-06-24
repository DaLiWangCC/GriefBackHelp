//
//  DisguiserViewController.m
//  laohaowan
//
//  Created by xulei on 16/3/18.
//
//

#import "DisguiserViewController.h"
#import "RushListController.h"




@interface DisguiserViewController ()
@end

@implementation DisguiserViewController {
    NSString * userName;
    NSString * passWord;
    
}
#ifdef _FOR_DEBUG_
-(BOOL) respondsToSelector:(SEL)aSelector {
    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);
    return [super respondsToSelector:aSelector];
}
#endif
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self whetherAutoLogin];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enterTabbarViewController {
    UIStoryboard * stryBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    
    [appDelegate.nav setViewControllers:@[[stryBoard instantiateInitialViewController]] animated:YES];
    
}

- (void)enterLoginViewController:(NSString*)account andPassWord:(NSString*)passCode{
    LoginViewController* loginctrl = [[LoginViewController alloc] init];
    loginctrl.accountStr = account;
    loginctrl.passwordStr = passCode;
    [self.navigationController pushViewController:loginctrl animated:NO];
}

// 判断是否自动登录
- (void)whetherAutoLogin {
    
    // 得到上次用户名密码
    NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    NSDate *lastDate = [[NSUserDefaults standardUserDefaults]objectForKey:@"date"];
    
    if (username && password && lastDate) {
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
            [self enterLoginVCwith:@""];
        }
        else {
            // 自动登录
            NSString *urlStr = [NSString stringWithFormat:@"%@vocinno/user/login?primaryKey=%@&password=%@&phoneType=1&platform=4",kLoginUrl,username,password];
            
            [[RequestManager sharedRequestManager] getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic,NSString *codeStr) {
                NSLog(@"登录验证成功  code = %@",codeStr);
                
                [self enterTabBarVC];
                if (requestDic[@"token"]) {
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    [user setObject:requestDic[@"token"] forKey:@"token"];
                    [user setObject:[NSDate date] forKey:@"date"];
                    
                }
            } failure:^(NSString *errorInfo) {
                NSLog(@"登录错误 %@",errorInfo);
                [self enterLoginVCwith:@""];
            }];
            
        }
    }
    // 没有本地用户密码
    else {
        [self enterLoginVCwith:@""];
    }
    
    
}

// 跳转至loginVC
- (void)enterLoginVCwith:(NSString*)username
{
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    loginVC.accountStr = username;
    [appDelegate.nav pushLoginCotrller:loginVC];
}

// 跳转至tabbarVC
- (void)enterTabBarVC
{
    UIStoryboard * stryBoard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
    [appDelegate.nav setViewControllers:@[[stryBoard instantiateInitialViewController]] animated:YES];
    
}

- (void)handleJSNotification:(const char*)name body:(const char*)body
{
    
}


- (void)dealloc {
    
}

@end
