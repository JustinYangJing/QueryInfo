//
//  BNRServerInterface.h
//  QueryInfo
//
//  Created by JustinYang on 7/25/16.
//  Copyright © 2016 JustinYang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SAFE_STRING(str) (![str isKindOfClass: [NSString class]] ? @"" : str)

#define SAFE_NUMBER(value) (![value isKindOfClass: [NSNumber class]] ? @(-1) : value)

#define kServerIP   @"http://115.236.32.253:39175/qs/app/"

//#define kServerIP   @"http://61.164.44.169:39175/qs/app/"  //测试服务器
#define kGetRegionUrl       [NSString stringWithFormat:@"%@getRegionInfo",kServerIP]

#define kQueryCompany       [NSString stringWithFormat:@"%@queryCompanyByName",kServerIP]


#define kUploadUserInfo     [NSString stringWithFormat:@"%@uploadUserInfo",kServerIP]

#define kVersionNumber     [NSString stringWithFormat:@"%@getLatestIosVerInfo",kServerIP]

#define kCheckExpress     [NSString stringWithFormat:@"%@checkExpress",kServerIP]