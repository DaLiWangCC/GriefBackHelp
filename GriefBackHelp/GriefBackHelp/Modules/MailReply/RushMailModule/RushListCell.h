//
//  RushListCell.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RushListCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UILabel*    date;
@property(nonatomic, weak) IBOutlet UILabel*    penName;
@property(nonatomic, weak) IBOutlet UILabel*    content;
@property(nonatomic, weak) IBOutlet UIView*     rushView;
@property(nonatomic, weak) IBOutlet UIButton*   rushBtn;
@property(nonatomic, weak) IBOutlet UILabel*    state;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint* lineCon;

@property(nonatomic, assign) NSInteger          index;

@end
