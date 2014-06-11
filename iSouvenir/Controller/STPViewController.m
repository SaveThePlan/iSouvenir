//
//  STPViewController.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPViewController.h"
#import "STPPinMap.h"
#import "CLPlacemark+STPAddressString.h"

@interface STPViewController () {
    STPMainView * mainView;
    UIAlertView * searchAlert, * markSearchAlert;
    UIActionSheet * resultsActionSheet;
    CLLocationManager * locationManager;
    CLGeocoder * geoCoder;
    
    float mapSpanDelta;
    BOOL isFollowingUser;
    BOOL isGeoCodingLocations;
    int pinCount;
    NSMutableDictionary * placemarksSearch;
    
    BOOL isIpad;
    BOOL isIos6;
}

@end

@implementation STPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    isIpad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    isIos6 = ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0] == '6');
    
    if([CLLocationManager locationServicesEnabled]) {
        placemarksSearch = [[NSMutableDictionary alloc] init];

        mapSpanDelta = 0.035;
        
        pinCount = 1;
        
        isFollowingUser = YES;
        isGeoCodingLocations = YES;
        
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDistanceFilter:1.0];
        [locationManager setDelegate:self];
        
        geoCoder = [[CLGeocoder alloc] init];
        
        [self loadMainView];
        
        [self loadSearchAlert];
        
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
    
    [mainView setEnableToolbarFollow:isFollowingUser];
    [mainView setEnableToolbarGeoCode:isGeoCodingLocations];

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

-(void)loadSearchAlert
{
    searchAlert = [[UIAlertView alloc]
                   initWithTitle:@"Recherche de lieu"
                   message:@"Saisissez au moins un mot clé"
                   delegate:self
                   cancelButtonTitle:@"Annuler"
                   otherButtonTitles:@"Chercher", nil];
    [searchAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
}

-(void)loadMarkSearchAlertWithMessage:(NSString *) locationName
{
    [markSearchAlert release];
    
    markSearchAlert = [[UIAlertView alloc]
                       initWithTitle:@"Marquer ce lieu ?"
                       message:locationName
                       delegate:self
                       cancelButtonTitle:@"Non"
                       otherButtonTitles:@"Oui", nil];
    [markSearchAlert setAlertViewStyle:UIAlertViewStyleDefault];
}

-(void)loadResultsActionSheet
{
    
    [resultsActionSheet release];
    
    int placemarksCount = [placemarksSearch count];
    
    NSString * boxTitle;
    
    boxTitle = (placemarksCount == 0) ? @"Aucun résultat" : [NSString stringWithFormat:@"%d résultat(s)", placemarksCount];
    
    resultsActionSheet = [[UIActionSheet alloc]
                          initWithTitle: boxTitle
                          delegate:self
                          cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];

    [placemarksSearch enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [resultsActionSheet addButtonWithTitle:key];
    }];

    [resultsActionSheet setDestructiveButtonIndex:0];
    [resultsActionSheet addButtonWithTitle:@"Annuler"];
    [resultsActionSheet setCancelButtonIndex:placemarksCount];
    
    if(isIpad) {
        [resultsActionSheet showFromBarButtonItem:[mainView searchButtonFromToolbar] animated:YES];
    } else {
        [resultsActionSheet showFromToolbar: [mainView toolbar]];
    }

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


/* ---- actions ---- */

-(void)makePinWithLocation:(CLLocation *)location
{

    if(isGeoCodingLocations) {
        
        [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            if(error) {
                //default pin
                [mainView addPinToMap:[[STPPinMap alloc] initWithTitle:[NSString stringWithFormat:@"lieu %d", pinCount++]
                                                         andCoordinate:[location coordinate]]];
                return;
            }
            
            //no error
            //placemark pin
            [mainView addPinToMap:[[STPPinMap alloc] initWithPlacemark:[placemarks firstObject]]];
            return;
        }];
        
    } else {
        
        //default pin
        [mainView addPinToMap:[[STPPinMap alloc] initWithTitle:[NSString stringWithFormat:@"lieu %d", pinCount++]
                                    andCoordinate:[location coordinate]]];
        
    }
}

-(void)updateMapWithCoord:(CLLocationCoordinate2D)coordinate
{
    if(isFollowingUser) {
        MKCoordinateSpan span = {
            .latitudeDelta = mapSpanDelta,
            .longitudeDelta = mapSpanDelta
        };
        MKCoordinateRegion region = {coordinate, span};
        
        [mainView setMapRegion:region];
    }

}

/* ---- END actions ---- */


/* ---- STPMainViewActionDelegate ---- */

-(void)onLongPressOnMapWithLocation:(CLLocation *)touchLocation
{
    [self makePinWithLocation:touchLocation];
}

/* ---- END STPMainViewActionDelegate ---- */


/* ---- STPmyToolbarActionDelegate ---- */

-(void)onLocationMarkButtonClick:(id)sender
{
    [self makePinWithLocation:[mainView userMapLocation]];
}

-(void)onSearchButtonClick:(id)sender
{
    [searchAlert show];
}

-(void)onFollowButtonClick:(id)sender
{
    isFollowingUser = !isFollowingUser;
    [mainView setEnableToolbarFollow:isFollowingUser];
    if(isFollowingUser) {
        [self locationManager:locationManager didUpdateLocations:[NSArray arrayWithObject:[mainView userMapLocation]]];
    }
}

-(void)onDeleteButtonClick:(id)sender
{
    
}

-(void)onGeoCodeButtonClick:(id)sender
{
    isGeoCodingLocations = !isGeoCodingLocations;
    [mainView setEnableToolbarGeoCode:isGeoCodingLocations];
}

/* ---- END STPmyToolbarActionDelegate ---- */


/* ---- CoreLocationManager Delegate ---- */

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self updateMapWithCoord:[[locations lastObject] coordinate]];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView * errorAlert = [[UIAlertView alloc]
                                initWithTitle:@"Erreur"
                                message:[NSString stringWithFormat:@"Localisation impossible : %@", [error description]]
                                delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert autorelease];
    [errorAlert show];
}

/* ---- END CoreLocationManager Delegate ---- */


/* ---- MKMapView Delegate ---- */

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self updateMapWithCoord:[[userLocation location]coordinate]];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    MKPinAnnotationView * pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:@"ppm"];
    [pin setPinColor:MKPinAnnotationColorGreen];
    [pin setCanShowCallout:YES];
    [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
}

/* ---- END MKMapView Delegate ---- */


/* ---- UIAlertViewDelegate ---- */

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == searchAlert && buttonIndex == 1){
        //recherche
        [geoCoder geocodeAddressString:[[alertView textFieldAtIndex:0] text]
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if(error) {
                             return;
                         }
                         
                         //reset placemarksSearch Dictionary
                         [placemarksSearch removeAllObjects];
                         
                         [placemarks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             // !!! COPY to the Dictionary
                             [placemarksSearch setObject:[(CLPlacemark *)obj copy] forKey:[((CLPlacemark *)obj) formatAddress]];
                         }];
                         
                         [self loadResultsActionSheet];
                     }];
    }
    
    if(alertView == markSearchAlert && buttonIndex == 1) {
        //mark location (map center with geocode)
        BOOL memory = isGeoCodingLocations;
        isGeoCodingLocations = YES;
        [self makePinWithLocation:[[CLLocation alloc]
                                   initWithCoordinate:[mainView centerMapCoordinate]
                                   altitude:0
                                   horizontalAccuracy:0 verticalAccuracy:0
                                   timestamp:nil]];
        isGeoCodingLocations = memory;
    }
}

/* ---- END UIAlertViewDelegate ---- */


/* ---- UIActionSheetDelegate ---- */

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(actionSheet == resultsActionSheet && buttonIndex < [placemarksSearch count]) {
        
        NSString * buttonTitle = [[actionSheet buttonTitleAtIndex:buttonIndex] retain];
        
        CLPlacemark * selectedPM = [placemarksSearch objectForKey:buttonTitle];
        
        //dont follow user to display propeerly the map
        isFollowingUser = YES;
        [self updateMapWithCoord:[[selectedPM location] coordinate]];
        [self onFollowButtonClick:nil];
        
        //show "add pin" question alert
        [self loadMarkSearchAlertWithMessage:buttonTitle];
        [buttonTitle release];
        [markSearchAlert show];
    }
}

/* ---- END UIActionSheetDelegate ---- */

-(void)dealloc
{
    [locationManager release]; locationManager = nil;
    [geoCoder release]; geoCoder = nil;
    [searchAlert release]; searchAlert = nil;
    [markSearchAlert release]; markSearchAlert = nil;
    [resultsActionSheet release]; resultsActionSheet = nil;
    [placemarksSearch release]; placemarksSearch = nil;
    
    [super dealloc];
}

@end
