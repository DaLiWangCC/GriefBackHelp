//
//  SJAvatarBrowser.h
//  GriefBackHelp
//
//  Created by WangJun on 16/6/16.
//  Copyright © 2016年 daliwangcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SJAvatarBrowser : NSObject
/**
 *  @brief  浏览头像
 *
 *  @param  oldImageView    头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;

+(void)hideImage:(UITapGestureRecognizer*)tap;

@end
