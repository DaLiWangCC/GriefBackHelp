//
//  DetailMailModel.h
//  griefhelp
//
//  Created by WangJun on 16/6/3.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

// 一条回信或去信
@interface DetailMailModel : NSObject

@property (nonatomic,strong) NSString *mailId;
@property (nonatomic,strong) NSDictionary *from;
@property (nonatomic,strong) NSDictionary *to;
@property (nonatomic,strong) NSString *brief;
@property (nonatomic,strong) NSDictionary *user;
@property (nonatomic,strong) NSNumber *lastModified	;

@property (nonatomic,strong) NSArray *contentArray;
@property (nonatomic,strong) NSArray *filterContentArray;

@property (nonatomic,strong) NSString *contentStr;


@end
