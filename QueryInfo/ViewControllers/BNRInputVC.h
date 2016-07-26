//
//  BNRInputVC.h
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRBaseViewVC.h"

@interface BNRInputVC : BNRBaseViewVC

@property (nonatomic,copy) void (^inputComplete)(NSString *str);
@property (nonatomic,copy) NSString *placeHolderStr;


@end
