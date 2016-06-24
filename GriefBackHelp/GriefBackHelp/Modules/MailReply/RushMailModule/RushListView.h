//
//  RushListView.h
//  GriefBackHelp
//
//  Created by WangJun on 16/6/22.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RushListView : UIView

@property (nonatomic, strong) UIViewController *ctrl;
@property (weak, nonatomic) IBOutlet UIView *nullImageView;

- (void)refreshData;

@end
