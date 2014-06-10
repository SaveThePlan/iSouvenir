//
//  UIView+STPViewForAutoLayout.h
//  Photographer
//
//  Created by Nanook on 09/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (STPViewForAutoLayout)

-(id) initForAutoLayout;

@end

@interface UIButton (STPButtonForAutoLayout)

+(id) buttonForAutoLayoutWithType:(UIButtonType)buttonType;

@end
