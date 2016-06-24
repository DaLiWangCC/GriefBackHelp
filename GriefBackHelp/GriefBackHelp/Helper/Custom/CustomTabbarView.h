//
//  CustomTabbarView.h
//  BengJiuJie3.0
//
//  Created by pc-01 on 16/5/4.
//
//

#import <UIKit/UIKit.h>

@interface CustomTabbarView : UIView
typedef void (^CustomTabbarBlock)(NSInteger tag);

@property(nonatomic,copy)CustomTabbarBlock block;

-(void)setBlock:(CustomTabbarBlock)block;
+ (CustomTabbarView*)getInstance;

@end
