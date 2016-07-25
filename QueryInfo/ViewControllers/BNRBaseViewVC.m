//
//  BNRBaseViewVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRBaseViewVC.h"

@interface BNRBaseViewVC ()

@end

@implementation BNRBaseViewVC

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing: YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createBackButton];
}


- (void)createBackButton{
    UIImage *backImage = [UIImage imageNamed:@"nav_icon_back"];
    CGRect frame = CGRectMake(0, 0, 30, 30);
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = frame;
    [backButton setImage: backImage forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:backButton] animated:NO];
}

- (void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"%@ dealloc",self);
}
@end
