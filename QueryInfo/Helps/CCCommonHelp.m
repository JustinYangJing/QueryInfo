//
//  CCCommonHelp.m
//  CCLoginAndRegistCommon
//
//  Created by mr.cao on 15/4/10.
//  Copyright (c) 2015年 mr.cao. All rights reserved.
//

#import "CCCommonHelp.h"

@implementation CCCommonHelp
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title targetView:(UIView *)targetView
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:targetView] ;
    [targetView addSubview:hud];
    hud.dimBackground = NO;
    [hud setDetailsLabelText:title];
    [hud show:YES];
    return hud;
}
+(MBProgressHUD *)showCustomHudtitle:(NSString *)title {
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    hud.dimBackground = NO;
    [hud setDetailsLabelText:title];
    [hud show:YES];
    return hud;
}

+(MBProgressHUD *)showCustomHudtitleTowindow:(NSString *)title duration:(NSTimeInterval)duration
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].windows.lastObject] ;
    hud.mode=MBProgressHUDModeText;
    hud.dimBackground = NO;
    [[UIApplication sharedApplication].windows.lastObject addSubview:hud];
    [hud setDetailsLabelText:title];
    [hud show:YES];
    [hud hide:YES afterDelay:duration];
    return hud;
}

+(void)showCustomHud:(UIImage *)image title:(NSString *)title targetView:(UIView *)targetView
{
    MBProgressHUD *hud=[[MBProgressHUD alloc] initWithView:targetView];
    [targetView addSubview:hud];
    UIImageView *imgView=[[UIImageView alloc] initWithImage:image];
    hud.customView=imgView;
    imgView=nil;
    hud.mode=MBProgressHUDModeCustomView;
    //hud.canPointInside=NO;
    [hud setLabelText:title];
    [hud show:YES];
    [hud hide:YES afterDelay:1.5];
}

+(void)showAutoDissmissAlertView:(NSString *)title msg:(NSString *)msg
{
    
    [self showCustomHudtitleTowindow:msg duration:1.5];
}
+(void)HidHud
{
    [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].windows.lastObject animated:YES];
}
@end
