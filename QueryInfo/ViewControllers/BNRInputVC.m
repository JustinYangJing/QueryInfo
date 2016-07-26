//
//  BNRInputVC.m
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRInputVC.h"

@interface BNRInputVC ()
@property (nonatomic,strong) UITextField *textField;
@end

@implementation BNRInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor greenColor];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(complete) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 100, self.view.frame.size.width-32, 40)];
    self.textField.placeholder = self.placeHolderStr;
    [self.textField becomeFirstResponder];
    [self.view addSubview:self.textField];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)complete{
    if (self.textField.text.length < 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
        hud.labelText = @"输入不符合要求";
        [hud show:YES];
        [hud hide:YES afterDelay:1];
       
        return;
        
    }
    !self.inputComplete?:self.inputComplete(self.textField.text);
    [self.navigationController popViewControllerAnimated:YES];
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
