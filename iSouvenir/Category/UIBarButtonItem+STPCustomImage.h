//
//  UIBarButtonItem+STPCustomImage.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (STPCustomImage)

-(id)initWithCustomImageName:(NSString *)imageName type:(NSString *)imageType
                       style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;

-(id)initWithCustomImageName:(NSString *)imageName type:(NSString *)imageType
                       style:(UIBarButtonItemStyle)style;

@end
