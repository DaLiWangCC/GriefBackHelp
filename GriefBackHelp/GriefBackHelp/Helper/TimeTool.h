//
//  Tool.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/16.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeTool : NSObject

+ (TimeTool*)defaultTool;

- (NSString*)timestampToString:(long long)timestamp Format:(NSString*)format;

@end
