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
@property (nonatomic,strong) UILabel    *headLabel;

@property (nonatomic,copy)  NSString    *tips;
@end

@implementation BNRSelectLocation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    
    self.headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 28)];
    self.headLabel.text = self.selectedLocation;
    self.headLabel.font = [UIFont systemFontOfSize:18];
    self.headLabel.backgroundColor = [HETUIConfig colorFromHexRGB:@"00b7e8" alpha:1];
    self.headLabel.textColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = self.headLabel;
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
    cell.addressLabel.textColor = [HETUIConfig colorFromHexRGB:@"555555" alpha:1];
    @weakify(self);
    cell.nextClicked = ^{
         @strongify(self);
        [self didClickNextWithIndexPath:indexPath];
    };
    return cell;
}

-(void)didClickNextWithIndexPath:(NSIndexPath *)indexPath{
    NSString *regionName = SAFE_STRING([self.locationArr[indexPath.row] objectForKey:@"shortName"]);
    NSString *regionNo = SAFE_STRING([self.locationArr[indexPath.row] objectForKey:@"no"]);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    NSDictionary *params = nil;
    params = @{@"regionNo":regionNo};
    self.tips = @"正在加载数据";
    [manager GET:kGetRegionUrl parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.tips = nil;
        NSArray *locationArr = [responseObject objectForKey:@"regions"];
        if (locationArr.count == 0) {
            !self.selcetComplete?:self.selcetComplete(regionName,regionNo);
        }else{
            BNRSelectLocation *vc = [BNRSelectLocation new];
            if (self.selectedLocation) {
                vc.selectedLocation = [NSString stringWithFormat:@"%@ > %@",self.selectedLocation,regionName];
            }else{
                vc.selectedLocation = regionName;
            }
            vc.regionNo = regionNo;
            vc.locationArr = locationArr;
            vc.selcetComplete = self.selcetComplete;
            [self.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self autoDismissTips:@"加载数据失败"];
    }];

}

-(void)autoDismissTips:(NSString *)tips{
    self.tips = nil;
    self.tips = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tips = nil;
    });
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *regionName = SAFE_STRING([self.locationArr[indexPath.row] objectForKey:@"shortName"]);
    NSString *regionNo = SAFE_STRING([self.locationArr[indexPath.row] objectForKey:@"no"]);
    !self.selcetComplete?:self.selcetComplete(regionName,regionNo);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
