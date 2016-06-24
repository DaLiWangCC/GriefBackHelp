//
//  DetailController.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DetailController.h"
#import "DetailMailModel.h"
#import "CustomSectionHeaderView.h"
#import "DetailMailCell.h"
#import "DetailMailImageCell.h"

@interface DetailController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UNTableView *tableView;

@property (nonatomic,strong) NSMutableArray *mailListArray; // 信件数组<DetailMailModel>

@property (nonatomic,assign) int skip; // 分页
@property (nonatomic,assign) BOOL isRefresh; // 分辨下拉刷新

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottom; // tableView距底部的约束


@end

@implementation DetailController

@synthesize send;
@synthesize webView;

@synthesize inputview;
@synthesize replybtn;
@synthesize rushbtn;
@synthesize replyInputView;

@synthesize inputBtmCon;
@synthesize contentCon;

@synthesize isEdit;
@synthesize mailid;
@synthesize url;

@synthesize toUserId;

- (void)dealloc
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (instancetype)init
{
    if (self = [super init])
    {
        isEdit = NO;
        
        return self;
    }
    
    return nil;
}

#pragma mark -- view周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_isBottomBar) {
        
        _tableViewBottom.constant = 44;
    }
    
    _content.layer.borderColor = [UIColor grayColor].CGColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    webView.keyboardDisplayRequiresUserAction = NO;
    
    if (!isEdit) replybtn.hidden = YES;
    
    replyInputView = [ReplyInputView createReplyInputView:_content];
    replyInputView.textView.delegate = self;
    //    content.inputAccessoryView = replyInputView;
    [self.view addSubview:replyInputView];
    
    replyInputView.hidden = YES;
    NSDictionary* views = [NSDictionary dictionaryWithObjectsAndKeys:replyInputView, @"replyInputView", nil];
    NSArray* c = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[replyInputView(128)]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:views];
    replyInputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:c];
    
    c = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[replyInputView]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:views];
    replyInputView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:c];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, replybtn.frame.size.height - 15, replybtn.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"写信";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [replybtn addSubview:label];
    
    NSDictionary* viewdic = NSDictionaryOfVariableBindings(label);
    NSArray* cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[label]-5-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewdic];
    [replybtn addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-8-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:viewdic];
    [replybtn addConstraints:cons];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, rushbtn.frame.size.height - 15, rushbtn.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"抢单";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [rushbtn addSubview:label];
    
    NSDictionary* viewdic1 = NSDictionaryOfVariableBindings(label);
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[label]-5-|" options:NSLayoutFormatAlignAllCenterX metrics:nil views:viewdic1];
    [rushbtn addConstraints:cons];
    
    cons = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-8-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:viewdic1];
    [rushbtn addConstraints:cons];
    
    [replyInputView.cancelbtn addTarget:self action:@selector(OnCancelDown:) forControlEvents:UIControlEventTouchUpInside];
    [replyInputView.sendbtn addTarget:self action:@selector(OnSendDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [self setTabelView]; // 设置tableView 上拉加载 下拉刷新
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!isEdit)
    {
        inputBtmCon.constant = 0;
    }
    
    
    // 判断源生还是webView
    if (_isMail) {
        // 请求来往信件数据
        _skip = 0;
        _isRefresh = YES;
        [self getMailListDetailWithskip:_skip limit:10];
        
    }
    else
    {
        self.tableView.hidden = YES;
        // 加载webView
        [self load];
    }
    if (_isRushBtn) {
        self.rushbtn.hidden = NO;
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    //    [self.view layoutIfNeeded];
    
    
}

- (void)load
{
    [Loading CreateFullScreenLoading:self.view];
    NSString* newurl = [url stringByReplacingOccurrencesOfString:@"#" withString:[NSString stringWithFormat:@"&t=%.0f#", [[NSDate date] timeIntervalSince1970]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:newurl]];
    [webView loadRequest:request];
    
    self.urltf.text = newurl;
    self.urltf.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
}

#pragma mark -- 设置方法
// 设置tableView
- (void)setTabelView
{
    
    // tableView注册
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailMailCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailMailImageCell" bundle:nil] forCellReuseIdentifier:@"CELL_image"];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.mailListArray = [NSMutableArray arrayWithCapacity:2];
    
    // 下拉刷新
    UNTableRefreshHeader* header = [[UNTableRefreshHeader alloc] initWithFrame:CGRectMake(0, -50, self.tableView.frame.size.width, 50) Scroll:self.tableView];
    header.backgroundColor = [UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1];
    //    header.m_Icon.image = [UIImage imageNamed:@"home_renovate_icon"];
    
    
    __weak typeof(self) blockself = self;
    [header setCallback:^(UNTableRefreshHeader *header) {
        [blockself didScroollTop];
    }];
    
    
    // 上拉加载
    
    UNTableRefreshFooter* footer = [[UNTableRefreshFooter alloc] initWithFrame:CGRectMake(0, self.tableView.contentSize.height, self.tableView.frame.size.width, 50) Scroll:self.tableView];
    [self.tableView setFooter:footer];
    [footer setCallback:^(UNTableRefreshFooter *footer) {
        [blockself didTableViewScroolToBottom];
    }];
    
}



- (void)didScroollTop
{
    //请求新的数据
    _isRefresh = YES;
    _skip = 0;
    [self getMailListDetailWithskip:0 limit:10];
}
- (void)didTableViewScroolToBottom
{
    _skip += 10;
    _isRefresh = NO;
    [self getMailListDetailWithskip:_skip limit:10];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)OnSendDown:(UIButton*)sender
{
    //    contentCon.constant = 44;
    //    [content resignFirstResponder];
    
    if ([replyInputView.textView.text length] > 0)
    {
        NSString* str = [NSString stringWithFormat:@"%@", replyInputView.textView.text];
        
        [self sendWriteBackRequest:mailid Content:str DraftId:@"0"];
    }
    else
    {
        isEdit = YES;
        [self showNormalAlertView:Alert_Title_Notice Message:@"回信内容不能为空" CancelTitle:Alert_Cancel_Title];
    }
}

- (IBAction)OnCancelDown:(UIButton*)sender
{
    //    if ([replyInputView.textView.text length] > 0) isEdit = YES;
    //    else isEdit = NO;
    
    replyInputView.textView.text = nil;
    
    if ([replyInputView.textView isFirstResponder])
    {
        [replyInputView.textView resignFirstResponder];
    }
    else
    {
        replyInputView.hidden = YES;
        inputBtmCon.constant = 0;
    }
}

- (IBAction)OnCloseDown:(UIButton*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)OnReplyDown:(UIButton*)sender
{
    [replyInputView.textView becomeFirstResponder];
}

- (IBAction)OnRushDown:(UIButton*)sender
{
    [self sendCatchRequest:_userid];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view removeLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self.view removeLoading];
    
    [self showNormalAlertView:Alert_Title_Notice Message:error.domain CancelTitle:Alert_Cancel_Title];
}

- (void)keyBoardWillShow:(NSNotification *) note
{
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘高度
    CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyBoardHeight = keyBoardBounds.size.height;
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        replyInputView.hidden = NO;
        replyInputView.transform = CGAffineTransformMakeTranslation(0, -keyBoardHeight);
    };
    
    [UIView animateWithDuration:animationTime animations:animation completion:^(BOOL finished) {
    }];
    
    inputBtmCon.constant = keyBoardHeight + replyInputView.frame.size.height;
}

- (void)keyBoardWillHide:(NSNotification *) note
{
    if ([replyInputView.textView.text length] > 0) isEdit = YES;
    else isEdit = NO;
    
    // 获取用户信息
    NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:note.userInfo];
    // 获取键盘动画时间
    CGFloat animationTime  = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    // 定义好动作
    void (^animation)(void) = ^void(void) {
        replyInputView.transform = CGAffineTransformIdentity;
    };
    
    if (animationTime > 0)
    {
        [UIView animateWithDuration:animationTime animations:animation completion:^(BOOL finished) {
            
            if (!isEdit)
            {
                replyInputView.textView.text = nil;
                replyInputView.hidden = YES;
            }
        }];
    }
    else
    {
        animation();
    }
    
    if (!isEdit) inputBtmCon.constant = 0;
    else inputBtmCon.constant = replyInputView.frame.size.height;
}
#pragma mark -- 数据请求

- (void)sendWriteBackRequest:(NSString*)Id Content:(NSString*)content DraftId:(NSString*)draftid
{
    [Loading CreateFullScreenLoading:self.view];
    
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    // 接口
    NSString *urlStr = [NSString stringWithFormat:@"%@session/mail",kWriteBackUrl];
    
    NSDictionary *paraDic = @{@"token":token,@"id":mailid,@"toUserId":_userid,@"type":@"1",@"content":content};
    /*
     unify: [JS] 外援回信: http://story.banana.vocinno.com/session/mail
     unify: [JS] token:undefined
     unify: [JS] id:5766336b7e097bba779965d9
     unify: [JS] toUserId: 17298
     unify: [JS] type: 1
     unify: [JS] content: The
     */
    [[RequestManager sharedRequestManager]postRequsetWithUrlStr:urlStr parameter:paraDic success:^(NSDictionary *requestDic, NSString *codeStr) {
        [self handleDataWith:requestDic code:codeStr event:Notification_WriteBack];
        NSLog(@"回信成功");
    } failure:^(NSString *codeStr) {
        [self handleDataWith:nil code:codeStr event:Notification_WriteBack];
    }];
    
}

- (void)sendCatchRequest:(NSString*)userid
{
    [Loading CreateFullScreenLoading:self.view];
    
    
    // http://assistant.banana.vocinno.com/session/assistant/catchByAssistant?token=756d4c67e539d46c7a68bc179e231342&userId=17563
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    // 接口
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/catchByAssistant?userId=%@&token=%@",kMailListUrl,userid,token];
    
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        [self handleDataWith:requestDic code:codeStr event:Notification_Catch];
    } failure:^(NSString *codeStr) {
        [self handleDataWith:nil code:codeStr event:Notification_Catch];
    }];
}


// 请求来往信件的内容

- (void)getMailListDetailWithskip:(int)skip limit:(int)limit
{
    [Loading CreateFullScreenLoading:self.view];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    
    // 接口
    NSString *urlStr = [NSString stringWithFormat:@"%@session/assistant/mailListWithUser?token=%@&userId=%@&skip=%@&limit=%@",kMailListUrl,token,_userid,@(skip),@(limit)];
    
    NSLog(@"请求单个信件%@",urlStr);
    // 执行请求方法
    [[RequestManager sharedRequestManager]getRequsetWithUrlStr:urlStr parameter:nil success:^(NSDictionary *requestDic, NSString *codeStr) {
        
        [self handleDataWith:requestDic code:codeStr event:Notification_mailListWithUser];
    } failure:^(NSString *codeStr) {
        [self handleDataWith:nil code:codeStr event:nil];
    }];
    
}


// 数据处理
- (void)handleDataWith:(NSDictionary *)dataDic code:(NSString *)codeStr event:(NSString *)event
{
    NSString *message = nil;
    NSArray* actions = nil;
    __weak typeof(self) blockself = self;
    
    
    if ([codeStr isEqualToString:@"504"]) {
        NSLog(@"token过期");
        [self logoutAction:nil];
        return;
    }
    
    
    // 请求list
    if ([event isEqualToString:Notification_mailListWithUser]) {
        NSArray *list = [dataDic valueForKey:@"list"];
        
        if (!list.count) {
            --_skip;
            
            message = RushList_NoMore;
        }
        
        else{
            
            if (_isRefresh) {
                [self.mailListArray removeAllObjects];
                _isRefresh = NO;
            }
            
            // 转成model存放在数组
            for (NSDictionary *l_Dic in list) {
                //            NSLog(@"lastModified  %@",l_Dic[@"CreateDate"]);
                DetailMailModel *model = [[DetailMailModel alloc]init];
                [model setValuesForKeysWithDictionary:l_Dic];
                [self.mailListArray addObject:model];
                
            }
            
            [self.tableView reloadData];
        }
        
    }
    else if ([event isEqualToString:Notification_Catch]) {
        
        if ([codeStr isEqualToString:@"200"]) {
            
            // 发送抢单 成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"catchsuccess" object:nil];
            
            
            // 抢单成功
            UIAlertAction* action = [UIAlertAction actionWithTitle:Alert_Cancel_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [blockself.navigationController popViewControllerAnimated:YES];
            }];
            
            message = RushList_Catch_Success;
            actions = [NSArray arrayWithObjects:action, nil];
        }
        else {
            // 失败
            message = RushList_Catch_Fail;
        }
    }
    
    
    
    else  if ([event isEqualToString:Notification_WriteBack])
    {
        replyInputView.textView.text = nil;
        if ([replyInputView.textView isFirstResponder]) [replyInputView.textView resignFirstResponder];
        else replyInputView.hidden = YES;
        
        if ([codeStr isEqualToString:@"200"]) {
            
            // 发送回信 成功的通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"replysuccess" object:nil];
            
            __weak typeof(self) blockself = self;
            UIAlertAction* action = [UIAlertAction actionWithTitle:Alert_Cancel_Title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [blockself.navigationController popViewControllerAnimated:YES];
                
            }];
            message = WriteBack_Success;
            actions = [NSArray arrayWithObjects:action, nil];
        }
        else {
            // 回信失败
            message = WriteBack_Fail;
        }
        
        
    }
    if ([message length] > 0)
    {
        if (0 == [actions count]) [self showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        else [self showAlterView:Alert_Title_Notice Message:message Actions:actions];
    }
    
    
    [self.tableView stopLoading];
    [self.view removeLoading];
}



#pragma mark -- tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DetailMailModel *model = self.mailListArray[section];
    if (model.filterContentArray.count) {
        return model.filterContentArray.count;
    }
    else if (model.contentArray.count) {
        return model.contentArray.count;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _mailListArray.count;
}

// section 头 显示写信人名称
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CustomSectionHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"CustomSectionHeaderView" owner:self options:nil].lastObject;
    
    DetailMailModel *model = self.mailListArray[section];
    
    NSNumber *assistantType = model.from[@"assistantType"] ;//assittantType 大于 7 名称为解忧杂货店  否则为匿名用户
    if (!assistantType) {
        assistantType = @(8);
    }
    if (!model.lastModified) {
        model.lastModified = @(1465179928000);
    }
    
    NSDictionary *dic = @{@"assistantType":assistantType,@"lastModified":model.lastModified};
    
    [headerView setContentOfViewWithUser:dic];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DetailMailModel *model = self.mailListArray[indexPath.section];
    
    NSDictionary *dic = nil;
    
    if (model.filterContentArray.count) {
        dic = model.filterContentArray[indexPath.row];
    }
    else if (model.contentArray.count) {
        dic = model.contentArray[indexPath.row];
    }
    int type = 0;
    if (dic[@"type"]) {
        type = [dic[@"type"]intValue];
    }
    else {
        NSLog(@"type 错误");
        type = 1;
    }
    
    // 文字
    if (type == 1) {
        DetailMailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
        NSNumber *assistantType = model.from[@"assistantType"] ;//assittantType 大于 7 名称为解忧杂货店  否则为匿名用户
        if (!assistantType) {
            assistantType = @(8);
        }
        NSMutableDictionary *muaDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [muaDic setValue:assistantType forKey:@"isGrapapa"];
        
        
        [cell setValueforCellWithDic:muaDic];
        return cell;
    }
    // 图片
    else if (type == 2){
        DetailMailImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_image" forIndexPath:indexPath];
        [cell setValueforCellWithDic:dic];
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


// 退出登录
- (void)logoutAction:(id)sender {
    //退出登录弹框
    
    
    NSString *message = @"登录信息已过期，请重新登录";
    
    NSArray *actions = [NSArray arrayWithObjects:
                        [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 回到自动登录界面
        [appDelegate.nav pushLoginCotrller:[[LoginViewController alloc]init]];
        
    }], nil];
    
    
    if (message)
    {
        if (0 == [actions count]) [self showNormalAlertView:Alert_Title_Notice Message:message CancelTitle:Alert_Cancel_Title];
        else [self showAlterView:Alert_Title_Notice Message:message Actions:actions];
    }
}
@end
