//
//  UtilitiesUI.h
//
/*  Created by Gary Morris on 3/12/10.
 *  Copyright 2010-2011 Gary A. Morris. All rights reserved.
 *
 * This file is part of SDK_Utilities.repo
 *
 * This is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This file is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this file. If not, see <http://www.gnu.org/licenses/>.
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define newUICOLOR(r,g,b,a) ([[UIColor alloc] initWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a/255.0f)])


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

//-----------------------------------------------------------------------------
// tellParentToDismissModalVC
// exit this view controller, return to parent, handle iOS 5 change
//-----------------------------------------------------------------------------
void tellParentToDismissModalVC(UIViewController* viewController);

#ifdef DEBUG
//-----------------------------------------------------------------------------
// dumpWindows - prints the windows and their subview hierarchy in console log
// dumpView    - prints the view hierarchy to the console log
//-----------------------------------------------------------------------------
void dumpWindows();		
void dumpView(UIView* aView, NSString* indent, BOOL showLayers);
void dumpLayer(CALayer* aLayer, NSString* indent);
#endif
