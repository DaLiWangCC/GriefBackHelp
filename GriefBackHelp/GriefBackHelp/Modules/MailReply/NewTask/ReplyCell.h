//
//  RepayCell.h
//  griefhelp
//
//  Created by zhangyilong on 16/4/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyListItem;

@interface ReplyCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel*            date;
@property(nonatomic, weak) IBOutlet UILabel*            content;
@property(nonatomic, weak) IBOutlet UIView*             stateview;
@property(nonatomic, weak) IBOutlet UILabel*            state;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint* linecon;
@property (weak, nonatomic) IBOutlet UIImageView *stateImage;


- (void)setCellWithModel:(MyListItem*)model;


@end
