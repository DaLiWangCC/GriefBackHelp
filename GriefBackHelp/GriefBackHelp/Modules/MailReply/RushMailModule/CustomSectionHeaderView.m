//
//  CustomSectionHeaderView.m
//  BengJiuJie3.0
//
//  Created by WangJun on 16/5/23.
//
//
#define kTotalWidth [UIScreen mainScreen].bounds.size.width

#import "CustomSectionHeaderView.h"

@implementation CustomSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)setContentOfViewWithUser:(NSDictionary *)user{

    int assistantType = [user[@"assistantType"]intValue];
    double lastTime = [user[@"lastModified"]doubleValue];
    
    
    if (assistantType <= 7) {
        //用户
        self.userName.text = @"From:匿名用户";
        self.userTime.text = [self convertTime:lastTime];
    }
    else if (assistantType > 7) {
        //用户
        self.userName.text = @"From:解忧杂货店";
        self.userTime.text = [self convertTime:lastTime];
    }
}

// 时间戳转换
- (NSString *)convertTime:(double)lastTime
{
    
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:lastTime/1000];
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate:detaildate];
    
    return currentDateStr;
}


@end
