//
//  UIImage+STPImageForToolbar.m
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import "UIImage+STPImageResize.h"

@implementation UIImage (STPImageResize)

+(UIImage *) imageForToolbarWithName:(NSString *)fileName andType:(NSString *)fileType
{
    return [self imageResizeWithName:fileName andType:fileType andHeight:24.0];
}

+(UIImage *) imageResizeWithName:(NSString *)fileName andType:(NSString *)fileType andHeight:(float)height
{
    UIImage * tmpImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle]
                                                            pathForResource:fileName ofType:fileType]] retain];
    UIImage * returnImage = [[UIImage imageWithCGImage:[tmpImage CGImage]
                                                 scale:[tmpImage scale] * [tmpImage size].height / height
                                           orientation:[tmpImage imageOrientation]] retain];
    [tmpImage release];
    return [returnImage autorelease];
}

@end
