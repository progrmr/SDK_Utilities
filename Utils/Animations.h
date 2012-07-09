//
//  Animations.h
//  ClockSmith
//
//  Created by Gary Morris on 7/6/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface EZAnimations : CAKeyframeAnimation {
	id context;	
}

//--------------------------------------------------------
// Creates and returns a EZAnimations instance 
// that will give a popup bounce ending at 100% size.
//--------------------------------------------------------
+(id)ezPopup:(CALayer*)theLayer;	// animation will be added to layer (if non-nil)

//--------------------------------------------------------
// Creates and returns a EZAnimations instance 
// that will zoom the view from startFactor to endFactor
//--------------------------------------------------------
+(id)ezZoom:(CALayer*)theLayer		// animation will be added to layer (if non-nil) 
	  start:(float)startFactor		// must be 0.0 to 1.0
		end:(float)endFactor		// must be 0.0 to 1.0
  inSeconds:(NSTimeInterval)duration
   Delegate:(id)delegate
	Context:(id)context;

@property (assign, nonatomic) id context;	// passed to delegate

@end
