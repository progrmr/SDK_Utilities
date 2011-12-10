//-----------------------------------------------------------------------------
//
//  GMButton.m
//
// Created by Gary Morris on 3/12/11.
//
// Copyright 2011 Gary A. Morris. http://mggm.net
//
// This file is part of SDK_Utilities.repo
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
//-----------------------------------------------------------------------------

#import "GMButton.h"
#import "Utilities.h"
#import "UtilitiesUI.h"

@implementation GMButton

@synthesize info;

#define kBevelInset (0.75f)   /* in pixels */
#define kSpinnerInset (2)     /* in pixels */
#define kFontSize (14)

- (void)dealloc {
	[bevelLayer release];
	[colorLayer release];
	[glossLayer release];
	[spinnerView release];
    [info        release];
    
    [super dealloc];
}

-(id)initWithFrame:(CGRect)newFrame
{
    GMButton* button = [super initWithFrame:newFrame];
    
    if ((self = (id)button)) {
        // initialize
        button.frame = newFrame;
        [self awakeFromNib];
    }
    return self;

}

+(id)buttonWithFrame:(CGRect)newFrame
{
    GMButton* button = [super buttonWithType:UIButtonTypeCustom];
    
    if ((self = (id)button)) {
        // initialize
        button.frame = newFrame;
        [self awakeFromNib];
    }
    return self;
}

//----------------------------------------------------------------------------
// NOTE: background color and title must be set in IB (Interface Builder)
//----------------------------------------------------------------------------
-(void)awakeFromNib {
    [super awakeFromNib];
    
	// Initialization code
	CGRect  bounds  = self.bounds;
	CGFloat cRadius = bounds.size.height * 0.20f;	// 20% height is good
	
	self.autoresizesSubviews = YES;
	self.layer.masksToBounds = YES;
	self.layer.cornerRadius  = cRadius;	
	self.layer.needsDisplayOnBoundsChange = YES;

	// remove background color provided and save it in bgColors[]
    // (but don't overwrite bgColors if backgroundColor is not set)
    if (super.backgroundColor) {
        bgColors[stNormal] = [super.backgroundColor retain];  // retain, bypassing setter
    }
	super.backgroundColor = nil;		// no longer needed
	
	//----------------------------------------
	// add title shadow to match bevel layer
	//----------------------------------------
	if (self.tag != 999) {	// kludge = tag 999 means no shadow
		[self setTitleShadowColor:[UIColor colorWithWhite:0.2f alpha:0.8f] 
						 forState:UIControlStateNormal];  // alpha<1 to pick up bg color
		self.titleLabel.shadowOffset = CGSizeMake(0, -kBevelInset);
		self.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSize];
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
    
    CGColorRef colorRef = bgColors[stNormal] ? bgColors[stNormal].CGColor : nil;
	colorLayer.backgroundColor = colorRef;
    
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
	
    [self bringSubviewToFront:self.imageView];
	[self bringSubviewToFront:self.titleLabel];
    
    ///dumpView(self, @"");
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

// override backgroundColor, use colorForState: instead
-(UIColor*)backgroundColor
{
    return [self colorForState:UIControlStateNormal];
}

//----------------------------------------------------------------------------
// setColor:forState:  -- sets the color for a states
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

// override setBackgroundColor:, use setColor:forState: instead
-(void)setBackgroundColor:(UIColor *)newColor
{
    [self setColor:newColor forState:UIControlStateNormal];
}

//----------------------------------------------------------------------------
// Override state setter methods so we can update the colorLayer
// when there is a state change.  
//----------------------------------------------------------------------------
-(void)setSelected:(BOOL)newSelected
{
	if (super.isSelected != newSelected) {
		[super setSelected:newSelected];
		DLog(@"%d selected=%@", newSelected, [self titleForState:UIControlStateSelected]);
		[self updateColorLayerForCurrentState];
	}
}

-(void)setEnabled:(BOOL)newEnabled
{
	if (super.isEnabled != newEnabled) {
		[super setEnabled:newEnabled];
		DLog(@"%d disabled=%@", newEnabled, [self titleForState:UIControlStateDisabled]);
		[self updateColorLayerForCurrentState];
	}
}

-(void)setHighlighted:(BOOL)newHighlighted
{
	if (super.isHighlighted != newHighlighted) {
		[super setHighlighted:newHighlighted];
		///DLog(@"%d highlighted=%@", newHighlighted, [self titleForState:UIControlStateHighlighted]);
		[self updateColorLayerForCurrentState];
	}
}

//----------------------------------------------------------------------------
// handle the spinner view animation  
//----------------------------------------------------------------------------
-(UIActivityIndicatorView*)spinnerView 
{
    if (spinnerView==nil) {
        // modify bounds to make spinnerview square and centered
        CGRect bounds  = self.bounds;
        bounds.size.height -= kSpinnerInset;
        bounds.size.width  = bounds.size.height;    // make it square
        bounds.origin.x = (self.bounds.size.width-bounds.size.width) * 0.5f;
        
        spinnerView = [[UIActivityIndicatorView alloc] initWithFrame:bounds];
        spinnerView.hidden = YES;       // initial state

        [self addSubview:spinnerView];  // add to button
    }
    return [[spinnerView retain] autorelease];
}

-(BOOL)busy {
    // don't use getter for spinnerView to avoid allocating the view
    // when we don't really need it
    return (spinnerView != nil) && (spinnerView.isHidden == NO);
}

-(void)setBusy:(BOOL)newBusy       // starts/stops activity spinner animation
{
    if (newBusy) {
        // enable spinner animation
        if (self.spinnerView.isHidden) {
            spinnerView.hidden = NO;
            [self setNeedsLayout];      // reposition spinner
            [spinnerView startAnimating];
        }
    } else {
        // disable spinner animation if it is already running
        // don't alloc it unless necessary
        if (self.busy) {
            [spinnerView stopAnimating];
            spinnerView.hidden = YES;
        }
    }
}

@end
