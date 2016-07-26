//
//  BNRSearchResultController.m
//  QueryInfo
//
//  Created by 袁云龙 on 16/7/25.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "BNRSearchResultController.h"

@interface BNRSearchResultController ()
@property (weak, nonatomic) IBOutlet UIButton *searchCompleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *continueSearchBtn;
@property (weak, nonatomic) IBOutlet UIView *searchResultBackView;

@property (nonatomic, copy) NSString    *tips;

@end

@implementation BNRSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"查询结果";
    self.view.backgroundColor = [HETUIConfig colorFromHexRGB:@"6ea4f4"];
    
    self.searchCompleteBtn.layer.cornerRadius = 5.0f;
    self.continueSearchBtn.layer.cornerRadius = 5.0f;
    
    self.searchNumLabel.text = _searchStr;
    
    [self searchNum:_searchStr];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tips = nil;
    });
}



-(void)searchNum:(NSString *)textNum{
    self.tips = @"正在请求地址";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults]objectForKey:kUserInfoKey];
    NSMutableDictionary *mutaUserInfo = [[NSMutableDictionary alloc]initWithDictionary:userInfo];
    
    [mutaUserInfo setObject:textNum forKey:@"expressNo"];
    

    [manager GET:kCheckExpress parameters:mutaUserInfo progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       // NSLog(@"xxxx %@",responseObject);
        
        NSString *meg = [responseObject objectForKey:@"resultMsg"];
       // NSString *success = [responseObject objectForKey:@"success"];
        self.searchResultLabel.text = meg;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@", error);
    }];
    
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
