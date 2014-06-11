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
#import "UIImage+STPImageResize.h"

@interface STPViewController () {
    STPMainView * mainView;
    UIAlertView * searchAlert, * markSearchAlert, *trashAlert;
    UIActionSheet * resultsActionSheet, * addPinActionSheet;
    CLLocationManager * locationManager;
    CLGeocoder * geoCoder;
    ABPeoplePickerNavigationController * peoplePickerController;
    
    float mapSpanDelta;
    BOOL isFollowingUser;
    BOOL isGeoCodingLocations;
    int pinCount;
    NSMutableDictionary * placemarksSearch;
    STPPinMap * currentAnnotation;
    
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
        [self loadAddPinActionSheet];
        
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

/* ---- alerts ---- */
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

-(void) loadTrashAlertWithMessage:(NSString *) pinName
{
    [trashAlert release];
    
    trashAlert = [[UIAlertView alloc]
                  initWithTitle:@"Supprimer ?"
                  message:pinName
                  delegate:self
                  cancelButtonTitle:@"Annuler"
                  otherButtonTitles:@"Supprimer", nil];
    [trashAlert setAlertViewStyle:UIAlertViewStyleDefault];
}

/* ---- actionsheets ---- */

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

-(void)loadAddPinActionSheet
{
    addPinActionSheet = [[UIActionSheet alloc]
                         initWithTitle:@"Marquer un lieu"
                         delegate:self
                         cancelButtonTitle:@"Annuler"
                         destructiveButtonTitle:@"Position du terminal"
                         otherButtonTitles:@"Centre de la carte", @"Rechercher un lieu", nil];
}

/* ---- peoplePicker ---- */

-(void)loadPeoplePickerController
{
    if(!peoplePickerController) {
        peoplePickerController = [[ABPeoplePickerNavigationController alloc] init];
        [peoplePickerController setPeoplePickerDelegate:self];
        
        [peoplePickerController setDisplayedProperties:[NSArray arrayWithObjects:
                                                        [NSNumber numberWithInt:kABPersonFirstNameProperty],
                                                        [NSNumber numberWithInt:kABPersonLastNameProperty],
                                                        nil]];
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
    if(isIpad){
        [addPinActionSheet showFromBarButtonItem:[mainView locationMarkButtonFromToolbar] animated:YES];
    } else {
        [addPinActionSheet showFromToolbar:[mainView toolbar]];
    }
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
    NSArray * pins = [mainView selectedMapAnnotations];
    if([pins count]) {
        NSMutableString * pinFormatTitles = [[NSMutableString alloc]
                                             initWithString:[((id<MKAnnotation>)[pins firstObject]) title]];
        for (int i = 1 ; i < [pins count]; i++) {
            [pinFormatTitles appendFormat:@"/n%@", [((id<MKAnnotation>)[pins objectAtIndex:i]) title]];
        }
        [self loadTrashAlertWithMessage:pinFormatTitles];
        [trashAlert show];
    }
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
    
    UIView * rightCallout = [[UIView alloc] init];

    [rightCallout addSubview:[UIButton buttonForAutoLayoutWithType:UIButtonTypeContactAdd]];
    
    
    
    [rightCallout autorelease];
    
    
    
    [pin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeContactAdd]];
    
    /*
    UIImage* trashImage = [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"recycle43_red" ofType:@"png"]];
    UIButton* trashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [trashButton setFrame:CGRectMake(0, 0, 30, 30)];
    [trashButton setImage:trashImage forState:UIControlStateNormal];
    [pin setLeftCalloutAccessoryView:trashButton];
     */
    
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    if([[view annotation] isKindOfClass:[STPPinMap class]]) {
        
        [currentAnnotation release];
        currentAnnotation = [[view annotation] retain];
        
        if([(UIButton *)control buttonType] == UIButtonTypeContactAdd) {
            [self loadPeoplePickerController];
            [self presentViewController:peoplePickerController animated:YES completion:nil];
        }
        
    }
}

/* ---- END MKMapView Delegate ---- */


/* ---- UIAlertViewDelegate ---- */

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == searchAlert && buttonIndex == 1){
        //recherche + OK
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
    
    if(alertView == trashAlert && buttonIndex == 1) {
        //delete annotations + OK
        [mainView removeSelectedMapAnnotations];
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
    
    if(actionSheet == addPinActionSheet) {
        if(buttonIndex == 0) {
            //terminal position
            [self makePinWithLocation:[mainView userMapLocation]];
        }
        if(buttonIndex == 1) {
            //map center
            CLLocation * centerMap = [[CLLocation alloc]
                                      initWithCoordinate:[mainView centerMapCoordinate]
                                      altitude:0
                                      horizontalAccuracy:0 verticalAccuracy:0
                                      timestamp:nil];
            [self makePinWithLocation:[centerMap autorelease]];
        }
        if(buttonIndex == 2) {
            //search box
            [searchAlert show];
        }
    }
}

/* ---- END UIActionSheetDelegate ---- */


/* ---- ABPeoplePickerNavigationControllerDelegate ---- */

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    if(currentAnnotation) {
        NSString * firstname = ((NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty));
        NSString * lastname = ((NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty));
        [currentAnnotation setSubtitle:[NSString stringWithFormat:@"%@ %@", firstname, lastname]];
    }
    
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    
    return NO;
}

-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

/* ---- END ABPeoplePickerNavigationControllerDelegate ----*/


-(void)dealloc
{
    [locationManager release]; locationManager = nil;
    [geoCoder release]; geoCoder = nil;
    [searchAlert release]; searchAlert = nil;
    [markSearchAlert release]; markSearchAlert = nil;
    [trashAlert release]; trashAlert = nil;
    [resultsActionSheet release]; resultsActionSheet = nil;
    [placemarksSearch release]; placemarksSearch = nil;
    [addPinActionSheet release]; addPinActionSheet = nil;
    [peoplePickerController release]; peoplePickerController = nil;
    [currentAnnotation release]; currentAnnotation = nil;
    
    [super dealloc];
}

@end
