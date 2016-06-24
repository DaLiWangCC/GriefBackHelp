//
//  User.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/14.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "User.h"

@implementation User

+ (User*)defaultUser
{
    static User* instance = nil;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        instance = [[User alloc] init];
    });
    
    return instance;
}

- (void)dealloc
{
    //
}

- (instancetype)init
{
    if (self = [super init])
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        self.account   = [defaults objectForKey:User_Account];
        self.password  = [defaults objectForKey:User_Password];
        self.logindate = [defaults objectForKey:User_Login_Date];
        
        return self;
    }
    
    return nil;
}

- (void)saveInfoToNative
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.account forKey:User_Account];
    [defaults setObject:self.password forKey:User_Password];
    [defaults setObject:self.logindate forKey:User_Login_Date];
}

- (void)setValueForKey:(id)value Key:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
}

- (id)getValueForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

@end
