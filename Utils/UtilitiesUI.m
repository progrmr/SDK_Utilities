//
//  UtilitiesUI.m
//  Clock
//
//  Created by Gary Morris on 3/12/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "UtilitiesUI.h"
#import "UIColor-Expanded.h"
#import "UIColor-HSVAdditions.h"

@implementation UtilitiesUI

//-----------------------------------------------------------------------------
// BOOL isPad()
//-----------------------------------------------------------------------------
BOOL isPad() {
#ifdef UI_USER_INTERFACE_IDIOM
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
	return NO;
#endif
}

//-----------------------------------------------------------------------------
// BOOL isRetina();
//-----------------------------------------------------------------------------
BOOL isRetina() 		// screen has a scale factor of > 1.5
{
	static CGFloat scale = -1.0f;
	
	if (scale < 0.0f) {
		UIScreen* screen = [UIScreen mainScreen];
		// Get the scale of the screen if available (iOS 4.0 only)
		if ([screen respondsToSelector:@selector(scale)]) {
			scale = screen.scale;
		} else {
			scale = 1.0f;		// not a retina display
		}
	} 
	
	return scale > 1.5f;		// retina display has scale of 2.0, others 1.0
}

//-----------------------------------------------------------------------------
// addPadSuffixOnPad
//
// Input:   baseNibName
// Returns: baseNibName      (on iPhone) OR
//          baseNibName~ipad (on iPad)
// (doesn't check to see if the nib exists, just returns the name)
//-----------------------------------------------------------------------------
NSString* addPadSuffixOnPad(NSString* baseNibName)
{
	NSString* result;

	if (isPad()) {
		// current device is an iPad
		result = [[[NSString alloc] initWithFormat:@"%@~ipad", baseNibName] autorelease];
	} else {
		// current device is an iPhone / iPod Touch
		result = [[baseNibName retain] autorelease];
	}
	return result;
}

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
NSString* stripPadSuffixOnPhone(NSString* padNibName)
{
	if (isPad()) {
		// return input name, unchanged
		return padNibName;
	}
	
#define SUFFIX @"~ipad"
	
	// Strip the ~ipad suffix if it exists
	NSString* suffix = 
		[padNibName substringFromIndex:[padNibName length]-[SUFFIX length]];
	
	if ([suffix isEqualToString:SUFFIX]) {
		// has iPad suffix, strip it off
		return [padNibName substringToIndex:[padNibName length]-[SUFFIX length]];
	} else {
		// doesn't have iPad suffix, return unchanged
		return padNibName;
	}
}

//-----------------------------------------------------------------------------
// isPortrait -- current orientation
//-----------------------------------------------------------------------------
BOOL isPortraitOr(UIDeviceOrientation orientation) {
	return !UIDeviceOrientationIsLandscape(orientation);
}

BOOL isPortrait() {
	return isPortraitOr([[UIDevice currentDevice] orientation]);	
}

NSString* NSStringFromOrientation(UIDeviceOrientation orientation) 
{
	switch (orientation) {
		case UIDeviceOrientationUnknown:		return @"Unknown Orientation";
		case UIDeviceOrientationPortrait:		return @"Portrait";
		case UIDeviceOrientationPortraitUpsideDown:	return @"Portrait UpsideDown";
		case UIDeviceOrientationLandscapeLeft:	return @"Landscape Left";
		case UIDeviceOrientationLandscapeRight:	return @"Landscape Right";
		case UIDeviceOrientationFaceUp:			return @"Face Up";
		case UIDeviceOrientationFaceDown:		return @"Face Down";
		default:
			return [NSString stringWithFormat:@"Invalid Orientation (%d)",
					(int)orientation];
	}
}

//-----------------------------------------------------------------------------
// computeNewOrigin
// Compute a new origin for an view of a given size in a target frame size,
// positioned with the center of the item relative to the top and 
// relative to the left of the target frame
//-----------------------------------------------------------------------------
CGPoint computeNewOrigin(CGSize  targetFrameSize, 
						 CGSize  itemFrameSize, 
						 CGFloat relativeToLeft,	// range 0.0 - 1.0
						 CGFloat relativeToTop) 	// range 0.0 - 1.0
{
	CGPoint newOrigin;
	
	//--------------------------------------------------------
	// Position the item vertically in the view relativeToTop
	//--------------------------------------------------------
	newOrigin.y = round(targetFrameSize.height * relativeToTop - itemFrameSize.height / 2);
	
	if (newOrigin.y+itemFrameSize.height > targetFrameSize.height) {
		// too far down, it will be off the bottom edge
		newOrigin.y = targetFrameSize.height - itemFrameSize.height;
	} else if (newOrigin.y < 0) {
		// too far up, it will be off the top edge
		newOrigin.y = 0;
	}
	
	// Position the item horizontally in the view relativeToLeft
	newOrigin.x = round(targetFrameSize.width * relativeToLeft - itemFrameSize.width / 2);
	
	if (newOrigin.x+itemFrameSize.width > targetFrameSize.width) {
		// too far right, it will be off the right edge
		newOrigin.x = targetFrameSize.width - itemFrameSize.width;
	} else if (newOrigin.x < 0) {
		// too far left, it will be off the left edge
		newOrigin.x = 0;
	}
	
	return newOrigin;
}

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
					   CGFloat relativeToTop) 	// range 0.0 - 1.0
{
	itemFrame.origin = computeNewOrigin(targetFrameSize, itemFrame.size, relativeToLeft, relativeToTop);
	
	return itemFrame;
}

//-----------------------------------------------------------------------------
// distanceBetweenPoints
//-----------------------------------------------------------------------------
CGFloat distanceBetweenPoints(CGPoint pt1, CGPoint pt2)
{
    CGFloat dx = pt2.x - pt1.x;
    CGFloat dy = pt2.y - pt1.y;
    return sqrt(dx*dx + dy*dy);
}

//-----------------------------------------------------------------------------
// Long to UIColor conversions
//-----------------------------------------------------------------------------
uint32_t LongFromUIColor(UIColor* color)
{
	union {
		unsigned char ch[4];
		uint32_t i;
	} k;
	
#if USE_RGB
	k.ch[0] = roundf(color.red   * 255.0f);
	k.ch[1] = roundf(color.green * 255.0f);
	k.ch[2] = roundf(color.blue  * 255.0f);
	k.ch[3] = roundf(color.alpha * 255.0f);
#else
	k.ch[0] = roundf(color.hue        * 255.0f);
	k.ch[1] = roundf(color.saturation * 255.0f);
	k.ch[2] = roundf(color.brightness * 255.0f);
	k.ch[3] = roundf(color.alpha      * 255.0f);
#endif
	
	return k.i;
}

UIColor* UIColorFromLong(uint32_t longValue)
{
	union {
		unsigned char ch[4];
		uint32_t i;
	} k;
	
	k.i = longValue;
	
#if USE_RGB
	return [UIColor colorWithRed:(k.ch[0]/255.0f) 
						   green:(k.ch[1]/255.0f) 
							blue:(k.ch[2]/255.0f) 
						   alpha:(k.ch[3]/255.0f)];
#else 
	return [UIColor colorWithHue:(k.ch[0]/255.0f) 
					  saturation:(k.ch[1]/255.0f) 
					  brightness:(k.ch[2]/255.0f) 
						   alpha:(k.ch[3]/255.0f)];
#endif
}

NSString* NSStringFromUIColor(UIColor* color)
{
	int h = roundf(color.hue        * 255.0f);
	int s = roundf(color.saturation * 255.0f);
	int b = roundf(color.brightness * 255.0f);
	int a = roundf(color.alpha      * 255.0f);
	
	return [[[NSString alloc] initWithFormat:@"%02x%02x%02x%02x", h, s, b, a] autorelease];
}

void drawCheckerPattern(CGContextRef context, CGRect rect, int width, int height)
{
	CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);

	// draw background checkerboard pattern to help visualize transparency of
	// sample colors overlayed on top of this view
	
	for (int x=rect.origin.x; x<rect.size.width; x+=(width*2)) {		
		for (int y=rect.origin.y; y<rect.size.height; y+=(height*2)) {
			// draw two squares in this larger square to make checkerboard pattern
			CGContextFillRect(context, CGRectMake(x, y, width, height));
			CGContextFillRect(context, CGRectMake(x+width, y+width, width, height));
		}
	}
}

//-----------------------------------------------------------------------------
// Find UINavigationController
//-----------------------------------------------------------------------------
static UINavigationController* appNavController = nil;	// not retained here

UINavigationController* navController()
{
	return appNavController;
}

void setNavController(UINavigationController* newNavController)
{
	appNavController = newNavController;
}

#if DEBUG
//-----------------------------------------------------------------------------
// dumpWindows
//-----------------------------------------------------------------------------
void dumpWindows()
{
	// dump all the windows
	for (UIWindow* window in [UIApplication sharedApplication].windows) {
		dumpView(window, @"dumpView: ");
	}
		
}

//-----------------------------------------------------------------------------
// dumpView
//-----------------------------------------------------------------------------
void dumpView(UIView* aView, NSString* indent)
{
	if (aView) {
		NSLog(@"%@%@", indent, aView);		// dump this view
		
		if (aView.subviews.count > 0) {
			NSString* subIndent = [[NSString alloc] initWithFormat:@"%@%@", 
							indent, ([indent length]/2)%2==0 ? @"| " : @": "];
		
			// dump its subviews
			for (UIView* aSubview in aView.subviews) dumpView( aSubview, subIndent );
			
			[subIndent release];
		}
	}
}
#endif

@end






























