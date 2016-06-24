//
//  DetailController.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReplyInputView.h"
#import "UNTableRefreshHeader.h"


@interface DetailController : UIViewController <UITextViewDelegate, UIWebViewDelegate>

@property(nonatomic, weak) IBOutlet UIButton*       send;
@property(nonatomic, weak) IBOutlet UIWebView*      webView;
@property(nonatomic, weak) IBOutlet UITextView*     content;
@property(nonatomic, weak) IBOutlet UIView*         inputview;
@property(nonatomic, weak) IBOutlet UIButton*       replybtn;
@property(nonatomic, weak) IBOutlet UIButton*       rushbtn;
@property(nonatomic, weak) IBOutlet UITextField*    urltf;
@property(nonatomic, strong) ReplyInputView*        replyInputView;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint*     inputBtmCon;
@property(nonatomic, weak) IBOutlet NSLayoutConstraint*     contentCon;

@property(nonatomic, assign) BOOL       isEdit;
@property(nonatomic, strong) NSString*  mailid;
@property(nonatomic, strong) NSString*  url;
@property(nonatomic, strong) NSString*  userid;
@property(nonatomic, strong) NSString*  toUserId;

@property (nonatomic, assign) BOOL      isMail; // 是否是最新任务进入的回信列表，同时判断使用源生加载信件往来内容
@property (nonatomic, assign) BOOL      isBottomBar; // 是否有底部tabBar
@property (nonatomic, assign) BOOL      isRushBtn; // 是否有抢单按钮

- (IBAction)OnSendDown:(UIButton*)sender;
- (IBAction)OnCancelDown:(UIButton*)sender;
- (IBAction)OnCloseDown:(UIButton*)sender;
- (IBAction)OnReplyDown:(UIButton*)sender;
- (IBAction)OnRushDown:(UIButton*)sender;

@end
