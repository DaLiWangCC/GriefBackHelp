//
//  TableRefreshHeader.h
//  QQCar
//
//  Created by qqcy on 15/3/6.
//  Copyright (c) 2015年 yilong zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UNTableRefreshHeader;
@class UNTableRefreshFooter;

typedef enum {
    UNTable_Free,
    UNTable_WillRefresh,
    UNTable_Refreshing,
    UNTable_DidRefresh,
}UNRefreshState;

typedef enum
{
    UNTable_Load_Free,
    UNTable_Load_Refresh,
    UNTable_Load_More,
}UNTableLoadState;

@interface UNTableView : UITableView

- (UNTableLoadState)getLoadState;
- (void)stopLoading;

@end

/*****************************************
 *
 * 刷新
 *
 ****************************************/
typedef void(^UNTableRefreshHeaderCallback)(UNTableRefreshHeader*);

@protocol UNTableRefreshHeaderDelegate <NSObject>

@required
- (NSString*)didUNTableRefreshHeaderState:(UNTableRefreshHeader*)header State:(UNRefreshState)state;

@optional
- (void)didUNTableRefreshHeaderDraging:(UNTableRefreshHeader*)header State:(UNRefreshState)state;

@end

@interface UNTableRefreshHeader : UIView
{
    BOOL    isDraged;
}

@property(nonatomic, strong) UILabel*                           m_Title;
@property(nonatomic, strong) UIImageView*                       m_Icon;

@property(nonatomic, copy)   UNTableRefreshHeaderCallback       _callback;
@property(nonatomic, weak)   id<UNTableRefreshHeaderDelegate>   delegate;
@property(nonatomic, assign) UNRefreshState                     m_enState;

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll;
- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll Delegate:(id<UNTableRefreshHeaderDelegate>)delegate;
- (void)setCallback:(UNTableRefreshHeaderCallback)callback;
- (void)startCallback;
- (void)stopRefreshing;
- (void)free;

@end

/*****************************************
 *
 * 更多
 *
 ****************************************/
typedef void(^UNTableRefreshFooterCallback)(UNTableRefreshFooter*);

@interface UNTableRefreshFooter : UIView

@property(nonatomic, strong) UILabel*                       m_Title;

@property(nonatomic, copy)   UNTableRefreshFooterCallback   _callback;
@property(nonatomic, assign) UNRefreshState                 m_enState;
@property(nonatomic, readonly) CGFloat                      m_SuperHeight;

- (instancetype)initWithFrame:(CGRect)frame Scroll:(UIScrollView*)scroll;
- (void)setCallback:(UNTableRefreshFooterCallback)callback;
- (void)startCallback;
- (void)stopRefreshing;
- (void)free;
- (void)isShow;

@end

@interface UIScrollView (UNRefresh)

- (void)setHeader:(UNTableRefreshHeader*)header;
- (UNTableRefreshHeader*)getHeader;

- (void)setFooter:(UNTableRefreshFooter*)footer;
- (UNTableRefreshFooter*)getFooter;

@end
