//
//  BNRInputNumVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRInputNumVC.h"
#import "CLZBarScanViewController.h"
#import "BNRSearchResultController.h"
@interface BNRInputNumVC ()
@property (weak, nonatomic) IBOutlet UIButton *scanHandle;
@property (weak, nonatomic) IBOutlet UIButton *comfirmBtn;
@property (weak, nonatomic) IBOutlet UITextField *textFeild;

@property (nonatomic, copy) NSString    *tips;
@end

@implementation BNRInputNumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initViews];
}
-(void)initViews{
    self.title = @"快递单输入";
    self.view.backgroundColor = [HETUIConfig colorFromHexRGB:@"6ea4f4"];
    self.scanHandle.backgroundColor = [HETUIConfig colorFromHexRGB:@"2b58a9"];
    self.scanHandle.layer.cornerRadius = 30/2.;
    self.comfirmBtn.backgroundColor = [HETUIConfig colorFromHexRGB:@"2b58a9"];
    self.comfirmBtn.layer.cornerRadius = 30/2.;
    
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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.textFeild.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)scanHanlde:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)comfirmHandle:(id)sender {
    
    
    
    if (self.textFeild.text.length < 5) {
        [self autoDismissTips:@"输入不符合要求"];
        return;
    }
    [self toSearchResultViewController];

}

-(void)autoDismissTips:(NSString *)tips{
    self.tips = nil;
    self.tips = tips;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tips = nil;
    });
}

- (void)toSearchResultViewController
{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BNRSearchResultController *vc0 = [sb instantiateViewControllerWithIdentifier:@"BNRSearchResultController"];
    vc0.searchStr = self.textFeild.text;

    [self.navigationController pushViewController:vc0 animated:true];
}


@end
