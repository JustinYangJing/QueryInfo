//
//  BNRegionCell.h
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BNRegionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic, copy) void (^nextClicked)(void);
@end
