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
typedef NS_ENUM(NSInteger,UserType) {
    UserTypeDeliverOffice,
    UserTypePolice,
    UserTypePostOffice,
    UserTypeOthers
};
@interface BNRSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic,assign) UserType userType;
/**
 *  二维数组，存放用户选择的信息
 */
@property (nonatomic,strong) NSMutableArray *dataArr;
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
    self.view.backgroundColor  = [UIColor greenColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 100, self.view.frame.size.width-30, 56*4) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"BNRTableViewCell" bundle:nil] forCellReuseIdentifier:@"settingCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.tableHeaderView = [UIView new];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}
-(void)initData{
    self.dataArr = [NSMutableArray arrayWithCapacity:8];
    NSArray *keys = @[@"用户类型",@"辖区",@"公司",@"姓名"];
    NSMutableArray *values = [NSMutableArray arrayWithObjects:@"寄递企业",@"点击选择辖区",@"点击选择公司",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];
    
    keys = @[@"用户类型",@"辖区",@"警号"];
    values = [NSMutableArray arrayWithObjects:@"公安部门",@"点击选择辖区",@"请输入警号", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];
    
    keys = @[@"用户类型",@"辖区",@"姓名"];
    values = [NSMutableArray arrayWithObjects:@"邮管部门",@"点击选择辖区",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];

    keys = @[@"用户类型",@"部门",@"姓名"];
    values = [NSMutableArray arrayWithObjects:@"其他部门",@"请输入部门",@"请输入姓名", nil];
    [self.dataArr addObject:keys];
    [self.dataArr addObject:values];

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 56;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArr[self.userType*2];
    self.tableView.frame = CGRectMake(15, 100, self.view.frame.size.width-30, 56*arr.count);
    return arr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
     NSArray *keys = self.dataArr[self.userType*2];
    cell.TypeLabel.text = keys[indexPath.row];
    NSArray *values = self.dataArr[self.userType*2+1];
    cell.contentLabel.text = values[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        HETActionSheet *sheet = [HETActionSheet sheetCancelTitile:@"取消" otherTitles:@[@"其他部门",@"邮管部门",@"公安部门",@"寄递企业"]];
        [sheet showInView:self.view click:^(NSInteger index) {
            self.userType = 3-index;
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
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    if (indexPath.row == 1 && self.userType != UserTypeOthers) {
        BNRSelectLocation *vc = [[BNRSelectLocation alloc] init];
        vc.selcetComplete = ^(NSString *str , NSString *regionNo){
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
