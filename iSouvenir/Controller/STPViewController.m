//
//  STPViewController.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPViewController.h"
#import "STPPinMap.h"

@interface STPViewController () {
    STPMainView * mainView;
    CLLocationManager * locationManager;
    
    float mapSpanDelta;
}

@end

@implementation STPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if([CLLocationManager locationServicesEnabled]) {
        
        mapSpanDelta = 0.035;
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDistanceFilter:1.0];
        [locationManager setDelegate:self];
        
        [self loadMainView];
        
        [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                                  duration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
        
        //start location
        [locationManager startUpdatingLocation];
    } else {
        UIAlertView * tmpAlert = [[UIAlertView alloc]
                                  initWithTitle:@"Erreur"
                                  message:@"Service de localisation inactif. Vérifiez vos paramètres..."
                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [tmpAlert autorelease];
        [tmpAlert show];
    }
}

-(void) loadMainView {
    mainView = [[STPMainView alloc] initForAutoLayout];

    [mainView setActionDelegate:self];
    [mainView setToolbarDelegate:self];
    [mainView setMapDelegate:self];

    [[self view] addSubview:mainView];
    
    [mainView release];
    
    
    NSDictionary * allViews = NSDictionaryOfVariableBindings(mainView);
    
    [[self view] addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"H:|[mainView]|"
                                 options:NSLayoutFormatDirectionLeftToRight
                                 metrics:nil views:allViews]];
    [[self view] addConstraints:[NSLayoutConstraint
                                 constraintsWithVisualFormat:@"V:|[mainView]|"
                                 options:NSLayoutFormatDirectionLeftToRight
                                 metrics:nil views:allViews]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    BOOL isLandscape = (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
                        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    if(isLandscape){
        [mainView setFrame:CGRectMake(0, 0, screen.size.height, screen.size.width)];
    } else {
        [mainView setFrame:CGRectMake(0, 0, screen.size.width, screen.size.height)];
    }
}


/* ---- STPMainViewActionDelegate ---- */

-(void)onLongPressOnMapWithLocation:(CLLocation *)touchLocation
{
    STPPinMap * pin = [[STPPinMap alloc] initWithTitle:@"lieu touché" andCoordinate:[touchLocation coordinate]];
    [mainView addPinToMap:pin];
    [pin release];
}

/* ---- END STPMainViewActionDelegate ---- */


/* ---- STPmyToolbarActionDelegate ---- */

-(void)onLocationMarkClick:(id)sender {
    STPPinMap * pin = [[STPPinMap alloc] initWithTitle:@"lieu marqué" andCoordinate:[mainView userCoordinate]];
    [mainView addPinToMap:pin];
    [pin release];
}

/* ---- END STPmyToolbarActionDelegate ---- */


/* ---- CoreLocationManager Delegate ---- */

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //map
    CLLocationCoordinate2D coord = {
        .latitude = [[locations lastObject] coordinate].latitude,
        .longitude = [[locations lastObject] coordinate].longitude
    };
    MKCoordinateSpan span = {
        .latitudeDelta = mapSpanDelta,
        .longitudeDelta = mapSpanDelta
    };
    MKCoordinateRegion region = {coord, span};
    
    [mainView setMapRegion:region];
    
    //stop updating
    [locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertView * errorAlert = [[UIAlertView alloc]
                                initWithTitle:@"Erreur"
                                message:[NSString stringWithFormat:@"Localisation impossible : %@", [error description]]
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert autorelease];
    [errorAlert show];
}

/* ---- END CoreLocationManager Delegate ---- */


/* ---- MKMapView Delegate ---- */

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateSpan span = {
        .latitudeDelta = mapSpanDelta,
        .longitudeDelta = mapSpanDelta
    };
    MKCoordinateRegion region = {[[userLocation location]coordinate], span};
    [mapView setRegion:region animated:YES];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if(annotation == [mapView userLocation]) {
        return nil;
    }
    MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:@"ppm"];
    [pin setPinColor:MKPinAnnotationColorGreen];
    [pin setCanShowCallout:YES];
    [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control {
//    [self displayLattitudeAndLongitudeWithCoordinate:[[view annotation] coordinate]];
}

/* ---- END MKMapView Delegate ---- */


-(void)dealloc
{
    [locationManager release]; locationManager = nil;
    
    [super dealloc];
}

@end
