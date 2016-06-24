//
//  RushListView.m
//  GriefBackHelp
//
//  Created by WangJun on 16/6/22.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import "RushListView.h"
#import "RushListItem.h"
#import "RushListCell.h"
#import "UNTableRefreshHeader.h"

@interface RushListView ()<UITableViewDelegate,UITableViewDataSource,UNTableRefreshHeaderDelegate>

@property (weak, nonatomic) IBOutlet UNTableView *tableView;

@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, assign) NSInteger selIndex;
@property (nonatomic, assign) NSInteger skip;

@end

@implementation RushListView

#pragma mark -- 初始化

- (NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray arrayWithCapacity:1];
    }
    return _datas;
}

- (void)awakeFromNib
{
    UINib* nib = [UINib nibWithNibName:@"RushListCell" bundle:[NSBundle mainBundle]];
    [_tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    
    [_tableView layoutIfNeeded];
    
    // 下拉刷新
    __weak typeof(self) blockself = self;
    UNTableRefreshHeader* header = [[UNTableRefreshHeader alloc] initWithFrame:CGRectMake(0, -50, _tableView.frame.size.width, 50) Scroll:_tableView];
    header.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    header.m_Icon.image = [UIImage imageNamed:@"home_renovate_icon"];
    [header setCallback:^(UNTableRefreshHeader *header) {
        [blockself didTableViewScroollToTop];
    }];
    header.delegate = self;
    [_tableView setHeader:header];
    

}



// 下拉刷新的代理
- (NSString*)didUNTableRefreshHeaderState:(UNTableRefreshHeader *)header State:(UNRefreshState)state
{
    return @"换一批...";
}

- (void)didUNTableRefreshHeaderDraging:(UNTableRefreshHeader *)header State:(UNRefreshState)state
{
    if (UNTable_Free == state)
    {
        header.m_Title.text = @"换一批";
    }
}


- (void)didTableViewScroollToTop
{
     [self sendGetListRequest:_skip++ Num:10];
}



#pragma mark -- tableView 代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RushListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    ListItem* item = [self.datas objectAtIndex:indexPath.row];
    
    
    cell.index = indexPath.row;
    cell.rushBtn.tag = indexPath.row;
    
    cell.content.text = item.mail.brief;
    cell.penName.text = item.user.nickName;
    cell.date.text = [[TimeTool defaultTool] timestampToString:item.createTime / 1000 Format:@"yyyy.MM.dd"];
    
    return cell;
}


#pragma mark -- 数据请求

- (void)refreshData
{
    _nullImageView.hidden = YES;
    _skip = 0;
    [self sendGetListRequest:_skip++ Num:10];
}

// 得到信件列表
- (void)sendGetListRequest:(NSInteger)skip Num:(NSInteger)num
{
    [Loading CreateLoadingInView:self];
    
    //请求list数据
    NSString *urlStr = [NSString stringWithFormat:@"%@session/mailInboxList?skip=%@&limit=%@&token=%@",kMailListUrl,[NSNumber numberWithInteger:skip * num],[NSNumber numberWithInteger:num],[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]];
    
    [[RequestManager sharedRequestManager] getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic,NSString *codeStr) {
        //        NSLog(@"dic = %@",requestDic);
        NSLog(@"codeStr = %@",codeStr);
        NSDictionary *dic = @{@"data":requestDic};
        //处理数据
        [self handleDataWith:dic code:codeStr event:Notification_RushList];
        
        
    } failure:^(NSString *codeStr) {
        NSLog(@"%@",codeStr);
        [self handleDataWith:nil code:codeStr event:Notification_RushList];
    }];
    
}

// 抢单
- (void)sendCatchRequest:(NSString*)userid
{
    [Loading CreateFullScreenLoading:self];
    
    //抢单请求
    //请求list
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/catchByAssistant?userId=%@&token=%@",kMailListUrl,userid,token];
    
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        NSLog(@"success");
        [self handleDataWith:@{@"data":requestDic} code:codeStr event:Notification_Catch];
    } failure:^(NSString *codeStr) {
        NSLog(@"fs");
        [self handleDataWith:nil code:codeStr event:nil];
    }];
}

// 抢单成功通知处理
- (void)handleRushSucNotification:(NSNotification*)notification
{
//    detailctrl = nil;
    
    [self.datas removeObjectAtIndex:_selIndex];
    [self.tableView reloadData];
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
            // 信件list请求
            if ([event isEqualToString:Notification_RushList])
            {
                NSArray* items = [dataDic objectForKey:@"data"];
                
                if (items && [items isKindOfClass:[NSArray class]])
                {
                    // 有数据
                    if ([items count] > 0)
                    {
                        if (!_nullImageView.hidden) _nullImageView.hidden = YES;
                        
                        [self.datas removeAllObjects];
                        
                        ListItem* listitem = nil;
                        for (NSDictionary* item in items)
                        {
                            listitem = [[ListItem alloc] initWithDictionary:item];
                            [self.datas addObject:listitem];
                        }
                        
                        [_tableView reloadData];
                        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                        
                    }
                    // 没有请求到数据数据
                    else
                    {
                        if ([self.datas count] > 0)
                        {
                            
                            [self removeLoading];
                            
                            _skip = 0;
                            
                            // 重新请求 skip = 0
                            [self OnNewDown:nil];
                            
                            return;
                        }
                        else
                        {
                            --_skip;
                            //显示无数据提示
                            if (0 == [self.datas count]) _nullImageView.hidden = NO;
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
            // 抢单操作
            else if ([event isEqualToString:Notification_Catch]){
                // 抢单结果
                id isok = [dataDic objectForKey:@"data"];
                if (isok)
                {
                    message = RushList_Catch_Success;
                    
                    [self.datas removeObjectAtIndex:_selIndex];
                    [_tableView reloadData];
                    
                    //发通知告诉最新任务界面刷新数据
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"catchsuccess" object:nil];
                }
                else
                {
                    message = RushList_Catch_Fail;
                }
                
            }
        }
        
        
    }
    else if ([codeStr isEqualToString:@"504"])
    {
        message = @"登录信息已过期，请重新登录";
        
        actions = [NSArray arrayWithObjects:
                   [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 回到自动登录界面
            [appDelegate.nav pushLoginCotrller:[[DisguiserViewController alloc]init]];
            
        }], [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc] init]];
        }],nil];
    } else if ([codeStr isEqualToString:@"-1"]) {
        message = @"链接超时，请检查网络";
    }
    
    [self removeLoading];
    
    if ([message length] > 0)
    {
        if (0 == [actions count]) [self.ctrl showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        else [self.ctrl showAlterView:Alert_Title_Notice Message:message Actions:actions];
    }
    
}


- (IBAction)OnNewDown:(UIButton*)sender
{
    [self sendGetListRequest:_skip++ Num:10];
}
@end
