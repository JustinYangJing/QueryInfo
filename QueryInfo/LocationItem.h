//
//  LocationItem.h
//  MicroBo
//
//  Created by Franklin Zhang on 2/8/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationItem : NSObject
@property (nonatomic, retain) NSDate *creationTime;
@property double latitude;//纬度
@property double longitude;//经度
@property (nonatomic, retain) NSString *locationDescription;
@end
