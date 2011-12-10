//-----------------------------------------------------------------------------
//
//  GMButton.h
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

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum { stNormal, stSelected, stHighlighted, stDisabled, nStates } StateType;

@interface GMButton : UIButton {

	CAGradientLayer* bevelLayer;
	CAGradientLayer* glossLayer;
	CALayer* colorLayer;
	
	UIColor* bgColors[nStates];	// background colors for states
    
    UIActivityIndicatorView* spinnerView;   // optional
    id info;                                // optional button info
}

+(id)buttonWithFrame:(CGRect)newFrame;
-(id)initWithFrame:(CGRect)newFrame;

-(void)setColor:(UIColor *)newColor forState:(UIControlState)state;
-(UIColor*)colorForState:(UIControlState)state;

@property (nonatomic, assign) BOOL busy;    // status of activity indicator
@property (nonatomic, retain) id info;      // optional info to go with button

@end
