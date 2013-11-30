//
//  UIView+Parallax.m
//  Coffee Radar
//
//  Created by Gary Morris on 11/30/13.
//  Copyright (c) 2013 Gary Morris. All rights reserved.
//  Derived from http://stackoverflow.com/a/19067717/1693173
//

#import "UIView+Parallax.h"
#import "objc/runtime.h"

static char const * const GMMotionEffectGroupKey = "GMMotionEffectGroupKey";
static char const * const GMMotionEffectValueKey = "GMMotionEffectValueKey";

@implementation UIView (Parallax)

@dynamic gmParallax;
@dynamic gmParallaxMotions;

- (UIMotionEffectGroup*)newGMParallaxMotionEffects:(CGFloat)maxOffset
{
    // Set vertical effect
    UIInterpolatingMotionEffect* yMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yMotion.minimumRelativeValue = @(-maxOffset);
    yMotion.maximumRelativeValue = @(maxOffset);

    // Set horizontal effect
    UIInterpolatingMotionEffect* xMotion = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xMotion.minimumRelativeValue = @(-maxOffset);
    xMotion.maximumRelativeValue = @(maxOffset);

    // Create group to combine both
    UIMotionEffectGroup* group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xMotion, yMotion];

    return group;
}

// gmParallax sets the maximum displacement of a uiview due to parallax effects
// this acts like its height above other views at 0 parallax.  use 5 for mild
// parallax, 10 is typical, 15-20 for large parallax effects.  Default: 0
- (void)setGmParallax:(CGFloat)newParallax {
    if (fabsf(newParallax) < 0.25f) {
        // remove parallax motions group from view (if any)
        UIMotionEffectGroup* parallaxMotions = [self gmParallaxMotions];
        if (parallaxMotions) {
            // remove parallax motions from the view
            [self removeMotionEffect:parallaxMotions];

            // remove parallax motions from associative reference
            self.gmParallaxMotions = nil;

            // remove parallax value from associative reference
            objc_setAssociatedObject(self, GMMotionEffectValueKey, nil, OBJC_ASSOCIATION_ASSIGN);
        }

    } else {
        // create parallax motion effects group
        UIMotionEffectGroup* parallaxMotions = [self newGMParallaxMotionEffects:newParallax];

        // add parallax motions to view
        [self addMotionEffect:parallaxMotions];

        // save parallax motions as associative reference
        self.gmParallaxMotions = parallaxMotions;

        // save parallax value as associative reference
        objc_setAssociatedObject(self, GMMotionEffectValueKey, @(newParallax), OBJC_ASSOCIATION_ASSIGN);
    }
}

- (CGFloat)gmParallax {
    NSNumber* parallaxValue = objc_getAssociatedObject(self, GMMotionEffectValueKey);

    return [parallaxValue floatValue];    // returns 0 if no parallax set
}

- (UIMotionEffectGroup*)gmParallaxMotions
{
    return objc_getAssociatedObject(self, GMMotionEffectGroupKey);
}

- (void)setGmParallaxMotions:(UIMotionEffectGroup *)gmParallaxMotions
{
    objc_setAssociatedObject(self, GMMotionEffectGroupKey, gmParallaxMotions, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
