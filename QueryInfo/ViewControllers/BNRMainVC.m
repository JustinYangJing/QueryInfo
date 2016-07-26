//
//  BNRMainVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/24/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRMainVC.h"
#import "UIViewController+HETAdditions.h"
#import "BNRSettingVC.h"
#import "CLZBarScanViewController.h"
#import "updataViewController.h"
//#import "YYKit.h"
@interface BNRMainVC ()
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@end

@implementation BNRMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [self settingBtn];
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backImageView.image = [UIImage imageNamed:@"bg.png"];
    [self.view insertSubview:backImageView atIndex:0];
    
    [self getVersionInfo];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self transparentNavigationBar];
    [self initData];
}
-(void)initData{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kCheckCount];
    if (!dic) {
        [self setCountWithDayCount:0 monthCount:0];
    }
    NSString *today = [[NSDate date] LocalDayISO8601String];
    NSString *saveDay = dic[@"date"];
    if (![saveDay isEqualToString:today]) {
        NSInteger dayCount = 0;
        NSInteger monthCOunt = 0;
        if ([[saveDay substringToIndex:7] isEqualToString:[today substringToIndex:7]]) {
            monthCOunt = [dic[@"monthCont"] integerValue];
        }
        [self setCountWithDayCount:dayCount monthCount:monthCOunt];
        dic = @{@"date":today,@"dayCount":@(0),@"monthCount":@(monthCOunt)};
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kCheckCount];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        [self setCountWithDayCount:[dic[@"dayCount"] integerValue]
                        monthCount:[dic[@"monthCount"] integerValue]];
    }

}
-(void)setCountWithDayCount:(NSInteger)dayCount monthCount:(NSInteger) monthCount{
    self.monthLabel.text = [NSString stringWithFormat:@"本月工查验%@次",@(monthCount)];
    self.dayLabel.text = [NSString stringWithFormat:@"今日工查验%@次",@(dayCount)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BNRSettingVC *vc = [sb instantiateViewControllerWithIdentifier:@"SettingVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)scanHandle:(id)sender {
    CLZBarScanViewController *vc = [CLZBarScanViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)getVersionInfo{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:@"http://61.164.44.169:39175/qs/app/getLatestIosVerInfo" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        deviceType = 2;
//        isRequired = 0;
//        releaseTime = "2016-07-26 07:52:24";
//        updateComment = "1\U3001\U66f4\U65b0\U9009\U62e9\U5feb\U9012\U516c\U53f8\n2\U3001\U66f4\U65b0\U9009\U62e9\U8f96\U533a";
//        versionNumber = "1.0.0";
        
        //比较版本信息
        NSString *versionNumber = [responseObject objectForKey:@"versionNumber"];
        NSArray *versionArray = [versionNumber componentsSeparatedByString:@"."];
        NSLog(@"responseObject %@", responseObject);
        
        NSDictionary *infoDic = [[NSBundle mainBundle]infoDictionary];
        NSString *app_Version = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSArray *currentArray = [app_Version componentsSeparatedByString:@"."];
        NSLog(@"app_Version %@", app_Version);
        

        NSString *ignoreVersion = [[NSUserDefaults standardUserDefaults]objectForKey:kUserIgnoreVersionKey];
        if (ignoreVersion != nil || [ignoreVersion isEqualToString:versionNumber]) {
            return ;
        }
        
        if (versionArray.count != currentArray.count) {
            return ;
        }
        
        int i = 0;
        BOOL isneedUpdate = false;
        for (; i < versionArray.count; i++) {
            NSString *lastMajorVersion = versionArray[i];
            NSString *currentMajorVersion = currentArray[i];
            NSNumber *lastMajorVersionNum = @([lastMajorVersion integerValue]);
            NSNumber *currentMajorVersionNum = @([currentMajorVersion integerValue]);
            if (lastMajorVersionNum.integerValue > currentMajorVersionNum.integerValue) {
                isneedUpdate = true;
                break;
            }
        }
        
        if (!isneedUpdate) {
            return;
        }
        
        
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        updataViewController *vc = [sb instantiateViewControllerWithIdentifier:@"updataViewController"];
        vc.updateInfo = responseObject;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error");
    }];
    
}

@end
