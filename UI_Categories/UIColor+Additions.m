//
//  UIColor+Additions.m
//  Coffee Radar
//
//  Created by Gary Morris on 11/30/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor*)colorWithRGB:(uint32_t)rgbValue
{
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0f
                           green:((rgbValue & 0x00FF00) >>  8)/255.0f \
                            blue:((rgbValue & 0x0000FF) >>  0)/255.0f \
                           alpha:1.0f];
}

+ (UIColor*)colorWithRGBA:(uint32_t)rgbaValue
{
    return [UIColor colorWithRed:((rgbaValue & 0xFF000000) >> 24)/255.0f
                           green:((rgbaValue & 0x00FF0000) >> 16)/255.0f \
                            blue:((rgbaValue & 0x0000FF00) >>  8)/255.0f \
                           alpha:((rgbaValue & 0x000000FF) >>  0)/255.0f];
}

@end
