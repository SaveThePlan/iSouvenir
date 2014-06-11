//
//  STPPinMap.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPPinMap.h"
#import "CLPlacemark+STPAddressString.h"

@implementation STPPinMap

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [self init];
    if(self) {
        [self setTitle:title];
        [self setCoordinate:coordinate];
    }
    return self;
}

-(id)initWithPlacemark:(CLPlacemark *)placemark
{
    self = [self init];
    if(self){
        [self setPlacemark:placemark];
        [self setCoordinate:[[_placemark location] coordinate]];
        [self setTitle:[_placemark formatAddress]];
    }
    return self;
}


-(void)dealloc
{
    [_title release]; _title = nil;
    [_placemark release]; _placemark = nil;
    
    [super dealloc];
}

@end
