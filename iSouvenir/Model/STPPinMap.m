//
//  STPPinMap.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPPinMap.h"

@implementation STPPinMap

-(id)initWithTitle:(NSString *)title andCoordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self) {
        [self setTitle:title];
        [self setCoordinate:coordinate];
    }
    return self;
}

-(void)dealloc
{
    [_title release]; _title = nil;
    
    [super dealloc];
}

@end
