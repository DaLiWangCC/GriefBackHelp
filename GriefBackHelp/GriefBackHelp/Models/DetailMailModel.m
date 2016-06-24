//
//  DetailMailModel.m
//  griefhelp
//
//  Created by WangJun on 16/6/3.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "DetailMailModel.h"

@implementation DetailMailModel


- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //过滤
    if ([key isEqualToString:@"filterContent"]) {
        
//        NSLog(@"filterContent-------------");
        if ([value isKindOfClass:[NSArray class]]) {
            self.filterContentArray = value;
            NSLog(@"str");
        }
        if ([value isKindOfClass:[NSString class]]) {
            self.filterContentArray = @[@{@"body":value,@"type":@(1)}];
            
            NSLog(@"arr");
        }
    }
    else if ([key isEqualToString:@"content"]) {
//        NSLog(@"content-------------");
        
        
        if ([value isKindOfClass:[NSArray class]]) {
            self.contentArray = value;
            NSLog(@"str");
        }
        if ([value isKindOfClass:[NSString class]]) {
            self.contentArray = @[@{@"body":value,@"type":@(1)}];
            
            NSLog(@"arr");
        }
    }}

@end
