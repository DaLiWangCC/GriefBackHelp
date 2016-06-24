//
//  RushListCell.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "RushListCell.h"

@implementation RushListCell

@synthesize date;
@synthesize penName;
@synthesize content;
@synthesize rushView;
@synthesize rushBtn;
@synthesize state;

@synthesize lineCon;

@synthesize index;

- (void)awakeFromNib {
    // Initialization code
    
    lineCon.constant = 0.5;
    rushView.layer.borderColor = [[UIColor colorWithRed:0.8 green:0.5 blue:0.4 alpha:1] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
