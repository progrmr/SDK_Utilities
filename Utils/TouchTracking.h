//
//  TouchTracking.h
//  ClockSmith
//
//  Created by Gary Morris on 7/25/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TouchTracking : NSObject {

	CGPoint prevTouchPoint;
	BOOL    prevTouchValid;
	
}

//------------------------------------------------------------------------
// Returns coordinates of touch nearest to the previous touch,
// result indicates if the touch was valid or not.
//------------------------------------------------------------------------
-(BOOL) validTouch:(NSArray*)touches	// IN: array of UITouch objects
			inView:(UIView*)inView		// IN: event's view
		   atPoint:(CGPoint*)point;		// OUT: coordinates of touch

//------------------------------------------------------------------------
// touchesEnded is called to clear the TouchTracking previous point data
//------------------------------------------------------------------------
-(void) touchesEnded;		// clear touch memory

@end
