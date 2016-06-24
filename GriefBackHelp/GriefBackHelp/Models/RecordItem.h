//
//  RecordItem.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "JsonObject.h"

@interface RecordItem : JsonObject

@property(nonatomic, assign) long long          date;
@property(nonatomic, assign) NSInteger          taskCount;
@property(nonatomic, assign) NSInteger          finishCount;
@property(nonatomic, assign) NSInteger          successCount;

@end
