//
//  LocationManager.h
//  MicroBo
//
//  Created by Franklin Zhang on 2/6/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "LocationItem.h"
@interface LocationManager : NSObject<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
+ (instancetype)sharedInstance;
- (void) startLocate;
@end
