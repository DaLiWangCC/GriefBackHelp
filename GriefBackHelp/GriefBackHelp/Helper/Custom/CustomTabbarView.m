//
//  CustomTabbarView.m
//  BengJiuJie3.0
//
//  Created by pc-01 on 16/5/4.
//
//

#import "CustomTabbarView.h"
#define TABBAR_HEIGHT 48
@implementation CustomTabbarView
- (IBAction)tapButton:(id)sender {
    self.block([sender tag]);
}

+ (CustomTabbarView*)getInstance {
    CustomTabbarView *tabbarView = [[[NSBundle mainBundle] loadNibNamed:@"CustomTabbarView" owner:nil options:nil]firstObject];
    [tabbarView initsubviews];
    return tabbarView;
}

-(void)initsubviews{
     CGRect  selfRect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - TABBAR_HEIGHT,[UIScreen mainScreen].bounds.size.width , TABBAR_HEIGHT);
     self.frame = selfRect;
}

@end
