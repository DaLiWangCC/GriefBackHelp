//
//  ReplyInputView.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/31.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReplyInputCallback)(NSInteger tag, NSString* text);

@interface ReplyInputView : UIView

@property(nonatomic, weak) IBOutlet UITextView*     textView;
@property(nonatomic, weak) IBOutlet UIButton*       sendbtn;
@property(nonatomic, weak) IBOutlet UIButton*       cancelbtn;

@property(nonatomic, copy) ReplyInputCallback       callback;

- (IBAction)OnButtonDown:(UIButton*)sender;
- (void)hidde;
- (void)setResponder:(UIResponder*)Responder;

+ (ReplyInputView*)createReplyInputView:(UIResponder*)Responder;

@end
