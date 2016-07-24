//
//  BNRSelectLocation.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRSelectLocation.h"
#import "BNRegionCell.h"
@interface BNRSelectLocation ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *locationArr;

@end

@implementation BNRSelectLocation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initData];
    [self initViews];
    
    
}
-(void)initViews{
    self.view.backgroundColor = [UIColor blueColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择辖区";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"BNRegionCell" bundle:nil]
         forCellReuseIdentifier:@"regionCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)initData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *params = nil;
    if (self.regionNo) {
        params = @{@"regionNo":self.regionNo};
    }
    [manager GET:kGetRegionUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.locationArr = [responseObject objectForKey:@"regions"];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.locationArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BNRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"regionCell" forIndexPath:indexPath];
    cell.addressLabel.text = [self.locationArr[indexPath.row] objectForKey:@"shortName"];
    __weak BNRegionCell *weakCell = cell;
    cell.nextClicked = ^{
        NSString *regionStr = SAFE_STRING([self.locationArr[indexPath.row] objectForKey:@"no"]);
        BNRSelectLocation *vc = [BNRSelectLocation new];
        vc.selectedLocation = weakCell.addressLabel.text;
        vc.regionNo = regionStr;
        vc.selcetComplete = self.selcetComplete;
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
