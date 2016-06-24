//
//  RecordController.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "MineController.h"

@interface MineController ()

@end

@implementation MineController
{
    BOOL    isInited;
}

@synthesize panel;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replysuc" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _tempBtn = self.recordBtn;
    isInited = NO;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReplySucNotification:) name:@"replysuc" object:nil];
    
    
   
    [panel layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![panel viewWithTag:3]) {
        [self addSubviews];
    }
}

- (void)setQuitLabel
{
//    CGRect frame = [UIScreen mainScreen].bounds;
    
    UILabel *quitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 80, 80)];
    quitLabel.userInteractionEnabled = YES;
    quitLabel.backgroundColor = [UIColor clearColor];
    quitLabel.tag = 1001;
    
    [panel addSubview:quitLabel];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(quitLoginAction:)];
    longPress.minimumPressDuration = 3;
    [quitLabel addGestureRecognizer:longPress];
    
}


- (void)addSubviews {
    NSBundle* bundle = [NSBundle mainBundle];
    ReplyView* replyview = [[bundle loadNibNamed:@"ReplyView" owner:self options:nil] lastObject];
    replyview.tag = 3;
    replyview.frame = panel.bounds;
    replyview.ctrl = self;
    [panel addSubview:replyview];
    
    RecordView* recordview = [[bundle loadNibNamed:@"RecordView" owner:self options:nil] lastObject];
    recordview.tag = 4;
    recordview.frame = panel.bounds;
    recordview.ctrl = self;
    [panel addSubview:recordview];
    
    [self OnTabDown:self.recordBtn];
    
    //设置退出登录label
    [self setQuitLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)OnTabDown:(UIButton*)sender
{
  
    _tempBtn.selected = NO;
    UIView* view = [panel viewWithTag:sender.tag];
    _tempBtn = sender;
    _tempBtn.selected = YES;
    
    if (3 == sender.tag)
    {
        self.segmentImage.image = [UIImage imageNamed:@"histroy_segment_button"];
        ReplyView* newview = (ReplyView*)view;
        if (0 == [newview.datas count] && UNTable_Free == [newview.tableView getFooter].m_enState)
        {
            [newview refresh];
        }
    }
    else if (4 == sender.tag)
    {
        self.segmentImage.image = [UIImage imageNamed:@"review_segment_button"];
        RecordView* recordview = (RecordView*)view;
        if (0 == [recordview.datas count] && UNTable_Free == [recordview.tableView getFooter].m_enState)
        {
            [recordview refresh];
        }
    }
    
    [panel bringSubviewToFront:view];
    UILabel *label = [panel viewWithTag:1001];
    [panel bringSubviewToFront:label];
}

- (void)handleReplySucNotification:(NSNotification*)notification
{
//    if (1 == tabSel.tag)
//    {
//        NewRushListView* newlist = (NewRushListView*)[panel viewWithTag:1];
//        [newlist refresh];
//    }
//    else if (2 == tabSel.tag)
//    {
//        AgainWriteBackView* agaview = (AgainWriteBackView*)[panel viewWithTag:2];
//        [agaview refresh];
//    }
//    else ;
    
    ReplyView* replyview = (ReplyView*)[panel viewWithTag:3];
    [replyview refresh];
    
    RecordView* recordview = (RecordView*)[panel viewWithTag:4];
    [recordview refresh];
}


// 隐藏的退出登录
- (void)quitLoginAction:(id)sender {
    
    NSLog(@"长按了");
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userName = [user objectForKey:@"username"];
    NSString *password = [user objectForKey:@"password"];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://user.tomato.vocinno.com/vocinno/user/login?primaryKey=%@&password=%@&phoneType=1&platform=4",userName,password];
    NSURL *url=[NSURL URLWithString:urlStr];
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask=[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (dict[@"error"]) {
            
            NSLog(@"%@",dict[@"error"]);
            
        }
        
        else
            
        {
            
            NSLog(@"%@",dict[@"success"]);
            
        }
        
    } ];
    
    [dataTask resume];
    
    
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

@end
