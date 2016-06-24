//
//  RushListController.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "RushListController.h"
#import "RushListItem.h"
#import "UIViewController+MMDrawerController.h"
#import "RushListView.h"
#import "ReplyView.h"

@interface RushListController ()

@property (nonatomic, strong) RushListView *rushLishView;
@property (nonatomic, strong) ReplyView *replyView;
@property (weak, nonatomic) IBOutlet UIView *panelView;

@end

@implementation RushListController

#pragma mark -- 懒加载
- (ReplyView *)replyView
{
    if (!_replyView) {
        _replyView = [[[NSBundle mainBundle]loadNibNamed:@"ReplyView" owner:self options:nil]lastObject];
        _replyView.tag = 1004;
        _replyView.frame = CGRectMake(0, 0, _panelView.frame.size.width, _panelView.frame.size.height);
        _replyView.ctrl = self;
        [_replyView refresh];
        [_panelView addSubview:_replyView];
    }
    return _replyView;
}
- (RushListView *)rushLishView
{
    if (!_rushLishView) {
        
        _rushLishView = [[[NSBundle mainBundle]loadNibNamed:@"RushListView" owner:self options:nil]lastObject];
        
        _rushLishView.tag = 1003;
        _rushLishView.frame = CGRectMake(0, 100, _panelView.frame.size.width, _panelView.frame.size.height);
        _rushLishView.ctrl = self;
        
        [_panelView addSubview:_rushLishView];
    }
    return _rushLishView;
}

@synthesize datas;

@synthesize selIndex;

@synthesize tableview;
@synthesize nullview;

@synthesize detailctrl;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"rushsuc" object:nil];
}

#pragma mark -- view周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.datas = [NSMutableArray array];
    _skip = 0;
    selIndex = -1;
    [self.panelView layoutIfNeeded];
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (![_panelView viewWithTag:1003]) {
        
        [self.rushLishView refreshData];
    }
    
    [self showRushListTableView:nil];
    
    NSLog(@"sush .frame %@",NSStringFromCGRect(_rushLishView.frame));
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        if ([kLoginUrl isEqualToString:@"http://user.banana.vocinno.com/"]&&[kWriteBackUrl isEqualToString:@"http://story.banana.vocinno.com/"]&&[kMailListUrl isEqualToString:@"http://assistant.banana.vocinno.com/"]) {
            
            UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
            alertLabel.center = self.view.center;
            alertLabel.text = @"这是测试服";
            alertLabel.textAlignment = NSTextAlignmentCenter;
            alertLabel.backgroundColor = [UIColor colorWithRed:1.000 green:0.990 blue:0.973 alpha:1.000];
            [self.view addSubview:alertLabel];
            [UIView animateWithDuration:3 animations:^{
                alertLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [alertLabel removeFromSuperview];
            }];
        }
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    //抢单按钮隐藏
    detailctrl.rushbtn.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear: animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

#pragma mark -- tableView 代理

#pragma mark -- 自定义方法






- (IBAction)OnNewDown:(UIButton*)sender
{
    [self.rushLishView refreshData];
}





#pragma mark -- 退出登录
- (IBAction)logoutAction:(id)sender {
    //退出登录弹框
    NSString *message = @"登录信息已过期，请重新登录";
    NSArray *actions = [NSArray arrayWithObjects:
                        [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 回到自动登录界面
        [appDelegate.nav pushLoginCotrller:[[DisguiserViewController alloc]init]];
        
    }], [UIAlertAction actionWithTitle:@"更换账户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc] init]];
    }],nil];
    
    if (message)
    {
        if (0 == [actions count]) [self showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        else [self showAlterView:Alert_Title_Notice Message:message Actions:actions];
    }
}

#pragma mark -- 打开关闭抽屉的方法

- (IBAction)openOrCloseDrawer:(id)sender {
    static BOOL isopen ;
    if (!isopen) {
        [self.tabBarController.mm_drawerController openDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
        isopen = NO;
    }
    else
    {
        [self.tabBarController.mm_drawerController closeDrawerAnimated:YES completion:nil];
        isopen = YES;
    }
}

#pragma mark -- 切换tableView
// 显示抢单页面
- (IBAction)showRushListTableView:(id)sender {
    [self.panelView bringSubviewToFront:self.rushLishView];
//    [self.rushLishView refreshData];
    
   
}

// 显示新任务页面
- (IBAction)showNewTaskTableView:(id)sender {
    
    [self.panelView bringSubviewToFront:self.replyView];
//    [self.replyView refresh];
}

@end
