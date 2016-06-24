//
//  RushListItem.h
//  GriefBackHelp
//
//  Created by WangJun on 16/6/15.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonObject.h"

@interface RushListItem : NSObject

@end

@interface MailBox : JsonObject

@property(nonatomic, strong) NSString*  _id;
@property(nonatomic, strong) NSString*  brief;
@property(nonatomic, strong) NSString*  url;

@end

@interface MailOwner : JsonObject

@property(nonatomic, strong) NSString*   _id;
@property(nonatomic, strong) NSString*   nickName;
@property(nonatomic, strong) NSString*   assistantId;
@property(nonatomic, assign) NSInteger   userType;

@end

@interface ListItem : JsonObject

@property(nonatomic, strong) NSString*      _id;
@property(nonatomic, assign) long long      createTime;
@property(nonatomic, strong) NSString*      userId;
@property(nonatomic, strong) MailBox*       mail;
@property(nonatomic, strong) MailOwner*     user;

@end

@interface MyListItem : JsonObject

@property(nonatomic, strong) NSString*      _id;
@property(nonatomic, assign) NSInteger      adminId;
@property(nonatomic, assign) NSInteger      checkStatus;
@property(nonatomic, assign) long long      createTime;
@property(nonatomic, assign) long long      firstUserMailTime;
@property(nonatomic, assign) long long      latestAdminMailTime;
@property(nonatomic, assign) NSInteger      latestMailWordCount;
@property(nonatomic, assign) long long      latestUserMailTime;
@property(nonatomic, strong) MailBox*       mail;
@property(nonatomic, assign) NSInteger      replyStatus;
@property(nonatomic, assign) NSInteger      totalMailCount;
@property(nonatomic, strong) MailOwner*     user;
@property(nonatomic, strong) NSString*      userId;
@property(nonatomic, assign) BOOL      isFirstTime;
@end
