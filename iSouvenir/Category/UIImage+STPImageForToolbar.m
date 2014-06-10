//
//  UIImage+STPImageForToolbar.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "UIImage+STPImageForToolbar.h"

@implementation UIImage (STPImageForToolbar)

+(UIImage *) imageForToolbarWithName:(NSString *)fileName andType:(NSString *)fileType
{
    UIImage * tmpImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:fileName ofType:fileType]] retain];
    UIImage * returnImage = [[UIImage imageWithCGImage:[tmpImage CGImage]
                                                 scale:[tmpImage scale] * [tmpImage size].height / 24.0
                                           orientation:[tmpImage imageOrientation]] retain];
    [tmpImage release];
    return [returnImage autorelease];
}

@end
