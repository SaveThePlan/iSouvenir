//
//  UIImage+STPImageForToolbar.h
//  iSouvenir
//
//  Created by Nanook on 10/06/2014.
//  Copyright (c) 2014 SaveThePlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (STPImageResize)

+(UIImage *) imageForToolbarWithName:(NSString *)fileName andType:(NSString *)fileType;

+(UIImage *) imageResizeWithName:(NSString *)fileName andType:(NSString *)fileType andHeight:(float)height;

@end
