//
//  GMButtonPeaked.m
//  ThoughtLog
//
//  Created by Gary Morris on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this file. If not, see <http://www.gnu.org/licenses/>.
//

#import "GMButtonPeaked.h"


@implementation GMButtonPeaked

@synthesize peakHeight;

-(void)awakeFromNib
{
    peakHeight = 0;
    [super awakeFromNib];
}

-(id)initWithFrame:(CGRect)newFrame
{
    GMButtonPeaked* button = [super initWithFrame:newFrame];
    
    if ((self = (id)button)) {
        // initialize
        peakHeight = 0;
    }
    return self;
    
}

+(id)buttonWithFrame:(CGRect)newFrame
{
    GMButtonPeaked* button = [super buttonWithType:UIButtonTypeCustom];
    
    if ((self = (id)button)) {
        // initialize
        button.frame = newFrame;
        button.peakHeight = 0;
    }
    return self;
}

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

    [self addRectWithPeaks:ctx Rect:rect MinXPeakSize:peakHeight MaxXPeakSize:0];
    
    CGContextSetRGBFillColor(ctx, 1, 1, 0, 1);
    CGContextFillPath(ctx);
}

@end
