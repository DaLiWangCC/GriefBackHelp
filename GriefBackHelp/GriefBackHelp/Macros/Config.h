//
//  Config.h
//  GriefBackHelp
//
//  Created by WangJun on 16/6/22.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#ifndef Config_h
#define Config_h


#define IOS_VERSION [[UIDevice currentDevice].systemName doubleValue]

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width

#define kScreenHeight  [UIScreen mainScreen].bounds.size.height





#define Notification_Login                              @"login_result"
#define Notification_RushList                           @"rushlist_result"
#define Notification_RecordList                         @"recordlist_result"
#define Notification_WriteBack                          @"writeback_result"
#define Notification_WriteBack_Detail                   @"writeback_detail_result"
#define Notification_FirstMail                          @"first_mail"
#define Notification_SecondMail                         @"second_mail"
#define Notification_AnsweredMail                       @"answered_mail"
#define Notification_Catch                              @"catch_result"
#define Notification_Start                   @"notify_display_username"

#define Notification_mailListWithUser        @"mail_answer_list_result"



#define Parse_Error              @"数据解析错误"
#define Unkonw_Error             @"未知错误，请稍后再试"
#define NoInternet_Error         @"请检查网络"
#define UserNameOrPassword_Error @"用户名或密码错误"
#define RushList_NoMore          @"已经没有更多数据了"
#define RushList_Catch_Success   @"恭喜，抢单成功"
#define RushList_Catch_Fail      @"抱歉，抢单失败"
#define WriteBack_Success        @"回信成功"
#define WriteBack_Fail           @"回信失败"

#define Alert_Title_Notice       @"提示"
#define Alert_Cancel_Title       @"确定"

#define LoginInterval                172800


#endif /* Config_h */
