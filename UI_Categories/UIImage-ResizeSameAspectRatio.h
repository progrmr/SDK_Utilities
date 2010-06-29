//
//  Tmp.h
//  ClockU
//
//  Created by Gary Morris on 5/24/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (UIImage_ResizeSameAspectRatio)

+(UIImage*)imageWithImage:(UIImage*)sourceImage 
				   Factor:(CGFloat)factor 
				  Quality:(CGInterpolationQuality)interpolationQuality;

@end
