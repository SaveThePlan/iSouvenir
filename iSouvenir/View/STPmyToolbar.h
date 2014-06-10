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

-(void)onLocationMarkClick:(id)sender;

@end

@interface STPmyToolbar : UIToolbar

@property (retain) id<STPmyToolbarActionDelegate> actionDelegate;

@end
