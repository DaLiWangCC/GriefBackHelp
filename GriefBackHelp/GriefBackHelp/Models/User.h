//
//  User.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/14.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define User_Account        @"account"
#define User_Password       @"password"
#define User_Login_Date     @"logindate"

/**
 *  @author zhangyilong, 16-03-14 13:03:43
 *
 *  当前用户
 */

@interface User : NSObject

@property(nonatomic, strong) NSString*          account;
@property(nonatomic, strong) NSString*          password;
@property(nonatomic, strong) NSString*          logindate;

+ (User*)defaultUser;

- (instancetype)init;
- (void)saveInfoToNative;
- (void)setValueForKey:(id)value Key:(NSString*)key;
- (id)getValueForKey:(NSString*)key;

@end