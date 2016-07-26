//
//  BNRSearchResultController.h
//  QueryInfo
//
//  Created by 袁云龙 on 16/7/25.
//  Copyright © 2016年 JustinYang. All rights reserved.
//

#import "BNRBaseViewVC.h"

@interface BNRSearchResultController : BNRBaseViewVC
@property (weak, nonatomic) IBOutlet UILabel *searchNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *searchResultLabel;

@property (nonatomic, strong) NSString *searchStr;
@end
