//
//  STPPinMap.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface STPPinMap : NSObject <MKAnnotation>

@property(nonatomic, copy) NSString * title;
@property(nonatomic, copy) NSString * subtitle;
@property(nonatomic, assign) CLLocationCoordinate2D coordinate;
@property(nonatomic, copy) CLPlacemark * placemark;

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D) coordinate;
-(id)initWithPlacemark:(CLPlacemark *)placemark;

@end
