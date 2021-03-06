//
//  STPmyToolbar.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPmyToolbar.h"
#import "UIBarButtonItem+STPCustomImage.h"

@interface STPmyToolbar() {
    UIBarButtonItem * locationTbBt, * searchTbBt, * followTbBt, * deleteTbBt, * geoCodeTbBt, * bookmarksTbBt;
}

@end

@implementation STPmyToolbar

- (id)init
{
    self = [super init];
    if (self) {
        UIBarButtonItem * fixSpace, * flexSpace;
        
        fixSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                 target:nil action:nil];
        flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                  target:nil action:nil];

        locationTbBt = [[UIBarButtonItem alloc]
                        initWithCustomImageName:@"addPin" type:@"png" style:UIBarButtonItemStylePlain];
        
        followTbBt = [[UIBarButtonItem alloc]
                      initWithCustomImageName:@"follow" type:@"png" style:UIBarButtonItemStylePlain];
        
        geoCodeTbBt = [[UIBarButtonItem alloc]
                      initWithCustomImageName:@"geoCode" type:@"png" style:UIBarButtonItemStylePlain];
        
        searchTbBt = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:nil action:nil];
        
        deleteTbBt = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:nil action:nil];
        
        bookmarksTbBt = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:nil action:nil];
        
        [self setItems:[NSArray arrayWithObjects:
                        followTbBt,
                        flexSpace,
                        locationTbBt, fixSpace, bookmarksTbBt, fixSpace, deleteTbBt,
                        flexSpace,
                        searchTbBt, fixSpace, geoCodeTbBt,
                        nil]];
        
        [locationTbBt release];
        [searchTbBt release];
        [followTbBt release];
        [deleteTbBt release];
        [geoCodeTbBt release];
        [bookmarksTbBt release];
        [fixSpace release];
        [flexSpace release];
        
        [self setBarStyle:UIBarStyleDefault];
    }
    return self;
}


/* ---- updates ---- */

-(void)setEnableFollow:(BOOL)enable
{
    if(enable) {
        [followTbBt setTintColor:nil];
    } else {
        [followTbBt setTintColor:[UIColor lightGrayColor]];
    }
}

-(void)setEnableGeoCode:(BOOL)enable
{
    if(enable) {
        [geoCodeTbBt setTintColor:nil];
    } else {
        [geoCodeTbBt setTintColor:[UIColor lightGrayColor]];
    }
}

-(UIBarButtonItem *)searchButtonItem
{
    return searchTbBt;
}

-(UIBarButtonItem *)locationMarkButtonItem
{
    return locationTbBt;
}

-(UIBarButtonItem *)bookmarksButtonItem
{
    return bookmarksTbBt;
}


/* ---- END updates ---- */


/* ---- Properties ---- */

//actionDelegate
@synthesize actionDelegate = _actionDelegate;

-(void)setActionDelegate:(id<STPmyToolbarActionDelegate>)actionDelegate
{
    [_actionDelegate release];
    _actionDelegate = [actionDelegate retain];
    
    //set targets and actions on buttons
    [locationTbBt setTarget:_actionDelegate];
    [locationTbBt setAction:@selector(onLocationMarkButtonClick:)];
    [searchTbBt setTarget:_actionDelegate];
    [searchTbBt setAction:@selector(onSearchButtonClick:)];
    [followTbBt setTarget:_actionDelegate];
    [followTbBt setAction:@selector(onFollowButtonClick:)];
    [deleteTbBt setTarget:_actionDelegate];
    [deleteTbBt setAction:@selector(onDeleteButtonClick:)];
    [geoCodeTbBt setTarget:_actionDelegate];
    [geoCodeTbBt setAction:@selector(onGeoCodeButtonClick:)];
    [bookmarksTbBt setTarget:_actionDelegate];
    [bookmarksTbBt setAction:@selector(onBookmarksButtonClick:)];
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
