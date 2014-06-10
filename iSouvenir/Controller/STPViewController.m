//
//  STPViewController.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "STPViewController.h"
#import "STPmainView.h"

@interface STPViewController () {
    STPMainView * mainView;
}

@end

@implementation STPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    mainView = [[STPMainView alloc] initForAutoLayout];
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
    
    [self willRotateToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                                  duration:[[UIApplication sharedApplication] statusBarOrientationAnimationDuration]];
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

@end
