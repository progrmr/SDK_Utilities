//
//  Animations.m
//  ClockSmith
//
//  Created by Gary Morris on 7/6/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "Animations.h"


@implementation EZAnimations

@synthesize context;

-(id)copyWithZone:(NSZone *)zone
{
	EZAnimations* newCopy = [super copyWithZone:zone];
	newCopy.context = self.context;				// copy context ivar
	return newCopy;
}

//--------------------------------------------------------
// Creates and returns a EZAnimations instance 
// that will give a popup bounce ending at 100% size.
//--------------------------------------------------------
+(id)ezPopup:(CALayer*)theLayer 	// animation will be added to layer (if non-nil)
{
	//---------------------------------------------------
	// makes the viewItem shrink and bounce and settle at proper size
	//---------------------------------------------------
	EZAnimations *animation = [EZAnimations animationWithKeyPath:@"transform"];
	
    CATransform3D scale1 = CATransform3DMakeScale(0.5, 0.5, 1);		// half size
    CATransform3D scale2 = CATransform3DMakeScale(1.2, 1.2, 1);		// 120% size
    CATransform3D scale3 = CATransform3DMakeScale(0.9, 0.9, 1);		//  90% size
    CATransform3D scale4 = CATransform3DMakeScale(1.0, 1.0, 1);		// normal size
	
    animation.values = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							[NSValue valueWithCATransform3D:scale4],
							nil];
	
    animation.keyTimes = [NSArray arrayWithObjects: 
						   [NSNumber numberWithFloat:0.0f],
						   [NSNumber numberWithFloat:0.5f],
						   [NSNumber numberWithFloat:0.9f],
						   [NSNumber numberWithFloat:1.0f],
						   nil];    
	
    animation.fillMode = kCAFillModeForwards;
    ///animation.removedOnCompletion = NO;
    animation.duration = 0.2;
	///animation.delegate = TBD;
	
	if (theLayer) {
		[theLayer addAnimation:animation forKey:@"ezPopup"];
	}
	return animation;
}

//--------------------------------------------------------
// Creates and returns a EZAnimations instance 
// that will zoom the view from startFactor to endFactor
//--------------------------------------------------------
+(id)ezZoom:(CALayer*)theLayer		// animation will be added to layer (if non-nil) 
	  start:(float)startFactor		// must be 0.0 to 1.0
		end:(float)endFactor		// must be 0.0 to 1.0
  inSeconds:(NSTimeInterval)duration 
   Delegate:(id)delegate
	Context:(id)context
{
	EZAnimations *animation = [EZAnimations animationWithKeyPath:@"transform"];
	
	if (startFactor <= 0.001) startFactor = 0.001;
	if (startFactor >  1.0)   startFactor = 1.0;
	if (endFactor   <= 0.001) endFactor   = 0.001;
	if (endFactor   >  1.0)   endFactor   = 1.0;
	
    CATransform3D scale1 = CATransform3DMakeScale(startFactor, startFactor, 1);
	CATransform3D scale2 = CATransform3DMakeScale(0.5, 0.5, 1);
	CATransform3D scale3 = CATransform3DMakeScale(endFactor, endFactor, 1);
	
    animation.values = [NSArray arrayWithObjects:
							[NSValue valueWithCATransform3D:scale1],
							[NSValue valueWithCATransform3D:scale2],
							[NSValue valueWithCATransform3D:scale3],
							nil];
	
    animation.keyTimes = [NSArray arrayWithObjects:
						   [NSNumber numberWithFloat:0.0],
						   [NSNumber numberWithFloat:0.5],
						   [NSNumber numberWithFloat:1.0],
						   nil];    
	
    animation.fillMode        = kCAFillModeForwards;
	animation.calculationMode = kCAAnimationLinear;
    animation.duration        = duration;
	animation.delegate        = delegate;
	animation.context         = context;
	
	if (theLayer) {
		[theLayer addAnimation:animation forKey:@"ezZoom"];
	}
	return animation;
}

+(void)blink:(UIView*)theView 
   numBlinks:(int)numBlinks					// number of blinks
   inSeconds:(NSTimeInterval)duration		// duration of each blink
{
	theView.alpha = 1;
	[UIView beginAnimations:@"blink" context:theView];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:numBlinks]; 
	[UIView setAnimationDuration:duration];
	theView.alpha = 0;
	[UIView commitAnimations];
}

@end
