//
//  RecordView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "RecordView.h"
#import "RecordCell.h"
#import "RecordItem.h"

@implementation RecordView


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
    UINib* nib = [UINib nibWithNibName:@"RecordCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    _skip = 0;
    self.datas = [NSMutableArray array];
    
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


#pragma mark tableview Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datas count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell* cell = (RecordCell*)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return (UITableViewCell*)cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecordCell* cellex = (RecordCell*)cell;
    if (self.datas.count == 0) return;
    
    RecordItem* item = [self.datas objectAtIndex:indexPath.row];
    
    cellex.date.text = [[TimeTool defaultTool] timestampToString:item.date / 1000 Format:@"yyyy-MM-dd"];
    cellex.finish.text = [NSString stringWithFormat:@"%ld", item.finishCount];
    cellex.sucess.text = [NSString stringWithFormat:@"%ld", item.successCount];
    cellex.task.text = [NSString stringWithFormat:@"%ld", item.taskCount];
}

- (void)didTableViewScroolToBottom
{
    [self sendGetListRequest:_skip++ Limit:10];
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
    
    [self layoutIfNeeded];
    
}

#pragma mark -- 数据请求

- (void)sendGetListRequest:(NSInteger)skip Limit:(NSInteger)limit
{
    [Loading CreateLoadingInView:self];
    
    // 发送请求
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/taskCountList?skip=%@&limit=%@&token=%@",kMailListUrl,[NSNumber numberWithInteger:skip * limit],[NSNumber numberWithInteger:limit],token];
    
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        NSLog(@"success");
        
        [self handleDataWith:@{@"data":requestDic} code:codeStr event:nil];
    } failure:^(NSString *codeStr) {
        NSLog(@"fs");
        
        [self handleDataWith:nil code:codeStr event:Notification_RushList];
    }];
}


// 数据处理
- (void)handleDataWith:(NSDictionary *)dataDic code:(NSString *)codeStr event:(NSString *)event
{
    NSString* message = nil;
    NSArray* actions = nil;
    [_tableView stopLoading];
    
    if (dataDic)
    {
        if ([codeStr isEqualToString:@"200"])
        {
            // 任务记录
            NSArray* items = [dataDic objectForKey:@"data"];
            
            if (items && [items isKindOfClass:[NSArray class]])
            {
                // 有数据
                if ([items count] > 0)
                {
                    
                    RecordItem* recorditem = nil;
                    for (NSDictionary* item in items)
                    {
                        recorditem = [[RecordItem alloc] initWithDictionary:item];
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
    
    else if ([codeStr isEqualToString:@"504"])
    {
        message = @"登录信息已过期，请重新登录";
        
        actions = [NSArray arrayWithObjects:
                   [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 回到自动登录界面
            [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc]init]];
            
        }],nil];
    } else if ([codeStr isEqualToString:@"-1"]||[codeStr isEqualToString:@"0"]) {
        message = @"请检查网络";
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
