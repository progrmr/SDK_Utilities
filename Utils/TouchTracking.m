//
//  TouchTracking.m
//  ClockSmith
//
//  Created by Gary Morris on 7/25/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "TouchTracking.h"
#import "UtilitiesUI.h"

@implementation TouchTracking

enum { MAX_DISTANCE_MOVED = 30 };   // if the touch moved more than this amount in one step, then it probably isn't the same touch

//------------------------------------------------------------------------
// Returns coordinates of touch nearest to the reference point
// and distance between those points
//------------------------------------------------------------------------
CGPoint touchNearestPoint(CGPoint  refPoint,         // IN: reference touch point
						  NSArray* touches,          // IN: set of touches
						  UIView*  inView,           // IN: touches in view
						  CGFloat* nearestDistance)  // OUT: distance to nearest
{
	CGPoint nearestTouch = refPoint;
	*nearestDistance = 1e9;
	
	for (UITouch* aTouch in touches) {
		CGPoint aPoint = [aTouch locationInView:inView];
		CGFloat distance = distanceBetweenPoints(refPoint, aPoint);
		if (distance < *nearestDistance) {
			*nearestDistance = distance;
			nearestTouch     = aPoint;
		}
	}

	return nearestTouch;
}

//------------------------------------------------------------------------
// Returns coordinates of touch nearest to the previous touch,
// result indicates if the touch was valid or not.
//------------------------------------------------------------------------
-(BOOL) validTouch:(NSArray*)touches	// IN: array of UITouch objects
			inView:(UIView*)inView		// IN: event's view
		   atPoint:(CGPoint*)point		// OUT: coordinates of touch
{
	CGFloat  nearestDistance = 1e9;
	
	if (prevTouchValid) {
		// selects the touch closest to the previous touch
		prevTouchPoint = touchNearestPoint(prevTouchPoint, touches, inView, &nearestDistance);		
		// if the touch jumped too far, then this is not the same touch, this is a new touch
		prevTouchValid = nearestDistance < MAX_DISTANCE_MOVED;

	} else {
		// no prev touch, take first touch in set
		prevTouchPoint = [[touches objectAtIndex:0] locationInView:inView];
		prevTouchValid = YES;
	}
	
	if (prevTouchValid) {
		*point = prevTouchPoint;
	}
	return prevTouchValid;
}

//------------------------------------------------------------------------
// touchesEnded is called to clear the TouchTracking previous point data
//------------------------------------------------------------------------
-(void) touchesEnded
{
	prevTouchValid = NO;
}

@end
