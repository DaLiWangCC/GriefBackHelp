//
//  NewRushListView.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRushListView : UIView <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, weak) IBOutlet UNTableView*        tableview;
@property(nonatomic, weak) IBOutlet UIView*             nullview;

@property(nonatomic, weak) UIViewController*            ctrl;
@property(nonatomic, strong) NSMutableArray*            datas;
@property(nonatomic, assign) NSInteger                  skip;

- (void)refresh;
- (void)sendGetListRequest:(NSInteger)skip Limit:(NSInteger)limit IsFirst:(Boolean)isfirst ReplyStatus:(NSInteger)replystatus;

@end
