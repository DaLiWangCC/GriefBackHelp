//
//  HttpRequest.m
//  GriefBackHelp
//
//  Created by WangJun on 16/6/14.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import "RequestManager.h"
#import "AFNetworking.h"

@implementation RequestManager

+ (instancetype)sharedRequestManager
{
    static RequestManager *request;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[RequestManager alloc]init];
    });
    return request;
}

- (void)getRequsetWithUrlStr:(NSString *)url parameter:(NSDictionary *)paraDic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    /*
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"af success");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dic);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"af fs");
        
        NSString *str = [NSString stringWithFormat:@"error.userInfo = %@",error.userInfo[@"com.alamofire.serialization.response.error.response"]];
        NSRange range = [str rangeOfString:@"status code: "];
        NSString *codeStr = [str substringWithRange:NSMakeRange(range.location+range.length, 3)];
        NSLog(@"得到code  ： %@",codeStr);
        failure(str);
    }];
    
    */
    
    
    
    //：为了支持新的 NSURLSession API 以及旧的未弃用且还有用的 NSURLConnection，AFNetworking  的核心组件分成了 request operation 和 session 任务。
    
    AFHTTPRequestOperationManager* manager2 = [AFHTTPRequestOperationManager manager];
    [manager2 GET:url
      parameters:nil
         success:^(AFHTTPRequestOperation* operation, id responseObject) {
//             NSLog(@"JSON: %@", responseObject);
             NSLog(@"connect code = %ld",(long)[operation.response statusCode]);
             
             NSString *codeStr = [NSString stringWithFormat:@"%ld",(long)[operation.response statusCode]];
             
             success((NSDictionary*)responseObject,codeStr);
         }
         failure:^(AFHTTPRequestOperation* operation, NSError* error) {
//             NSLog(@"Error: %@", error);
             NSLog(@"connect code = %ld",(long)[operation.response statusCode]);
             NSString *codeStr = [NSString stringWithFormat:@"%ld",(long)[operation.response statusCode]];
             failure(codeStr);
         }];
   
}

- (void)postRequsetWithUrlStr:(NSString *)url parameter:(NSDictionary *)paraDic success:(SuccessBlock)success failure:(ErrorBlock)failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:paraDic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"success");
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        success(dic,@"success");
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"fs");
        failure([NSString stringWithFormat:@"%@",error]);
    }];
    
}

@end
