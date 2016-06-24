//
//  RushListController.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RushListCell.h"
#import "UNTableRefreshHeader.h"

@class DetailController;

@interface RushListController : UIViewController <UITableViewDataSource, UITableViewDelegate, UNTableRefreshHeaderDelegate>

@property(nonatomic, strong) NSMutableArray*        datas;
@property(nonatomic, assign) NSInteger              skip;
@property(nonatomic, assign) NSInteger              selIndex;

@property(nonatomic, weak) IBOutlet UNTableView*    tableview;
@property(nonatomic, weak) IBOutlet UIView*         nullview;

@property(nonatomic, strong) DetailController*        detailctrl;

- (IBAction)OnNewDown:(UIButton*)sender;
- (void)clear;

@end
