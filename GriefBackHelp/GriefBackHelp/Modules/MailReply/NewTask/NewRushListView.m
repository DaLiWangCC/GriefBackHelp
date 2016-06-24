//
//  NewRushListView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "NewRushListView.h"
#import "RushListItem.h"
#import "ReplyCell.h"

@implementation NewRushListView {
    
    NSMutableArray * items;
}

@synthesize tableview;
@synthesize nullview;

@synthesize ctrl;
//@synthesize datas;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UINib* nib = [UINib nibWithNibName:@"ReplyCell" bundle:[NSBundle mainBundle]];
        [tableview registerNib:nib forCellReuseIdentifier:@"cell"];
        return self;
    }
    
    return nil;
}


- (void)awakeFromNib
{
    UINib* nib = [UINib nibWithNibName:@"ReplyCell" bundle:[NSBundle mainBundle]];
    [tableview registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.datas = [NSMutableArray array];
    _skip = 0;
    
    UNTableRefreshFooter* footer = [[UNTableRefreshFooter alloc] initWithFrame:CGRectMake(0, tableview.contentSize.height, tableview.frame.size.width, 50) Scroll:tableview];
    [tableview setFooter:footer];
    __weak typeof(self) blockself = self;
    [footer setCallback:^(UNTableRefreshFooter *footer) {
        [blockself didTableViewScroolToBottom];
    }];
    
    UNTableRefreshHeader* header = [[UNTableRefreshHeader alloc] initWithFrame:CGRectMake(0, -50, tableview.frame.size.width, 50) Scroll:tableview];
    [header setCallback:^(UNTableRefreshHeader *header) {
        [blockself didTableViewScroollToTop];
    }];
    [tableview setHeader:header];
    
    items = [NSMutableArray array];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyCell* cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    return (UITableViewCell*)cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count == 0) {
        return;
    }
    ReplyCell* cellex = (ReplyCell*)cell;
    MyListItem* item = [self.datas objectAtIndex:indexPath.row];
    
    if (item.firstUserMailTime) {
        
        cellex.date.text = [[TimeTool defaultTool] timestampToString:item.firstUserMailTime / 1000 Format:@"yyyy-MM-dd"];
    }
    cellex.content.text = item.mail.brief; // 外部显示的摘要
    cellex.stateImage.hidden = YES;
    cellex.state.text = item.isFirstTime == YES ? @"最新抢单" : @"二次回信";
    cellex.state.textColor= item.isFirstTime == YES ? [UIColor greenColor] : [UIColor blueColor];
    cellex.stateview.hidden = NO;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyListItem* item = [self.datas objectAtIndex:indexPath.row];
    DetailController* detailctrl = [[DetailController alloc] init];
    detailctrl.isEdit = YES;
    detailctrl.mailid = item.mail._id;
    detailctrl.url = item.mail.url;
    detailctrl.userid = item.userId;
    detailctrl.isMail = YES;
    [appDelegate.nav pushViewController:detailctrl animated:YES];
}

- (void)didTableViewScroolToBottom
{
    [items removeAllObjects];
    [self sendGetListRequest:_skip++ Limit:10 IsFirst:true ReplyStatus:0];
}

- (void)didTableViewScroollToTop
{
    [self refresh];
}

- (void)refresh
{
    nullview.hidden = YES;
    [self removeLoading];
    [self.datas removeAllObjects];
    [tableview stopLoading];
    [tableview reloadData];
    
    _skip = 0;
    
    [self didTableViewScroolToBottom];
}

- (void)sendGetListRequest:(NSInteger)skip Limit:(NSInteger)limit IsFirst:(Boolean)isfirst ReplyStatus:(NSInteger)replystatus
{
    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    [Loading CreateLoadingInView:self];
    
    char first = (isfirst) ? (1) : (0);
    
    //请求list
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/mailList?token=%@&skip=%@&limit=%@&isFirstTime=%@&replyStatus=%@",kMailListUrl,token,[NSNumber numberWithInteger:skip * limit],[NSNumber numberWithInteger:limit],[NSNumber numberWithChar:first],[NSNumber numberWithInteger:replystatus]];
    
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        NSLog(@"success");
        [self handleDataWith:@{@"data":requestDic} code:codeStr event:Notification_RushList];
        NSLog(@"最新任务 %@",urlStr);
    } failure:^(NSString *codeStr) {
        NSLog(@"fs");
        [self handleDataWith:nil code:codeStr event:nil];
    }];
}


// 数据处理
- (void)handleDataWith:(NSDictionary *)dataDic code:(NSString *)codeStr event:(NSString *)event
{
    NSString* message = nil;
    NSArray* actions = nil;
    [tableview stopLoading];
    
    if ([codeStr isEqualToString:@"504"])
    {
        message = @"登录信息已过期，请重新登录";
        
        actions = [NSArray arrayWithObjects:
                   [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 回到自动登录界面
            [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc]init]];
            
        }], nil];
    }
    else if ([codeStr isEqualToString:@"-1"]||[codeStr isEqualToString:@"0"]) {
        message = @"请检查网络";
    }
    else if (dataDic)
    {
        if ([codeStr isEqualToString:@"200"])
        {
            // 信件list请求
            if ([event isEqualToString:Notification_RushList])
            {
                NSArray* temp = [dataDic objectForKey:@"data"];
                
                [items addObjectsFromArray:temp];
                
                if (items && [items isKindOfClass:[NSArray class]])
                {
                    // 有数据
                    if ([items count] > 0)
                    {
                        if (!nullview.hidden) nullview.hidden = YES;
                        
                        MyListItem* listitem = nil;
                        for (NSDictionary* item in items)
                        {
                            listitem = [[MyListItem alloc] initWithDictionary:item];
                            [self.datas addObject:listitem];
                        }
                        
                        [tableview reloadData];
                        tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                        
                    }
                    // 没有请求到新数据
                    else
                    {
                        if ([self.datas count] > 0)
                        {
                            
                            [self removeLoading];
                            
                            _skip = 0;
                            
                            
                            return;
                        }
                        else
                        {
                            --_skip;
                            if (0 == [self.datas count]) nullview.hidden = NO;
                            else message = RushList_NoMore;
                        }
                    }
                }
                else
                {
                    --_skip;
                    message = RushList_NoMore;
                }
            }
        }
        
        
        
    }
    
    [self removeLoading];
    
    if (message) {
        if (0 == [actions count]) {
            [self.ctrl showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        } else {
            [self.ctrl showAlterView:Alert_Title_Notice Message:message Actions:actions];
        }
    }
    
}



#pragma mark -- 本地推送

// 设置本地通知

- (void)setUpLocalNotificationWithTime:(NSInteger)hour {
    
    UILocalNotification *noti = [[UILocalNotification alloc] init];
    if (noti == nil) {
        return;
    }
    
    [noti setTimeZone:[NSTimeZone defaultTimeZone]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *testDate = [formatter dateFromString:@"2016-06-13 18:00"];
    NSAssert(testDate != nil, @"testDate = nil");
    
    //to set the fire date
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dateComponents = [calender components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:testDate];
    [dateComponents setHour:20];
    [dateComponents setMinute:0];
    
    NSDate *fireDate = [calender dateFromComponents:dateComponents];
    NSLog(@"fire date = %@", fireDate);
    
    noti.fireDate = fireDate;
    
    //to get the hour
    dateComponents = [calender components:NSCalendarUnitHour fromDate:testDate];
    
    NSLog(@"test date hour = %ld", (long)dateComponents.hour);
    
    
    noti.alertBody = [NSString stringWithFormat:@"今天还有%ld个任务没做吧？凌晨3点系统会回收哦", (unsigned long)self.datas.count];
    NSLog(@"tip: %@", noti.alertBody);
    noti.alertAction = @"View";
    noti.soundName = UILocalNotificationDefaultSoundName;
    NSLog(@"notification application icon badge number = %ld", (long)noti.applicationIconBadgeNumber);
    noti.applicationIconBadgeNumber += 1;
    noti.userInfo = @{@"Kind" : @"testBeginLocalNotification"};
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        noti.repeatInterval = NSCalendarUnitDay;
    } else {
        // 通知重复提示的单位，可以是天、周、月
        noti.repeatInterval = NSDayCalendarUnit;
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:noti];
}

// 取消某个本地推送通知
- (void)cancelLocalNotificationWithKey:(NSString *)key {
    // 获取所有本地通知数组
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[key];
            
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}


@end
