//
//  RepayCell.m
//  griefhelp
//
//  Created by zhangyilong on 16/4/1.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ReplyCell.h"
#import "RushListItem.h"

@implementation ReplyCell

@synthesize date;
@synthesize content;
@synthesize stateview;
@synthesize state;
@synthesize linecon;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    linecon.constant = 0.5;
}


- (void)setCellWithModel:(MyListItem *)model
{
    
    self.date.text = [[TimeTool defaultTool] timestampToString:model.firstUserMailTime / 1000 Format:@"yyyy-MM-dd"];
    
    
    NSRange range = [model.mail.brief rangeOfString:@":"];
    NSRange range2 = [model.mail.brief rangeOfString:@"："];
    if (range.location < 20) {
        NSString *subStr = [model.mail.brief stringByReplacingCharactersInRange:NSMakeRange(0,range.location) withString:@"孩子"];
        
        self.content.text = subStr;
        
    }
    else if (range2.location < 20) {
        NSString *subStr = [model.mail.brief stringByReplacingCharactersInRange:NSMakeRange(0,range2.location) withString:@"孩子"];
        self.content.text = subStr;
    }
    else {
        self.content.text = model.mail.brief;
    }
    
    self.stateview.hidden = NO;
    if (0 == model.checkStatus)
    {
        self.state.textColor = [UIColor redColor];
        self.state.text = @"待审核";
    }
    else if (-1 == model.checkStatus)
    {
        self.state.textColor = [UIColor colorWithRed:.59 green:.59 blue:.59 alpha:1];
        self.state.text = @"未通过";
    }
    else if (1 == model.checkStatus)
    {
        self.state.textColor = [UIColor greenColor];
        self.state.text = @"已审核";
    }
    else
    {
        self.state.text = nil;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
