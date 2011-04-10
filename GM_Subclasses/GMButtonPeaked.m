//
//  GMButtonPeaked.m
//  ThoughtLog
//
//  Created by Gary Morris on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GMButtonPeaked.h"


@implementation GMButtonPeaked

-(void)addRectWithPeaks:(CGContextRef)ctx 
                   Rect:(CGRect)r 
           MinXPeakSize:(CGFloat)minXPeakSize	  // negative for an inset peak
           MaxXPeakSize:(CGFloat)maxXPeakSize	  // negative for an inset peak
{
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, CGRectGetMinX(r)+minXPeakSize, CGRectGetMinY(r));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(r)-maxXPeakSize, CGRectGetMinY(r));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(r), CGRectGetMidY(r));
    CGContextAddLineToPoint(ctx, CGRectGetMaxX(r)-maxXPeakSize, CGRectGetMaxY(r));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(r)+minXPeakSize, CGRectGetMaxY(r));
    CGContextAddLineToPoint(ctx, CGRectGetMinX(r), CGRectGetMidY(r));
    CGContextClosePath(ctx);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    [self addRectWithPeaks:ctx Rect:rect MinXPeakSize:20 MaxXPeakSize:0];
    
    CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
    CGContextFillPath(ctx);
}

@end
