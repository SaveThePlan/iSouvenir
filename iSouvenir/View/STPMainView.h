//
//  STPMainView.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+STPViewForAutoLayout.h"
#import "STPmyToolbar.h"
#import <MapKit/MapKit.h>

@protocol STPMainViewActionDelegate <NSObject>

-(void)onLongPressOnMapWithLocation:(CLLocation *)touchLocation;

@end

@interface STPMainView : UIView 

@property(retain) id<STPMainViewActionDelegate> actionDelegate;


-(void)setToolbarDelegate:(id<STPmyToolbarActionDelegate>)toolbarDelegate;
-(void)setMapDelegate:(id<MKMapViewDelegate>)mapDelegate;

-(void) setMapRegion:(MKCoordinateRegion) region;
-(CLLocation *) userMapLocation;
-(CLLocationCoordinate2D) centerMapCoordinate;
-(void)addPinToMap:(id<MKAnnotation>)pin;

-(void)setEnableToolbarFollow:(BOOL)enable;
-(void)setEnableToolbarGeoCode:(BOOL)enable;

-(UIToolbar *)toolbar;
-(UIBarButtonItem *)searchButtonFromToolbar;
@end
