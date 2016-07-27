//
//  BNRSettingVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRSettingVC.h"
#import "BNRTableViewCell.h"

//views
#import "HETActionSheet.h"
//VC
#import "BNRInputVC.h"
#import "BNRSelectLocation.h"
#import "BNRSelectFirmVC.h"
typedef NS_ENUM(NSInteger,UserType) {
    UserTypePolice,
    UserTypePostOffice,
    UserTypeDeliverOffice,
    UserTypeOthers
};
@interface BNRSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,assign) UserType userType;
/**
 *  二维数组，存放用户选择的信息
 */
@property (nonatomic,strong) NSMutableArray     *dataArr;

@property (nonatomic,copy)   NSString            *tips;
@property (nonatomic,strong) NSMutableDictionary    *userInfo;

@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@end

@implementation BNRSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initViews];
}
-(void)initViews{
    self.title = @"设置用户信息";
   // self.view.backgroundColor  = [UIColor greenColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 64+21, self.view.frame.size.width-30, 56*4) style:UITableViewStylePlain];
    self.tableView.layer.cornerRadius = 3.;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BNRTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    self.tableView.scrollEnabled = false;
    [self.view addSubview:self.tableView];
    self.tableView.layer.cornerRadius = 3.;
    self.tableView.backgroundColor = [HETUIConfig colorFromHexRGB:@"003361" alpha:0.6];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.completeBtn.layer.cornerRadius = 3.;
}
-(void)initData{
    self.dataArr = [NSMutableArray arrayWithCapacity:8];
    self.userType = UserTypePolice;
    NSArray *keys = @[@"用户类型",@"辖区",@"警号"];
    NSMutableArray *values = [NSMutableArray arrayWithObjects:@"公安部门",@"点击选择辖区",@"请输入警号", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];
    
    keys = @[@"用户类型",@"辖区",@"姓名"];
    values = [NSMutableArray arrayWithObjects:@"邮管部门",@"点击选择辖区",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];
    
    keys = @[@"用户类型",@"辖区",@"公司",@"姓名"];
    values = [NSMutableArray arrayWithObjects:@"寄递企业",@"点击选择辖区",@"点击选择公司",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];

    keys = @[@"用户类型",@"部门",@"姓名"];
    values = [NSMutableArray arrayWithObjects:@"其他部门",@"请输入部门",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];

    @weakify(self);
    [[RACObserve(self, tips) skip:1] subscribeNext:^(id x) {
        @strongify(self);
        if (self.tips) {
            MBProgressHUD *loadHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            loadHUD.labelText = self.tips;
        }else{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:kUserInfoKey];
    if (userInfo) {
        NSNumber *index = userInfo[@"userType"];
        NSMutableArray *values = self.dataArr[index.integerValue*2+1];
        self.userType = index.integerValue;
        switch (self.userType) {
            case UserTypePolice:
            case UserTypePostOffice:
                values[1] = SAFE_STRING(userInfo[@"regionName"]);
                values[2] = SAFE_STRING(userInfo[@"userRealname"]);
                break;
            case UserTypeDeliverOffice:
                values[1] = SAFE_STRING(userInfo[@"regionName"]);
                values[3] = SAFE_STRING(userInfo[@"userRealname"]);
                values[2] = SAFE_STRING(userInfo[@"kdmc"]);
                break;
            case  UserTypeOthers:
                values[1] = SAFE_STRING(userInfo[@"deptName"]);
                values[2] = SAFE_STRING(userInfo[@"userRealname"]);
                break;
            default:
                break;
        }
        [self.tableView reloadData];
        self.userInfo = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    }else{
        self.userInfo = [NSMutableDictionary dictionary];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[self.userType*2];
    self.tableView.frame = CGRectMake(15, 100, self.view.frame.size.width-30, 64*arr.count);
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
     NSArray *keys = self.dataArr[self.userType*2];
    cell.TypeLabel.text = keys[indexPath.row];
    NSArray *values = self.dataArr[self.userType*2+1];
    cell.contentLabel.text = values[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HETActionSheet *sheet = [HETActionSheet sheetCancelTitile:@"取消" otherTitles:@[@"其他部门",@"寄递企业",@"邮管部门",@"公安部门"]];
        [sheet showInView:self.view click:^(NSInteger index) {
            self.userType = 3-index;
            [self.userInfo setObject:@(self.userType) forKey:@"userType"];
            [self.tableView reloadData];
        }];
    }
    NSArray *keys = self.dataArr[self.userType*2];
    NSMutableArray *values = self.dataArr[self.userType*2+1];
    if (indexPath.row == (keys.count - 1)) {
        BNRInputVC *vc = [[BNRInputVC alloc] init];
        vc.title = keys[indexPath.row];
        vc.placeHolderStr = values[indexPath.row];
        vc.inputComplete = ^(NSString *str){
            values[keys.count-1] = str;
            [self.userInfo setObject:str forKey:@"userRealname"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.row == 1 && self.userType != UserTypeOthers) {
        [self pushToSelectRegionVC];
    }
    if (indexPath.row == 2 && self.userType == UserTypeDeliverOffice) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BNRSelectFirmVC *vc = [sb instantiateViewControllerWithIdentifier:@"selectFirmVC"];
        vc.completeCompany = ^(NSDictionary *dic){
            values[2] = dic[@"kdmc"];
            [self.tableView reloadData];
            [self.userInfo addEntriesFromDictionary:dic];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    if (indexPath.row == 1 && self.userType == UserTypeOthers) {
        BNRInputVC *vc = [[BNRInputVC alloc] init];
        vc.title = keys[indexPath.row];
        vc.placeHolderStr = values[indexPath.row];
        vc.inputComplete = ^(NSString *str){
            values[1] = str;
            [self.userInfo setObject:str forKey:@"deptName"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)pushToSelectRegionVC{
    self.tips = @"正在请求地址";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *params = nil;
    [manager GET:kGetRegionUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tips = nil;
        BNRSelectLocation *vc = [[BNRSelectLocation alloc] init];
        vc.locationArr = [responseObject objectForKey:@"regions"];
        vc.selcetComplete = ^(NSString *str , NSString *regionNo){
            [self.navigationController popToViewController:self animated:YES];
             NSMutableArray *values = self.dataArr[self.userType*2+1];
             values[1] = str;
            [self.userInfo setObject:regionNo forKey:@"regionNo"];
            [self.userInfo setObject:str forKey:@"regionName"];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self autoDismissTips:@"网络连接错误"];
    }];

}

-(void)autoDismissTips:(NSString *)tips{
    self.tips = nil;
    self.tips = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tips = nil;
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)completeHanlde:(id)sender {
    NSMutableArray *values = self.dataArr[self.userType*2+1];
    for (NSString *str in values) {
        if ([str isEqual:@"请输入部门"] ||
            [str isEqual:@"请输入姓名"] ||
            [str isEqual:@"点击选择辖区"] ||
            [str isEqual:@"请输入警号"]) {
            [self autoDismissTips:@"请完善您的资料"];
            return;
        }
    }
    
    NSDictionary *finallyUserInfo;
    switch (self.userType) {
        case UserTypePolice:
        case UserTypePostOffice:
            finallyUserInfo = @{@"userType":@(self.userType),@"regionNo":self.userInfo[@"regionNo"],
                                @"userRealname":self.userInfo[@"userRealname"]};
            break;
        case UserTypeDeliverOffice:
            finallyUserInfo = @{@"userType":@(self.userType),@"regionNo":self.userInfo[@"regionNo"],
                                @"kdbh":self.userInfo[@"kdbh"],@"kdmc":self.userInfo[@"kdmc"],
                                @"userRealname":self.userInfo[@"userRealname"]};
            break;
        case UserTypeOthers:
            finallyUserInfo = @{@"userType":@(self.userType),@"deptName":self.userInfo[@"deptName"],
                                @"userRealname":self.userInfo[@"userRealname"]};
            break;
        default:
            break;
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userInfo forKey:kUserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
   // [self.navigationController popViewControllerAnimated:YES];
    self.tips = @"正在上传资料";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager GET:kUploadUserInfo parameters:finallyUserInfo progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tips = nil;
        NSNumber *result = [responseObject objectForKey:@"success"];
        if (result.boolValue ) {
            [self autoDismissTips:[responseObject objectForKey:@"resultMsg"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self autoDismissTips:[responseObject objectForKey:@"resultMsg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self autoDismissTips:@"网络连接错误"];
        [self.navigationController popViewControllerAnimated:YES];
    }];

}


@end
