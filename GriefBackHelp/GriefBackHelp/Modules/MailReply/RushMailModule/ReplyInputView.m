//
//  ReplyInputView.m
//  griefhelp
//
//  Created by zhangyilong on 16/3/31.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import "ReplyInputView.h"

@implementation ReplyInputView
{
    BOOL            isActive;
    UIResponder*    responder;
}

@synthesize textView;
@synthesize sendbtn;
@synthesize cancelbtn;
@synthesize callback;

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    self.callback = nil;
}

- (void)awakeFromNib
{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShown:) name:UIKeyboardDidShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    isActive = NO;
    responder = nil;
}

- (void)setResponder:(UIResponder*)Responder
{
    responder = Responder;
}

- (void)keyBoardWillShow:(NSNotification *) note
{
}

- (void)keyBoardShown:(NSNotification *)note
{
    if (!isActive)
    {
        isActive = YES;
        [textView becomeFirstResponder];
    }
}

- (void)keyBoardWillHide:(NSNotification *) note
{
}

- (void)keyBoardHidden:(NSNotification*)note
{
    isActive = NO;
    textView.text = nil;
}

- (IBAction)OnButtonDown:(UIButton *)sender
{
    //0 - cancel
    if (0 == sender.tag)
    {
        textView.text = nil;
    }
    
    [textView resignFirstResponder];
    
//    [responder becomeFirstResponder];
//    [responder resignFirstResponder];
    
    if (callback) callback(sender.tag, textView.text);
}

- (void)hidde
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = 0;
    
    [self OnButtonDown:btn];
}

+ (ReplyInputView*)createReplyInputView:(UIResponder*)Responder
{
    ReplyInputView* view = [[[NSBundle mainBundle] loadNibNamed:@"ReplyInputView" owner:nil options:nil] lastObject];
    
    [view setResponder:Responder];
    
    return view;
}

@end
