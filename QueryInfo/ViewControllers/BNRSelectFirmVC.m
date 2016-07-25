//
//  BNRSelectFirmVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRSelectFirmVC.h"

@interface BNRSelectFirmVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,copy) NSArray      *companyArr;
@end

@implementation BNRSelectFirmVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initViews{
    self.title = @"选择公司";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

-(void)queryCompanyWithName:(NSString *)name{
    static NSURLSessionDataTask *task;
    if (task) {
        [task cancel];
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];

    task = [manager GET:kGetRegionUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
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


@end
