//
//  GMLabel.m
//  NextSprinter
//
//  Created by Gary Morris on 7/14/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
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

#import "GMLabel.h"


@implementation GMLabel

#define kFontSize (14)
#define kBevelInset (0.75f)   /* in pixels */

@synthesize glossLayer;


- (void)dealloc {
	[glossLayer  release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)newFrame
{
    GMLabel* label = [super initWithFrame:newFrame];
    
    if ((self = (id)label)) {
        // initialize
        label.frame = newFrame;
        label.textAlignment = NSTextAlignmentCenter;
        
        [self awakeFromNib];
    }
    return self;
    
}

+(id)labelWithFrame:(CGRect)newFrame
{
    return [[[self alloc] initWithFrame:newFrame] autorelease];
}

//----------------------------------------------------------------------------
// NOTE: background color and title must be set in IB (Interface Builder)
//----------------------------------------------------------------------------
-(void)awakeFromNib {
	// Initialization code
	CGRect  bounds  = self.bounds;
	CGFloat cRadius = bounds.size.height * 0.20f;	// 20% height is good
	
	self.autoresizesSubviews = YES;
    self.minimumScaleFactor  = 0.60f;
    self.adjustsFontSizeToFitWidth = YES;
    
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius  = cRadius;	
    self.layer.borderWidth   = 2;
	self.layer.needsDisplayOnBoundsChange = YES;
    
	//----------------------------------------
	// add title shadow to match bevel layer
	//----------------------------------------
	if (self.tag != 999) {	// kludge = tag 999 means no shadow
		self.shadowColor  = [UIColor colorWithWhite:0.2f alpha:0.8f];  // alpha<1 to pick up bg color
		self.shadowOffset = CGSizeMake(0, -kBevelInset);
		self.font = [UIFont boldSystemFontOfSize:kFontSize];
	}
	
	//---------------------------
	// add gloss layer
	//---------------------------
	glossLayer = [[CAGradientLayer layer] retain];
	glossLayer.colors = [NSArray arrayWithObjects: (id)
						 [UIColor colorWithWhite:1 alpha:0.5f].CGColor, 
						 [UIColor colorWithWhite:1 alpha:0.0f].CGColor, nil];
	glossLayer.frame        = bounds;
	glossLayer.cornerRadius = cRadius;
	glossLayer.needsDisplayOnBoundsChange = YES;
	[self.layer insertSublayer:glossLayer atIndex:0];
	
}

-(void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    self.layer.borderColor = textColor.CGColor;
}

@end
