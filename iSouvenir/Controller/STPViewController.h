//
//  STPViewController.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "STPmainView.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface STPViewController : UIViewController <STPmyToolbarActionDelegate, STPMainViewActionDelegate,
    CLLocationManagerDelegate, MKMapViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate,
    ABPeoplePickerNavigationControllerDelegate>

@end
