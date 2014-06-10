//
//  STPMainView.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPMainView.h"

@interface STPMainView() {
    UIButton * addPinButton, * addContactButton;
}

@end

@implementation STPMainView

- (id)init
{
    self = [super init];
    if (self) {
        
        [self loadInterfaceElements];
        [self loadInterfaceConstraints];
        
    }
    return self;
}

-(void) loadInterfaceElements
{
    addPinButton = [UIButton buttonForAutoLayoutWithType:UIButtonTypeRoundedRect];
    [addPinButton setTitle:@"Nouvelle épingle" forState:UIControlStateNormal];
    [self addSubview:addPinButton];
    
    addContactButton = [UIButton buttonForAutoLayoutWithType:UIButtonTypeRoundedRect];
    [addContactButton setTitle:@"Ajout contact" forState:UIControlStateNormal];
    [self addSubview:addContactButton];
}

-(void) loadInterfaceConstraints
{
    NSDictionary * allViews = NSDictionaryOfVariableBindings(addPinButton, addContactButton);
    
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-[addPinButton]-[addContactButton(==addPinButton)]-|"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-[addPinButton]"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-[addContactButton]"
                          options:NSLayoutFormatDirectionLeftToRight
                          metrics:nil views:allViews]];
}

@end
