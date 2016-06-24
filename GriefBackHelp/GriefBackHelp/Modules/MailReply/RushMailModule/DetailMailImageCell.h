//
//  DetailMailImageCell.h
//  griefhelp
//
//  Created by WangJun on 16/6/3.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailMailImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
- (void)setValueforCellWithDic:(NSDictionary*)dic;
@end
