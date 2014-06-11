//
//  STPmyToolbar.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+STPViewForAutoLayout.h"

@protocol STPmyToolbarActionDelegate <NSObject>

-(void)onLocationMarkButtonClick:(id)sender;
-(void)onFollowButtonClick:(id)sender;
-(void)onSearchButtonClick:(id)sender;
-(void)onDeleteButtonClick:(id)sender;
-(void)onGeoCodeButtonClick:(id)sender;
-(void)onBookmarksButtonClick:(id)sender;

@end

@interface STPmyToolbar : UIToolbar

@property (retain) id<STPmyToolbarActionDelegate> actionDelegate;

-(void)setEnableFollow:(BOOL)enable;
-(void)setEnableGeoCode:(BOOL)enable;

-(UIBarButtonItem *)searchButtonItem;
-(UIBarButtonItem *)locationMarkButtonItem;
-(UIBarButtonItem *)bookmarksButtonItem;

@end
