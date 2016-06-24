//
//  Tool.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "TimeTool.h"

@implementation TimeTool

+ (TimeTool*)defaultTool
{
    static TimeTool* g_instance;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        g_instance = [[TimeTool alloc] init];
    });
    
    return g_instance;
}

//year - yyyy, month - MM, day - dd, hour - HH, minute - mm, second - ss, millisecond - SSS
- (NSString*)timestampToString:(long long)timestamp Format:(NSString *)format
{
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateFormatter* dateformatter = [[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:format];
    
    return [dateformatter stringFromDate:date];
}

@end
