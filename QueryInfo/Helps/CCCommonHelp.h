//
//  CCCommonHelp.h
//  CCLoginAndRegistCommon
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface CCCommonHelp : NSObject
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title targetView:(UIView *)targetView;
+(void) showCustomHud:(UIImage *)image title:(NSString *)title targetView:(UIView *)targetView;


+(MBProgressHUD *)showCustomHudtitleTowindow:(NSString *)title duration:(NSTimeInterval)duration;
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title;
+(void)showAutoDissmissAlertView:(NSString *)title msg:(NSString *)msg;
+(void)HidHud;
@end
