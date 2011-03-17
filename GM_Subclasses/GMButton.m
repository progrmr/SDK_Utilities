//
//  GMButton.m
//  NextSprinter
//
//  Created by Gary Morris on 3/12/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GMButton.h"


@implementation GMButton

#define kBevelInset (0.75f)   /* in pixels */

- (void)dealloc {
	[bevelLayer release];
	[colorLayer release];
	[glossLayer release];	
    [super dealloc];
}

//----------------------------------------------------------------------------
// NOTE: background color and title must be set in IB (Interface Builder)
//----------------------------------------------------------------------------
-(void)awakeFromNib {
	// Initialization code
	CGRect  bounds  = self.bounds;
	CGFloat cRadius = bounds.size.height * 0.20f;	// 20% height is good
	
	self.autoresizingMask    = UIViewAutoresizingFlexibleWidth;
	self.autoresizesSubviews = YES;
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius  = cRadius;	
	self.layer.needsDisplayOnBoundsChange = YES;

	// remove background color provided and save it in bgColors[]
	bgColors[stNormal] = [super.backgroundColor retain];  // retain, bypassing setter
	super.backgroundColor = nil;		// no longer needed
	
	//----------------------------------------
	// add title shadow to match bevel layer
	//----------------------------------------
	if (self.tag != 999) {	// kludge = tag 999 means no shadow
		[self setTitleShadowColor:[UIColor colorWithWhite:0.2f alpha:0.8f] 
						 forState:UIControlStateNormal];  // alpha<1 to pick up bg color
		self.titleLabel.shadowOffset = CGSizeMake(0, -kBevelInset);
		self.titleLabel.font = [UIFont boldSystemFontOfSize:12];
	}
	
	//---------------------------
	// add bevel layer
	//---------------------------
	bevelLayer = [[CAGradientLayer layer] retain];
	bevelLayer.colors = [NSArray arrayWithObjects: (id)
						 [UIColor colorWithWhite:0.2f alpha:1].CGColor, 
						 [UIColor colorWithWhite:0.4f alpha:1].CGColor, 
						 [UIColor colorWithWhite:0.5f alpha:1].CGColor, 
						 [UIColor colorWithWhite:0.9f alpha:1].CGColor, nil];
	bevelLayer.locations = [NSArray arrayWithObjects:
							[NSNumber numberWithFloat:0],
							[NSNumber numberWithFloat:cRadius/bounds.size.height],
							[NSNumber numberWithFloat:1-(cRadius/bounds.size.height)],
							[NSNumber numberWithFloat:1], nil];		
	bevelLayer.frame = bounds;
	bevelLayer.needsDisplayOnBoundsChange = YES;
	[self.layer addSublayer:bevelLayer];

	//---------------------------
	// add color layer
	//---------------------------
	colorLayer = [[CALayer layer] retain];
	colorLayer.backgroundColor = bgColors[stNormal] ? bgColors[stNormal].CGColor : nil;
	colorLayer.frame = CGRectInset(bounds, kBevelInset, kBevelInset);
	colorLayer.cornerRadius = cRadius;
	colorLayer.needsDisplayOnBoundsChange = YES;
	[self.layer addSublayer:colorLayer];

	//---------------------------
	// add gloss layer
	//---------------------------
	glossLayer = [[CAGradientLayer layer] retain];
	glossLayer.colors = [NSArray arrayWithObjects: (id)
						 [UIColor colorWithWhite:1 alpha:0.4f].CGColor, 
						 [UIColor colorWithWhite:1 alpha:0.0f].CGColor, nil];
	glossLayer.frame        = colorLayer.frame;
	glossLayer.cornerRadius = colorLayer.cornerRadius;
	glossLayer.needsDisplayOnBoundsChange = YES;
	[self.layer addSublayer:glossLayer];
	
	[self bringSubviewToFront:self.titleLabel];
}

//----------------------------------------------------------------------------
// stateFromUIControlState -- converts state bit flags into StateType enum
//----------------------------------------------------------------------------
StateType stateFromUIControlState(UIControlState aState) 
{
	StateType result = stNormal;
	
	if (aState & UIControlStateDisabled) {
		result = stDisabled;
	} else if (aState & UIControlStateSelected) {
		result = stSelected;
	} else if (aState & UIControlStateHighlighted) {
		result = stHighlighted;
	}
	
	return result;
}

//----------------------------------------------------------------------------
// updateColorLayerForCurrentState
//----------------------------------------------------------------------------
-(void)updateColorLayerForCurrentState
{
	// we may have updated the color that applies to the current state
	UIColor* curStateColor = [self colorForState:self.state];
	
	colorLayer.backgroundColor = curStateColor==nil ? nil : curStateColor.CGColor;
}

//----------------------------------------------------------------------------
// backgroundColorForState: -- returns one of the colors
//----------------------------------------------------------------------------
-(UIColor*)colorForState:(UIControlState)aState
{
	UIColor* color = bgColors[stateFromUIControlState(aState)];

	if (color==nil) {
		color = bgColors[stNormal];
	}
	
	return [[color retain] autorelease];
}

//----------------------------------------------------------------------------
// setBackgroundColor:forState:  -- sets the color for a states
//----------------------------------------------------------------------------
-(void)setColor:(UIColor *)newColor forState:(UIControlState)aState
{
	StateType curState = stateFromUIControlState(aState);
	
	[newColor retain];		// retain before release, in case it's the same obj
	[bgColors[curState] release];	
	bgColors[curState] = newColor;

	// we may have updated the color that applies to the current state
	[self updateColorLayerForCurrentState];
}

#if 0
//----------------------------------------------------------------------------
// Override setBackgroundColor and backgroundColor because the original 
// background color is covered up and replaced by the colorLayer.  
//----------------------------------------------------------------------------
-(void)setBackgroundColor:(UIColor *)newColor
{
	// set the color for the current state.
	[self setColor:newColor forState:self.state];
}

-(UIColor*)backgroundColor
{
	// return the color for the current state.
	return [self colorForState:self.state];
}
#endif

//----------------------------------------------------------------------------
// Override state setter methods so we can update the colorLayer
// when there is a state change.  
//----------------------------------------------------------------------------
-(void)setSelected:(BOOL)newSelected
{
	if (super.isSelected != newSelected) {
		[super setSelected:newSelected];
		NSLog(@"%d selected=%@", newSelected, [self titleForState:UIControlStateSelected]);
		[self updateColorLayerForCurrentState];
	}
}

-(void)setEnabled:(BOOL)newEnabled
{
	if (super.isEnabled != newEnabled) {
		[super setEnabled:newEnabled];
		NSLog(@"%d disabled=%@", newEnabled, [self titleForState:UIControlStateDisabled]);
		[self updateColorLayerForCurrentState];
	}
}

-(void)setHighlighted:(BOOL)newHighlighted
{
	if (super.isHighlighted != newHighlighted) {
		[super setHighlighted:newHighlighted];
		NSLog(@"%d highlighted=%@", newHighlighted, [self titleForState:UIControlStateHighlighted]);
		[self updateColorLayerForCurrentState];
	}
}


@end
