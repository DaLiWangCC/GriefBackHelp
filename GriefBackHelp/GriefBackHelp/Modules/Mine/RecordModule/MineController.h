//
//  RecordController.h
//  griefhelp
//
//  Created by zhangyilong on 16/3/15.
//  Copyright © 2016年 zhangyilong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewRushListView.h"
#import "ReplyView.h"
#import "RecordView.h"

@interface MineController : UIViewController

@property(nonatomic, weak) IBOutlet UIView*        panel;
@property(nonatomic, weak) UIButton*      tempBtn;

- (IBAction)OnTabDown:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIImageView *segmentImage;

@end
