//
//  DetailMailCell.m
//  griefhelp
//
//  Created by WangJun on 16/6/3.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DetailMailCell.h"
#import "UIImageView+WebCache.h"

@interface DetailMailCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation DetailMailCell

- (void)setValueforCellWithDic:(NSDictionary*)dic
{
    // 设置无点击效果
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    int type = [dic[@"type"]intValue];
    NSString *str = dic[@"body"];
    
    // 文字
    if (type == 1) {
        
        NSString *filterStr = str;
        NSNumber *assistantType = dic[@"isGrapapa"];
        // 外援回信
        if ([assistantType intValue]> 7) {
            
            // 外援回信 处理抬头匿名
            NSRange range = [str rangeOfString:@":"];
            NSRange range2 = [str rangeOfString:@"："];
            if (range.location < 20) {
                NSString *subStr = [str stringByReplacingCharactersInRange:NSMakeRange(0,range.location) withString:@"孩子"];
                
                filterStr = subStr;
                
            }
            else if (range2.location < 20) {
                NSString *subStr = [str stringByReplacingCharactersInRange:NSMakeRange(0,range2.location) withString:@"孩子"];
                
                filterStr = subStr;
                
            }
        }
        // 用户来信
        else {
            filterStr = str;
        }
        
        // 处理html格式富文本
        if ([filterStr containsString:@"<p"]||[filterStr containsString:@"<br"]||[filterStr containsString:@"&nbsp"]) {
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[filterStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            NSRange range = NSMakeRange(0, attrStr.length);
            // 设置字体大小
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:range];
            // 设置颜色
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithWhite:0.459 alpha:1.000] range:range];
            
            _contentLabel.attributedText = attrStr;
        }
        
        else {
            
            _contentLabel.text = filterStr;
        }
        
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
