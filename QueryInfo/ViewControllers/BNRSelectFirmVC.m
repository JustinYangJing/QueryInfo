//
//  BNRSelectFirmVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRSelectFirmVC.h"

@interface BNRSelectFirmVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSArray      *companyArr;
@end

@implementation BNRSelectFirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
    [self queryCompanyWithName:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"选择公司";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
    self.tableView.tableFooterView = [UIView new];
    
    self.searchTextField.placeholder = @"查询";
    self.searchTextField.backgroundColor = [HETUIConfig colorFromHexRGB:@"e5e5e5"];
    self.searchTextField.textColor = [HETUIConfig colorFromHexRGB:@"777777"];
    self.searchTextField.delegate = self;
    [self.searchTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)queryCompanyWithName:(NSString *)name{
    static NSURLSessionDataTask *task;
    if (task) {
        [task cancel];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *parmas = @{@"companyName":SAFE_STRING(name)};
    task = [manager GET:kQueryCompany parameters:parmas progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        task = nil;
        self.companyArr = responseObject[@"companys"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        task = nil;
    }];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.companyArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"companyCell" forIndexPath:indexPath];
    NSDictionary *dic = self.companyArr[indexPath.row];
    cell.textLabel.text = dic[@"kdmc"];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    !self.completeCompany?:self.completeCompany(self.companyArr[indexPath.row]);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - textfeild
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textChange:(UITextField *)textField{
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//获取高亮部分
    static NSString *lastStr;
    if (!position) {
        if (![lastStr isEqualToString:textField.text]) {
            lastStr = textField.text;
            [self queryCompanyWithName:lastStr];
        }
    }

}
@end
