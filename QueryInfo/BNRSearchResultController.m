//
//  BNRSearchResultController.m
//  QueryInfo
//
//  Created by 袁云龙 on 16/7/25.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "BNRSearchResultController.h"
#import "LocationItem.h"
#import "AppDelegate.h"
@interface BNRSearchResultController ()
@property (weak, nonatomic) IBOutlet UIButton *searchCompleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueSearchBtn;
@property (weak, nonatomic) IBOutlet UIView *searchResultBackView;

@property (nonatomic, copy) NSString    *tips;

@property (nonatomic, assign) NSInteger dayCount;
@property (nonatomic, assign) NSInteger monthCount;
@end

@implementation BNRSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    self.title = @"查询结果";
    self.view.backgroundColor = [HETUIConfig colorFromHexRGB:@"6ea4f4"];
    
    self.searchCompleteBtn.layer.cornerRadius = 5.0f;
    self.continueSearchBtn.layer.cornerRadius = 5.0f;
    
    self.searchNumLabel.text = _searchStr;
    
    [self searchNum:_searchStr];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSDictionary *dic = @{@"date":[[NSDate date] LocalDayISO8601String],@"dayCount":@(self.dayCount),@"monthCount":@(self.monthCount)};
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:kCheckCount];
}
-(void)initData{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kCheckCount];
    if (!dic) {
        self.dayCount = 0;
        self.monthCount = 0;
        return;
    }
    self.dayCount = [dic[@"dayCount"] integerValue];
    self.monthCount = [dic[@"monthCount"] integerValue];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchCompleteAction:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:true];
}
- (IBAction)continueSearchAction:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}




-(void)autoDismissTips:(NSString *)tips{
    self.tips = nil;
    self.tips = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tips = nil;
    });
}



-(void)searchNum:(NSString *)textNum{
    self.tips = @"正在请求地址";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    LocationItem *locationInfo = delegate.currentLocation;
    double latitude = locationInfo.latitude;
    double logtitude = locationInfo.longitude;
    
    NSString *addr = locationInfo.address;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:kUserInfoKey];
    if (userInfo == nil) {
        [self autoDismissTips:@"请设置用户信息。"];
        return;
    }
    
    NSMutableDictionary *mutaUserInfo = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
    
    [mutaUserInfo setObject:textNum forKey:@"expressNo"];
    [mutaUserInfo setObject:[NSNumber numberWithDouble:latitude] forKey:@"latitude"];
    [mutaUserInfo setObject:[NSNumber numberWithDouble:logtitude] forKey:@"longitude"];
    if (addr) {
        [mutaUserInfo setObject:addr forKey:@"addr"];
    }
    
    [manager GET:kCheckExpress parameters:mutaUserInfo progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       // NSLog(@"xxxx %@",responseObject);
        
        NSString *meg = [responseObject objectForKey:@"resultMsg"];
        NSNumber *result = [responseObject objectForKey:@"success"];
        if (!result.boolValue ) {
            self.searchResultLabel.textColor = [UIColor yellowColor];
        }else{
            self.searchResultLabel.textColor = [UIColor whiteColor];
        }
        [self plusCount];
       // NSString *success = [responseObject objectForKey:@"success"];
        self.searchResultLabel.text = meg;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@", error);
    }];
    
}
-(void)plusCount{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:kCheckCount];
    if (!dic) {
        self.dayCount++;
        self.monthCount++;
        return;
    }
    
    NSString *today = [[NSDate date] LocalDayISO8601String];
    NSString *saveDay = dic[@"date"];
    if (![saveDay isEqualToString:today]) {//在这个界面中就夸天了
        self.dayCount = 1;
        if ([[saveDay substringToIndex:7] isEqualToString:[today substringToIndex:7]]) { //没有夸月
            self.monthCount++;
        }else{
            self.monthCount = 1;
        }
    }else{
        self.dayCount++;
        self.monthCount++;
    }
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
