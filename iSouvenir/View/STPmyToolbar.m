//
//  STPmyToolbar.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPmyToolbar.h"
#import "UIBarButtonItem+STPCustomImage.h"

@interface STPmyToolbar () {
    UIBarButtonItem * locationTbBt;
    UIBarButtonItem * fixSpace, * flexSpace;
}

@end

@implementation STPmyToolbar

- (id)init
{
    self = [super init];
    if (self) {
        
        fixSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                 target:nil action:nil];
        flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                  target:nil action:nil];

        locationTbBt = [[UIBarButtonItem alloc] initWithCustomImageName:@"locationMarker" type:@"png" style:UIBarButtonItemStylePlain];
        
        [self setItems:[NSArray arrayWithObjects:locationTbBt,fixSpace, flexSpace, nil]];
        
        [locationTbBt release];
        [fixSpace release];
        [flexSpace release];
        
        [self setBarStyle:UIBarStyleDefault];
    }
    return self;
}


/* ---- Properties ---- */

//actionDelegate
@synthesize actionDelegate = _actionDelegate;

-(void)setActionDelegate:(id<STPmyToolbarActionDelegate>)actionDelegate
{
    [_actionDelegate release];
    _actionDelegate = [actionDelegate retain];
    
    //set targets and actions on buttons
    [locationTbBt setTarget:_actionDelegate];
    [locationTbBt setAction:@selector(onLocationMarkClick:)];
}

-(id<STPmyToolbarActionDelegate>)actionDelegate
{
    return _actionDelegate;
}

/* ---- END Properties ---- */


-(void)dealloc {
    [_actionDelegate release]; _actionDelegate = nil;
    
    [super dealloc];
}

@end
