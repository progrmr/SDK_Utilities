//
//  CALayer+Additions.m
//  Coffee Radar
//
//  Created by Gary Morris on 6/19/14.
//  Copyright (c) 2014 Gary Morris. All rights reserved.
//

#import "CALayer+Additions.h"

@implementation CALayer (Additions)

- (void)gm_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset
{
    self.shadowOpacity  = opacity;
    self.shadowRadius   = radius;
    self.shadowOffset   = offset;
}

- (void)gm_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset color:(UIColor*)color
{
    self.shadowOpacity  = opacity;
    self.shadowRadius   = radius;
    self.shadowOffset   = offset;
    self.shadowColor    = color.CGColor;
}

@end
