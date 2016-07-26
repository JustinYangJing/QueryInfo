//
//  LocationManager.m
//  MicroBo
//
//  Created by Franklin Zhang on 2/6/15.
//  Copyright (c) 2015 Macrame. All rights reserved.
//

#import "LocationManager.h"
#import "CLLocation+Sino.h"
#import "AppDelegate.h"
static LocationManager *sharedInstance;
@implementation LocationManager
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    
    return sharedInstance;
}
- (void) startLocate
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 200.0f;
    [locationManager startUpdatingLocation];
    
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {                [manager requestWhenInUseAuthorization];
            }
            break;
        case kCLAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:nil
                                  message:NSLocalizedString(@"label.main.enable_location_information", nil)
                                  delegate:nil
                                  cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
                                  otherButtonTitles:nil];
            [alert show];
        }
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [manager startUpdatingLocation];
            break;
        default:
            
            break;
    }
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    for(CLLocation *location in locations)
    {
        NSLog(@"BluetoothManager: --> Location :%.8f,%.10f",location.coordinate.latitude,location.coordinate.longitude);
    }
    CLLocation *location = [locations lastObject];
    CLLocation *GCJ02Location = [location locationMarsFromEarth];
    
    AppDelegate *delegate =  [UIApplication sharedApplication].delegate;
    LocationItem *item = delegate.currentLocation;
    if(item == nil)
    {
        item = [[LocationItem alloc] init];
        delegate.currentLocation = item;
    }
    item.latitude = GCJ02Location.coordinate.latitude;
    item.longitude = GCJ02Location.coordinate.longitude;
    item.locationDescription = GCJ02Location.description;
    item.creationTime = [NSDate date];
    //NSLog(@"insert item location:%f,%f",item.latitude, item.longitude);
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //self.location.text = placemark.name;
            //获取城市
            NSString *address = [NSString new];
            NSString *city = placemark.locality;
            NSString *subThoroughfare = placemark.subThoroughfare;
            NSString *thoroughfare = placemark.thoroughfare;
            NSString *subLocality = placemark.subLocality;
            NSString *administrativeArea = placemark.administrativeArea;
            NSString *subAdministrativeArea = placemark.subAdministrativeArea;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            if(administrativeArea != nil){
                address = [NSString stringWithFormat:@"%@%@",address,administrativeArea];
            }
            if(subAdministrativeArea != nil){
                address = [NSString stringWithFormat:@"%@-%@",address,subAdministrativeArea];
            }
            if(city != nil){
                address = [NSString stringWithFormat:@"%@-%@",address,city];
            }
            if(subLocality != nil){
                address = [NSString stringWithFormat:@"%@-%@",address,subLocality];
            }
            if(thoroughfare != nil){
                address = [NSString stringWithFormat:@"%@-%@",address,thoroughfare];
            }
            if(subThoroughfare != nil){
                address = [NSString stringWithFormat:@"%@-%@",address,subThoroughfare];
            }
            item.address = address;
           // _cityLable.text = city;
           // [_cityButton setTitle:city forState:UIControlStateNormal];
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
    NSLog(@"Fail to location :%@",error.description);
    /*UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Common.Failure",nil)
     message:NSLocalizedString(@"label.main.location_error_information", nil)
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
     otherButtonTitles:nil];
     [alert show];*/
}
- (void)locationManager:(CLLocationManager *)manager didFinishDeferredUpdatesWithError:(NSError *)error
{
    //[super hideProgress];
    
    NSLog(@"Fail to location :%@",error.description);
    /*UIAlertView *alert = [[UIAlertView alloc]
     initWithTitle:NSLocalizedString(@"Common.Failure",nil)
     message:error.description
     delegate:nil
     cancelButtonTitle:NSLocalizedString(@"Common.OK",nil)
     otherButtonTitles:nil];
     [alert show];*/
}

@end
