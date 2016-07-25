//
//  BNRSelectLocation.h
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import "BNRBaseViewVC.h"

@interface BNRSelectLocation : BNRBaseViewVC

//上级传入的
@property (nonatomic,copy) NSString *selectedLocation;
@property (nonatomic,copy) NSString *regionNo;

//传出的
@property (nonatomic,copy) void (^selcetComplete)(NSString *locationStr, NSString *regionNo);

@property (nonatomic,strong) NSArray *locationArr;
@end
