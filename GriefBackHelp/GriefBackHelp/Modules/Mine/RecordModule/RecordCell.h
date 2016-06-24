//
//  RecordCell.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel*        date;
@property(nonatomic, weak) IBOutlet UILabel*        task;
@property(nonatomic, weak) IBOutlet UILabel*        finish;
@property(nonatomic, weak) IBOutlet UILabel*        sucess;

@end
