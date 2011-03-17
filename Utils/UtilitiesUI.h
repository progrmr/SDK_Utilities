//
//  UtilitiesUI.h
//  Clock
//
//  Created by Gary Morris on 3/12/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UtilitiesUI {
	
}

//-----------------------------------------------------------------------------
// addConvexHighlightToLayer - creates a new layer and adds it to the given layer
//		this highlight brightens the top half, darkens the bottom half to
//      simulate a raised (convex) surface with lighting from above
//-----------------------------------------------------------------------------
CAGradientLayer* addConvexHighlightToLayer(CALayer* layer);

//-----------------------------------------------------------------------------
// addConcaveHighlightToLayer - creates a new layer and adds it to the given layer
//		this highlight brightens the bottom half, darkens the top half to
//      simulate a detent (concave) surface with lighting from above
//-----------------------------------------------------------------------------
CAGradientLayer* addConcaveHighlightToLayer(CALayer* layer);

//-----------------------------------------------------------------------------
// BOOL isPad()
//-----------------------------------------------------------------------------
BOOL isPad();

//-----------------------------------------------------------------------------
// BOOL isRetina();
//-----------------------------------------------------------------------------
BOOL isRetina();		// screen has a scale factor of > 1.5

//-----------------------------------------------------------------------------
// addPadSuffixOnPad
//
// Input:   baseNibName
// Returns: baseNibName      (on iPhone) OR
//          baseNibName~ipad (on iPad)
// (doesn't check to see if the nib exists, just returns the name)
//-----------------------------------------------------------------------------
NSString* addPadSuffixOnPad(NSString* baseNibName);

//-----------------------------------------------------------------------------
// stripPadSuffixOnPhone
//
// Input:   baseNibName~ipad
// Returns: baseNibName      (on iPhone) OR
//          baseNibName~ipad (on iPad)
//
// Note: if the input name does not have the ~ipad suffix, input is returned unchanged
// (doesn't check to see if the nib exists, just returns the name)
//-----------------------------------------------------------------------------
NSString* stripPadSuffixOnPhone(NSString* padNibName);

//-----------------------------------------------------------------------------
// isPortrait -- current orientation
//-----------------------------------------------------------------------------
BOOL isPortrait();
BOOL isPortraitOr(UIDeviceOrientation orientation);

//-----------------------------------------------------------------------------
// NSStringFromOrientation
//-----------------------------------------------------------------------------
NSString* NSStringFromOrientation(UIDeviceOrientation orientation);

//-----------------------------------------------------------------------------
// computeNewOrigin
// Compute a new origin for an view of a given size in a target frame size,
// positioned with the center of the item relative to the top and 
// relative to the left of the target frame
//-----------------------------------------------------------------------------
CGPoint computeNewOrigin(CGSize  targetFrameSize, 
						 CGSize  itemFrameSize, 
						 CGFloat relativeToLeft,	// range 0.0 - 1.0
						 CGFloat relativeToTop); 	// range 0.0 - 1.0

//-----------------------------------------------------------------------------
// computeNewFrame
// Compute a new frame for an view of a given item size in a target frame size,
// positioned with the center of the item relative to the top and 
// relative to the left of the target frame
// Note: itemFrame size returned unchanged
//-----------------------------------------------------------------------------
CGRect computeNewFrame(CGSize  targetFrameSize, 
					   CGRect  itemFrame, 
					   CGFloat relativeToLeft,	// range 0.0 - 1.0
					   CGFloat relativeToTop); 	// range 0.0 - 1.0

//-----------------------------------------------------------------------------
// distanceBetweenPoints
//-----------------------------------------------------------------------------
CGFloat distanceBetweenPoints(CGPoint pt1, CGPoint pt2);

//-----------------------------------------------------------------------------
// Long to UIColor conversions
//-----------------------------------------------------------------------------
uint32_t LongFromUIColor(UIColor* color);
UIColor* UIColorFromLong(uint32_t longValue);
NSString* NSStringFromUIColor(UIColor* color);

//-----------------------------------------------------------------------------
// drawCheckerPatter - draws black checks of the specified size in the 
//                     bounds of the rectangle
//-----------------------------------------------------------------------------
void drawCheckerPattern(CGContextRef context, CGRect rect, int width, int height);

//-----------------------------------------------------------------------------
// The Application's UINavigationController -- getter/setter
//-----------------------------------------------------------------------------
UINavigationController* navController();

void setNavController(UINavigationController* newNavController);

#define DEBUG 1
#if DEBUG
//-----------------------------------------------------------------------------
// dumpWindows - prints the windows and their subview hierarchy in console log
// dumpView    - prints the view hierarchy to the console log
//-----------------------------------------------------------------------------
void dumpWindows();		
void dumpView(UIView* aView, NSString* indent);
#endif

@end
