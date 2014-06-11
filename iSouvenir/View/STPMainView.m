//
//  STPMainView.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPMainView.h"

@interface STPMainView() {
    MKMapView * mapView;
    STPmyToolbar * toolbar;
    UILongPressGestureRecognizer * longPressMap;
}

@end

@implementation STPMainView

- (id)init
{
    self = [super init];
    if (self) {
        
        [self loadInterfaceElements];
        [self loadInterfaceConstraints];
        [self loadInterfaceGestures];
        
    }
    return self;
}

-(void) loadInterfaceElements
{
    mapView = [[MKMapView alloc] initForAutoLayout];
    [mapView setScrollEnabled:YES];
    [mapView setZoomEnabled:YES];
    [mapView setShowsUserLocation:YES];
    [self addSubview:mapView];
    [mapView release];
    
    toolbar = [[STPmyToolbar alloc] initForAutoLayout];
    [self addSubview:toolbar];
    [toolbar release];
}

-(void) loadInterfaceConstraints
{
    NSDictionary * allViews = NSDictionaryOfVariableBindings(toolbar, mapView);

    //toolbar position
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[toolbar]|"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:[toolbar]|"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
    
    //mapView position
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|[mapView]|"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|[mapView]|"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];

}

-(void) loadInterfaceGestures
{
    longPressMap = [[UILongPressGestureRecognizer alloc] init];
    [longPressMap addTarget:self action:@selector(onLongPressOnMap:)];
    [mapView addGestureRecognizer:longPressMap];
}



/* ---- actions ---- */

-(void)onLongPressOnMap:(UILongPressGestureRecognizer *)longPressGesture
{

    if([longPressGesture state] == UIGestureRecognizerStateBegan) {
        CGPoint touchPoint = [longPressGesture locationInView:mapView];
        CLLocationCoordinate2D touchCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
        CLLocation * touchLocation = [[CLLocation alloc] initWithLatitude:touchCoordinate.latitude
                                                                longitude:touchCoordinate.longitude];
        [touchLocation autorelease];
        [_actionDelegate performSelector:@selector(onLongPressOnMapWithLocation:) withObject:touchLocation];
    }
    
}


/* ---- END actions ---- */


/* ---- updates ---- */

-(void) setMapRegion:(MKCoordinateRegion) region
{
    [mapView setRegion:region animated:YES];
    [mapView setNeedsDisplay];
}

-(CLLocation *) userMapLocation
{
    return [[mapView userLocation] location];
}

-(CLLocationCoordinate2D) centerMapCoordinate
{
    return [mapView centerCoordinate];
}

-(void)addPinToMap:(id<MKAnnotation>)pin
{
    [[mapView selectedAnnotations] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [mapView deselectAnnotation:obj animated:NO];
    }];
    [mapView addAnnotation:pin];
}

-(void)setEnableToolbarFollow:(BOOL)enable {
    [toolbar setEnableFollow:enable];
}

-(void)setEnableToolbarGeoCode:(BOOL)enable {
    [toolbar setEnableGeoCode:enable];
}

-(UIToolbar *) toolbar {
    return toolbar;
}

-(UIBarButtonItem *)searchButtonFromToolbar
{
    return [toolbar searchButtonItem];
}

-(UIBarButtonItem *)locationMarkButtonFromToolbar
{
    return [toolbar locationMarkButtonItem];
}

-(UIBarButtonItem *)bookmarkButtonFromToolbar
{
    return [toolbar bookmarksButtonItem];
}

-(NSArray *)selectedMapAnnotations {
    return [mapView selectedAnnotations];
}

-(void)removeSelectedMapAnnotations
{
    [mapView removeAnnotations:[mapView selectedAnnotations]];
}

-(NSArray *) allMapAnnotations
{
    return [mapView annotations];
}

/* ---- updates ---- */


/* ---- properties ---- */

//actionDelegate
@synthesize actionDelegate = _actionDelegate;
-(id<STPMainViewActionDelegate>)actionDelegate {
    return _actionDelegate;
}
-(void)setActionDelegate:(id<STPMainViewActionDelegate>)actionDelegate {
    [_actionDelegate release];
    _actionDelegate = [actionDelegate retain];
    
}

//toolbarDelegate
-(void)setToolbarDelegate:(id<STPmyToolbarActionDelegate>)toolbarDelegate
{
    [toolbar setActionDelegate:toolbarDelegate];
}

//mapDelegate
-(void)setMapDelegate:(id<MKMapViewDelegate>) mapDelegate
{
    [mapView setDelegate:mapDelegate];
}

/* ---- END properties ---- */


-(void)dealloc
{
    [_actionDelegate release]; _actionDelegate = nil;
    
    [super dealloc];
}

@end
