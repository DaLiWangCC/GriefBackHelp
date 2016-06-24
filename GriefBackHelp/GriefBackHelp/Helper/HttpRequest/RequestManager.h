//
//  HttpRequest.h
//  GriefBackHelp
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(NSDictionary * requestDic,NSString *codeStr);
typedef void(^ErrorBlock)(NSString *codeStr);


@interface RequestManager : NSObject

+ (instancetype)sharedRequestManager;

- (void)getRequsetWithUrlStr:(NSString*)url
                 parameter:(NSDictionary*)paraDic
                   success:(SuccessBlock)success
                   failure:(ErrorBlock)failure;

- (void)postRequsetWithUrlStr:(NSString*)url
                  parameter:(NSDictionary*)paraDic
                    success:(SuccessBlock)success
                    failure:(ErrorBlock)failure;
@end
