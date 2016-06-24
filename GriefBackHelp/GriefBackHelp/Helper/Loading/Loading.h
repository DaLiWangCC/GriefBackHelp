//
//  Loading.h
//  WisdomSchoolBadge
//
//  Created by zhangyilong on 15/7/15.
//  Copyright (c) 2015年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Loading : UIView

@property(nonatomic, strong) UIView*                  shadow;
@property(nonatomic, strong) UIActivityIndicatorView* indicator;

+ (Loading*)CreateFullScreenLoading:(UIView*)view;
+ (Loading*)CreateLoadingInView:(UIView*)inview;

- (void)show;
- (void)hidde;
- (void)remove;

@end

@interface UIView (Loading)

- (void)setLoading:(Loading*)loading;
- (Loading*)getLoading;
- (void)removeLoading;

@end
