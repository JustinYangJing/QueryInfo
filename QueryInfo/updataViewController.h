//
//  updataViewController.h
//  QueryInfo
//
//  Created by 袁云龙 on 16/7/26.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "BNRBaseViewVC.h"

@interface updataViewController : BNRBaseViewVC
@property (weak, nonatomic) IBOutlet UILabel *updateTime;
@property (weak, nonatomic) IBOutlet UITextView *updateContent;
@property (weak, nonatomic) IBOutlet UIButton *updateNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateLatterBtn;
@property (weak, nonatomic) IBOutlet UIButton *ignoreUpdate;

@property (nonatomic, strong) NSDictionary *updateInfo;
@end
