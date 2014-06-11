//
//  UIBarButtonItem+STPCustomImage.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "UIBarButtonItem+STPCustomImage.h"
#import "UIImage+STPImageResize.h"

@implementation UIBarButtonItem (STPCustomImage)

-(id)initWithCustomImageName:(NSString *)imageName type:(NSString *)imageType style:(UIBarButtonItemStyle)style
{
    self = [self init];
    if(self){
        [self setImage:[UIImage imageForToolbarWithName:imageName andType:imageType]];
    }
    return self;
}

-(id)initWithCustomImageName:(NSString *)imageName type:(NSString *)imageType style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action {
    self = [self initWithCustomImageName:imageName type:imageType style:style];
    if(self){
        [self setTarget:target];
        [self setAction:action];
    }
    return self;
}

@end
