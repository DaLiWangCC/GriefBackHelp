//
//  TableRefreshHeader.m
//  QQCar
//
//  Created by qqcy on 15/3/6.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import "UNTableRefreshHeader.h"
#import <objc/runtime.h>

@implementation UNTableView
{
    UNTableLoadState    _enState;
}

- (void)dealloc
{
    [[self getHeader] free];
    [[self getFooter] free];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _enState = UNTable_Load_Free;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _enState = UNTable_Load_Free;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self)
    {
        _enState = UNTable_Load_Free;
    }
    
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _enState = UNTable_Load_Free;
    }
    
    return self;
}

- (UNTableLoadState)setStateCode:(UNTableLoadState)state
{
    UNTableLoadState oldcode = _enState;
    
    _enState = state;
    
    return oldcode;
}

- (UNTableLoadState)getLoadState
{
    return _enState;
}

- (void)stopLoading
{
    if (UNTable_Load_Refresh == _enState)
    {
        [[self getHeader] stopRefreshing];
    }
    else if (UNTable_Load_More == _enState)
    {
        [[self getFooter] stopRefreshing];
    }
    else ;
    
    _enState = UNTable_Load_Free;
}

@end

/*****************************************
 *
 * 刷新
 *
 ****************************************/
@implementation UNTableRefreshHeader

@synthesize m_Title;
@synthesize m_Icon;

@synthesize _callback;
@synthesize delegate;
@synthesize m_enState;

- (void)dealloc
{
    self._callback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll
{
    if ([super initWithFrame:frame])
    {
        self._callback = nil;
        self.delegate = nil;
        m_enState = UNTable_Free;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        m_Icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, frame.size.height - 10)];
        m_Icon.center = CGPointMake(frame.size.width / 2 - m_Icon.frame.size.width / 2, frame.size.height / 2);
        [self addSubview:m_Icon];
        
        m_Title = [[UILabel alloc] initWithFrame:CGRectMake(m_Icon.frame.origin.x + m_Icon.frame.size.width, 0, frame.size.width, frame.size.height)];
        m_Title.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        m_Title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        m_Title.backgroundColor = [UIColor clearColor];
        m_Title.font = [UIFont systemFontOfSize:15];
        m_Title.textAlignment = NSTextAlignmentCenter;
        m_Title.text = @"松开刷新...";
        [self addSubview:m_Title];
        
        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setHeader:self];
        
        [scroll addSubview:self];

        return self;
    }
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<UNTableRefreshHeaderDelegate>)delegate
{
    if ([super initWithFrame:frame])
    {
        self._callback = nil;
        self.delegate = delegate;
        isDraged = NO;
        m_enState = UNTable_Free;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        m_Icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 31)];
        m_Icon.center = CGPointMake(frame.size.width / 2 - m_Icon.frame.size.width / 2, frame.size.height / 2);
        [self addSubview:m_Icon];
        
        m_Title = [[UILabel alloc] initWithFrame:CGRectMake(m_Icon.frame.origin.x + m_Icon.frame.size.width, 0, frame.size.width, frame.size.height)];
        m_Title.center = CGPointMake(m_Title.center.x, frame.size.height / 2);
        m_Title.backgroundColor = [UIColor clearColor];
        m_Title.font = [UIFont systemFontOfSize:15];
        m_Title.textAlignment = NSTextAlignmentLeft;
        [self addSubview:m_Title];

        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setHeader:self];
        
        [scroll addSubview:self];

        return self;
    }
    
    return nil;
}

- (void)setCallback:(UNTableRefreshHeaderCallback)callback
{
    self._callback = callback;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView* scroll = (UIScrollView*)object;
    
    if (!isDraged && delegate)
    {
        isDraged = YES;
        
        m_Title.text = [delegate didUNTableRefreshHeaderState:self State:m_enState];
        [self setTitlePosition:m_Title.text];
    }
    
    if (scroll.contentOffset.y < self.frame.origin.y && scroll.decelerating)
    {
        if (UNTable_Free == m_enState)
        {
            m_enState = UNTable_WillRefresh;
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(startCallback)];
            scroll.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
            [UIView commitAnimations];
        }
    }
}

- (void)startCallback
{
    UNTableView* table = (UNTableView*)[self superview];
    [table setStateCode:UNTable_Load_Refresh];
    
    if (self._callback) self._callback(self);
    
    if (UNTable_WillRefresh == m_enState)
    {
        m_enState = UNTable_Refreshing;
        
        [self rotationIcon:YES];
        
        if (delegate)
        {
            m_Title.text = [delegate didUNTableRefreshHeaderState:self State:m_enState];
            [self setTitlePosition:m_Title.text];
        }
    }
}

- (void)stopRefreshing
{
    if (UNTable_Refreshing == m_enState || UNTable_WillRefresh == m_enState)
    {
        m_enState = UNTable_Free;
        isDraged = NO;
        
        UIScrollView* scroll = (UIScrollView*)self.superview;
        
        [UIView beginAnimations:nil context:nil];
        scroll.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
        
        [self rotationIcon:NO];
        
        if (delegate)
        {
            m_Title.text = [delegate didUNTableRefreshHeaderState:self State:m_enState];
            [self setTitlePosition:m_Title.text];
        }
    }
}

- (void)setTitlePosition:(NSString*)title
{
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSDictionary *attribute = @{NSFontAttributeName:m_Title.font};
    
    // 计算title的rect
    CGRect rect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, m_Title.frame.size.height) options:options attributes:attribute context:nil];
    
    if (m_Icon.image)
    {
        if (rect.size.width > self.frame.size.width - m_Icon.frame.size.width)
        {
            rect.size.width = self.frame.size.width - m_Icon.frame.size.width;
        }
        
        CGFloat x = (self.frame.size.width - m_Icon.frame.size.width - rect.size.width) / 2;
        m_Icon.frame = CGRectMake(x, m_Icon.frame.origin.y, m_Icon.frame.size.width, m_Icon.frame.size.height);
        m_Title.frame = CGRectMake(m_Icon.frame.origin.x + m_Icon.frame.size.width, m_Title.frame.origin.y, rect.size.width, m_Title.frame.size.height);
    }
    else
    {
        if (rect.size.width > self.frame.size.width)
        {
            rect.size.width = self.frame.size.width;
        }
        
        m_Title.frame = CGRectMake(0, 0, rect.size.width, m_Title.frame.size.height);
        m_Title.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    }
}

- (void)rotationIcon:(BOOL)isanimate
{
    if (m_Icon.image)
    {
        if (UNTable_Free == m_enState)
        {
            if (isanimate)
            {
                [UIView beginAnimations:nil context:nil];
                m_Icon.transform = CGAffineTransformMakeRotation(0);
                [UIView commitAnimations];
            }
            else
            {
                m_Icon.transform = CGAffineTransformMakeRotation(0);
            }
        }
        else
        {
            if (isanimate)
            {
                [UIView beginAnimations:nil context:nil];
                m_Icon.transform = CGAffineTransformMakeRotation(M_PI);
                [UIView commitAnimations];
            }
            else
            {
                m_Icon.transform = CGAffineTransformMakeRotation(M_PI);
            }
        }
    }
}

- (void)free
{
    [[self superview] removeObserver:self forKeyPath:@"contentOffset"];
}

@end


/*****************************************
 *
 * 更多
 *
 ****************************************/

@implementation UNTableRefreshFooter

@synthesize m_Title;

@synthesize _callback;
@synthesize m_enState;
@synthesize m_SuperHeight;

- (void)dealloc
{
    self._callback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll
{
    if ([super initWithFrame:frame])
    {
        self._callback = nil;
        m_enState = UNTable_Free;
        m_SuperHeight = scroll.contentSize.height;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        m_Title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        m_Title.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        m_Title.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        m_Title.backgroundColor = [UIColor clearColor];
        m_Title.font = [UIFont systemFontOfSize:13];
        m_Title.textAlignment = NSTextAlignmentCenter;
        m_Title.text = @"松开获得更多...";
        [self addSubview:m_Title];
        
        [scroll addSubview:self];
        
        [scroll addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scroll addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        [scroll setFooter:self];
        
        self.hidden = YES;
        
        return self;
    }
    
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIScrollView* scroll = (UIScrollView*)object;
    
    if ([keyPath isEqualToString:@"contentSize"])
    {
        if (m_SuperHeight != scroll.contentSize.height)
        {
            m_SuperHeight = scroll.contentSize.height;
            self.frame = CGRectMake(0, m_SuperHeight, self.frame.size.width, self.frame.size.height);
        }
    }
    else
    {
        CGFloat h = scroll.frame.size.height;

        CGFloat height = scroll.contentOffset.y + h;
        
        if ( (height - scroll.contentSize.height) > self.frame.size.height && scroll.decelerating)
        {
            if (UNTable_Free == m_enState && scroll.contentSize.height >= h)
            {
                m_enState = UNTable_WillRefresh;
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(startCallback)];
                scroll.contentInset = UIEdgeInsetsMake(0, 0, self.frame.size.height, 0);
                [UIView commitAnimations];
            }
        }
    }
    
    [self isShow];
}

- (void)setCallback:(UNTableRefreshFooterCallback)callback
{
    self._callback = callback;
}

- (void)startCallback
{
    UNTableView* table = (UNTableView*)[self superview];
    [table setStateCode:UNTable_Load_More];
    
    m_Title.text = @"松开获得更多...";
    
    if (self._callback) self._callback(self);
    
    if (UNTable_WillRefresh == m_enState) m_enState = UNTable_Refreshing;
}

- (void)stopRefreshing
{
    if (UNTable_Refreshing == m_enState || UNTable_WillRefresh == m_enState)
    {
        m_enState = UNTable_Free;
        
        UIScrollView* scroll = (UIScrollView*)self.superview;
        
        [UIView beginAnimations:nil context:nil];
        scroll.contentInset = UIEdgeInsetsZero;
        [UIView commitAnimations];
        
        m_Title.text = @"松开获得更多...";
    }
}

- (void)free
{
    [[self superview] removeObserver:self forKeyPath:@"contentOffset"];
    [[self superview] removeObserver:self forKeyPath:@"contentSize"];
}

- (void)isShow
{
    UIScrollView* scroll = (UIScrollView*)self.superview;
    
//    NSLog(@"%f   %f", scroll.contentSize.height, scroll.frame.size.height);
    
    if (scroll.contentSize.height > scroll.frame.size.height) self.hidden = NO;
    else self.hidden = YES;
}

@end


@implementation UIScrollView (UNRefresh)

- (void)setHeader:(UNTableRefreshHeader*)header
{
    objc_setAssociatedObject(self, "UNRefreshHeader", header, OBJC_ASSOCIATION_ASSIGN);
}

- (UNTableRefreshHeader*)getHeader
{
    return objc_getAssociatedObject(self, "UNRefreshHeader");
}

- (void)setFooter:(UNTableRefreshFooter*)footer
{
    objc_setAssociatedObject(self, "UNRefreshFooter", footer, OBJC_ASSOCIATION_ASSIGN);
}

- (UNTableRefreshFooter*)getFooter
{
    return objc_getAssociatedObject(self, "UNRefreshFooter");
}

@end
