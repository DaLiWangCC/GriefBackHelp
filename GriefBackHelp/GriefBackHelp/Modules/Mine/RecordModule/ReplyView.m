//
//  NewRushListView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ReplyView.h"
#import "RushListItem.h"
#import "ReplyCell.h"

@implementation ReplyView


@synthesize nullimageview;

@synthesize ctrl;
@synthesize datas;


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc
{
    
}

- (void)awakeFromNib
{
    UINib* nib = [UINib nibWithNibName:@"ReplyCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    self.datas = [NSMutableArray array];
    _skip = 0;
    
    UNTableRefreshFooter* footer = [[UNTableRefreshFooter alloc] initWithFrame:CGRectMake(0, _tableView.contentSize.height, _tableView.frame.size.width, 50) Scroll:_tableView];
    [_tableView setFooter:footer];
    __weak typeof(self) blockself = self;
    [footer setCallback:^(UNTableRefreshFooter *footer) {
        [blockself didTableViewScroolToBottom];
    }];
    
    UNTableRefreshHeader* header = [[UNTableRefreshHeader alloc] initWithFrame:CGRectMake(0, -50, _tableView.frame.size.width, 50) Scroll:_tableView];
    [header setCallback:^(UNTableRefreshHeader *header) {
        [blockself didTableViewScroollToTop];
    }];
    [_tableView setHeader:header];
}

#pragma mark -- tableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyCell* cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return (UITableViewCell*)cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.datas.count == 0) {
        return;
    }
    ReplyCell* cellex = (ReplyCell*)cell;
    MyListItem* item = [self.datas objectAtIndex:indexPath.row];
    
    [cellex setCellWithModel:item];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyListItem* item = [self.datas objectAtIndex:indexPath.row];
    DetailController* detailctrl = [[DetailController alloc] init];
    detailctrl.mailid = item.mail._id;
    detailctrl.url = item.mail.url;
    detailctrl.isEdit = NO;
    detailctrl.isMail = YES;
    detailctrl.userid = item.userId;
    detailctrl.isBottomBar = YES;// 进入后底部有tabBar
    [self.ctrl.navigationController pushViewController:detailctrl animated:YES];
}

- (void)didTableViewScroolToBottom
{
    [self sendGetListRequest:_skip++ Limit:10 IsFirst:false ReplyStatus:1];
}

- (void)didTableViewScroollToTop
{
    [self refresh];
}

- (void)refresh
{
    
    nullimageview.hidden = YES;
    
    [self removeLoading];
    
    [self.datas removeAllObjects];
    [_tableView stopLoading];
    [_tableView reloadData];
    
    _skip = 0;
    
    [self didTableViewScroolToBottom];
}

#pragma mark -- 数据请求和处理
- (void)sendGetListRequest:(NSInteger)skip Limit:(NSInteger)limit IsFirst:(Boolean)isfirst ReplyStatus:(NSInteger)replystatus
{
    [Loading CreateLoadingInView:self];
    
    char first = (isfirst) ? (1) : (0);
    
    // 数据请求
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/mailList?token=%@&skip=%@&limit=%@&isFirstTime=%@&replyStatus=%@",kMailListUrl,token,[NSNumber numberWithInteger:skip * limit], [NSNumber numberWithInteger:limit], [NSNumber numberWithChar:first], [NSNumber numberWithInteger:replystatus]];
    
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        [self handleDataWith:@{@"data":requestDic} code:codeStr event:nil];
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
    [_tableView stopLoading];
    
    if ([codeStr isEqualToString:@"504"])
    {
        message = @"登录信息已过期，请重新登录";
        
        actions = [NSArray arrayWithObjects:
                   [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 回到自动登录界面
            [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc]init]];
            
        }],nil];
    }
    else if ([codeStr isEqualToString:@"-1"]||[codeStr isEqualToString:@"0"]) {
        message = @"请检查网络";
    }
    
    if (dataDic)
    {
        if ([codeStr isEqualToString:@"200"])
        {
            // 任务记录
            NSArray* items = [dataDic objectForKey:@"data"];
            
            if (items && [items isKindOfClass:[NSArray class]])
            {
                
                if (!items.count) {
                    --_skip;
                    
                    message = RushList_NoMore;
                }
                
                // 有数据
                else if ([items count] > 0)
                {
                    
                    MyListItem* recorditem = nil;
                    for (NSDictionary* item in items)
                    {
                        recorditem = [[MyListItem alloc] initWithDictionary:item];
                        [self.datas addObject:recorditem];
                    }
                    
                    [_tableView reloadData];
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
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
    
    
    [self removeLoading];
    
    if (message) {
        if (0 == [actions count]) {
            [self.ctrl showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        } else {
            [self.ctrl showAlterView:Alert_Title_Notice Message:message Actions:actions];
        }
    }
    
}


@end
