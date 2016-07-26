//
//  updataViewController.m
//  QueryInfo
//
//  Created by 袁云龙 on 16/7/26.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "updataViewController.h"

@interface updataViewController ()

@end

@implementation updataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)updateNowAction:(id)sender {
    //
    NSString *appString = kAppItuneStoreAddress;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appString]];
    
}
- (IBAction)updateLatterAction:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (IBAction)ignoreUpdateAction:(id)sender {
    //        deviceType = 2;
    //        isRequired = 0;
    //        releaseTime = "2016-07-26 07:52:24";
    //        updateComment = "1\U3001\U66f4\U65b0\U9009\U62e9\U5feb\U9012\U516c\U53f8\n2\U3001\U66f4\U65b0\U9009\U62e9\U8f96\U533a";
    //        versionNumber = "1.0.0";
    
    NSString *versionNumber = [self.updateInfo objectForKey:@"versionNumber"];
    [[NSUserDefaults standardUserDefaults]setObject:versionNumber forKey:kUserIgnoreVersionKey];
    [self.navigationController popToRootViewControllerAnimated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
