//
//  UIView+Parallax.h
//  Coffee Radar
//
//  Created by Gary Morris on 11/30/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Parallax)

// gmParallax sets the maximum displacement of a uiview due to parallax effects
// this acts like its height above other views at 0 parallax.  use 5 for mild
// parallax, 10 is typical, 15-20 for large parallax effects.  Default: 0
@property (nonatomic, assign) CGFloat gmParallax;

// gmParallaxMotions is the UIMotionEffectGroup created when a non-zero value
// is set for the gmParallax property
@property (nonatomic, readonly) UIMotionEffectGroup* gmParallaxMotions;

@end
