//
//  Loading.m
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/15.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import "Loading.h"
#import <objc/runtime.h>

@implementation Loading

@synthesize shadow;
@synthesize indicator;

- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        shadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        shadow.backgroundColor = [UIColor blackColor];
        shadow.alpha = 0.3;
        [self addSubview:shadow];
        
        UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        border.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        border.backgroundColor = [UIColor blackColor];
        border.layer.cornerRadius = 5;
        border.layer.borderColor = [UIColor whiteColor].CGColor;
        border.layer.borderWidth = 1;
        border.alpha = 0.7;
        [self addSubview:border];
        
        indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        indicator.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        
        self.alpha = 0.0;
        [self addSubview:indicator];
        
        shadow.hidden = YES;
        
        [self show];
        
        return self;
    }
    
    return nil;
}

+ (Loading*)CreateFullScreenLoading:(UIView*)view
{
    CGSize winsize = [UIScreen mainScreen].bounds.size;
    
    Loading* loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, winsize.width, winsize.height)];
    
    [view addSubview:loading];
    
    [view setLoading:loading];
    
    return loading;
}

+ (Loading*)CreateLoadingInView:(UIView*)inview
{
    CGRect frame = inview.frame;
    
    Loading* loading = [[Loading alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    
    [inview addSubview:loading];
    
    [inview setLoading:loading];
    
    return loading;
}

- (void)show
{
    self.alpha = 1.0;
    [indicator startAnimating];
}

- (void)hidde
{
    self.alpha = 0.0;
    [indicator stopAnimating];
}

- (void)remove
{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation UIView (Loading)

- (void)setLoading:(Loading*)loading
{
    // 设置关联
    objc_setAssociatedObject(self, "Loading", loading, OBJC_ASSOCIATION_ASSIGN);
}

- (Loading*)getLoading
{
    return objc_getAssociatedObject(self, "Loading");
}

- (void)removeLoading
{
    Loading* loading = [self getLoading];
    
    if (loading)
    {
        [loading removeFromSuperview];
    }
    
    // 取消关联
    objc_setAssociatedObject(self, "Loading", nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
