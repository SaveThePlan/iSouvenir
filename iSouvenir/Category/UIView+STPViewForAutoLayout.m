//
//  UIView+STPViewForAutoLayout.m
//  Photographer
//
//  Created by Nanook on 09/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "UIView+STPViewForAutoLayout.h"

@implementation UIView (STPViewForAutoLayout)

-(id)initForAutoLayout {
    self = [self init];
    if(self) {
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return self;
}

@end


@implementation UIButton (STPButtonForAutoLayout)

+(id)buttonForAutoLayoutWithType:(UIButtonType)buttonType {
    UIButton * b = [UIButton buttonWithType:buttonType];
    [b setTranslatesAutoresizingMaskIntoConstraints:NO];
    return b;
}

@end