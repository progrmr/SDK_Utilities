//
//  CALayer+Additions.h
//  Coffee Radar
//
//  Created by Gary Morris on 6/19/14.
//  Copyright (c) 2014 Gary Morris. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (Additions)

- (void)gm_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset;

- (void)gm_setShadowOpacity:(CGFloat)opacity radius:(CGFloat)radius offset:(CGSize)offset color:(UIColor*)color;

@end
