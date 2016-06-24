//
//  DetailMailImageCell.m
//  griefhelp
//
//  Created by WangJun on 16/6/3.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DetailMailImageCell.h"
#import "UIImageView+WebCache.h"
#import "SJAvatarBrowser.h"


@implementation DetailMailImageCell


- (void)setValueforCellWithDic:(NSDictionary*)dic
{
    
    // 点击无效果
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    NSString *str = dic[@"body"];
    // 图片
    
    
    NSLog(@"图片url = %@",str);
    
    [_contentImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    NSLog(@"imageV frame %@",NSStringFromCGRect(_contentImageView.frame));
    
    //        [_contentImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    //        _contentImageView.contentMode =  UIViewContentModeScaleAspectFill;
    _contentImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _contentImageView.clipsToBounds  = YES;
    
    _contentImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
    
    [_contentImageView addGestureRecognizer:tap];
}
- (void)magnifyImage
{
    NSLog(@"局部放大");
    [SJAvatarBrowser showImage:_contentImageView];//调用方法
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
