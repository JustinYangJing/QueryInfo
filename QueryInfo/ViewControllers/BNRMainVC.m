//
//  BNRMainVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/24/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRMainVC.h"
#import "UIViewController+HETAdditions.h"
@interface BNRMainVC ()

@end

@implementation BNRMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [self settingBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self transparentNavigationBar];
}

-(UIBarButtonItem *)settingBtn{
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(0, 0, 44, 44);
    [settingBtn setBackgroundImage:[UIImage imageNamed:@"mainSetting"]
                             forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(pushSettingVC:)
                forControlEvents:UIControlEventTouchUpInside];
//    settingBtn.exclusiveTouch = YES;
//    settingBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    return [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
}
-(void)pushSettingVC:(UIButton *)btn{

}

@end
