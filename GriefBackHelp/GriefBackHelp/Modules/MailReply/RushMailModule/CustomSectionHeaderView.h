//
//  CustomSectionHeaderView.h
//  BengJiuJie3.0
//
//  Created by WangJun on 16/5/23.
//
//

#import <UIKit/UIKit.h>

@interface CustomSectionHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *gradpaProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *grapaName;

@property (weak, nonatomic) IBOutlet UILabel *userTime;
@property (weak, nonatomic) IBOutlet UILabel *receiveName;

@property (weak, nonatomic) IBOutlet UILabel *receiveTime;
-(void)setContentOfViewWithUser:(NSDictionary *)user;


@end
