//
//  LatestViewController.m
//  griefhelp
//
//  Created by pc-01 on 16/4/28.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "LatestViewController.h"
#import "NewRushListView.h"
@interface LatestViewController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong) NewRushListView *newview; //tableView

@end

@implementation LatestViewController

- (NewRushListView *)newview
{
    if (!_newview) {
        _newview = [[[NSBundle mainBundle] loadNibNamed:@"NewRushListView" owner:self options:nil] lastObject];
        _newview.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
        _newview.tag = 1001;
        _newview.ctrl = self;
    }
    return _newview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.contentView layoutIfNeeded];
    [self addSubviews];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(replysucAction) name:@"replysuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(replysucAction) name:@"catchsuccess" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addSubviews {
    NewRushListView* newview = [[[NSBundle mainBundle] loadNibNamed:@"NewRushListView" owner:self options:nil] lastObject];
    newview.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));
    newview.tag = 1001;
    newview.ctrl = self;
    [self.contentView addSubview:newview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NewRushListView* newview = [self.view viewWithTag:1001];
    if (0 == [newview.datas count] && UNTable_Free == [newview.tableview getFooter].m_enState)
    {
        [newview refresh];
    }
    else {
        
        //        [newview refresh];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [_newview removeFromSuperview];
    _newview = nil;
}

- (void)replysucAction
{
    
    NSLog(@"接收到回信成功的通知");
    NewRushListView* newview = [self.view viewWithTag:1001];
    [newview refresh];
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"replysuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"catchsuccess" object:nil];
}

@end
