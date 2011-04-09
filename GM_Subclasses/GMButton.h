//
//  GMButton.h
//  NextSprinter
//
//  Created by Gary Morris on 3/12/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum { stNormal, stSelected, stHighlighted, stDisabled, nStates } StateType;

@interface GMButton : UIButton {

	CAGradientLayer* bevelLayer;
	CAGradientLayer* glossLayer;
	CALayer* colorLayer;
	
	UIColor* bgColors[nStates];	// background colors for states
    
    UIActivityIndicatorView* spinnerView;       // optional
}

+(id)buttonWithFrame:(CGRect)newFrame;
-(id)initWithFrame:(CGRect)newFrame;

-(void)setColor:(UIColor *)newColor forState:(UIControlState)state;
-(UIColor*)colorForState:(UIControlState)state;

@property (assign, nonatomic) BOOL busy;    // status of activity indicator

@end
