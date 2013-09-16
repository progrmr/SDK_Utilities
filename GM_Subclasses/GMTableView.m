//
//  GMTableView.m
//  Clock
//
//  Created by Gary Morris on 3/18/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
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
//

#import "GMTableView.h"
#import "UtilitiesUI.h"

@implementation GMTableView

@synthesize activeCell;
@synthesize activePath;

-(void)setActiveCell:(UITableViewCell *)newCell
{
	[newCell retain];

	if (newCell != activeCell) {
		//-------------------------
		// activeCell is changing
		//-------------------------
		[activeCell resignFirstResponder];		// put away any keyboard or picker
		
		// set new path if newCell is non-nil
		self.activePath = newCell ? [self indexPathForCell:newCell] : nil;
	}	

	[activeCell release];
	activeCell = newCell;
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
	if (newWindow) {
		//--------------------------------------
		// Subscribe to Keyboard notifications
		//--------------------------------------
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(keyboardWillShow:)
													 name: UIKeyboardWillShowNotification 
												   object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(keyboardWillHide:)
													 name: UIKeyboardWillHideNotification 
												   object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(keyboardDidShow:)
													 name: UIKeyboardDidShowNotification 
												   object: nil];
		[[NSNotificationCenter defaultCenter] addObserver: self 
												 selector: @selector(keyboardDidHide:)
													 name: UIKeyboardDidHideNotification 
												   object: nil];
	}
	self.activeCell = nil;	
	
	[super willMoveToWindow:newWindow];
}

-(void)didMoveToWindow
{
	keyboardHeight = 0;
	
	if (self.window == nil) {
		//--------------------------------------
		// Unsubscribe to Keyboard notifications
		//--------------------------------------
		[[NSNotificationCenter defaultCenter] removeObserver:self];	
	}
	[super didMoveToWindow];
}

//-------------------------------------------------------------
// override hitTest:withEvent: to track which cell is "active"
//-------------------------------------------------------------
-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent*)event
{
	// check to see if the hit is in this table view
	if ([self pointInside:point withEvent:event]) {
		UITableViewCell* newCell = nil;
		
		// hit is in this table view, find out 
		// which cell it is in (if any)
		for (UITableViewCell* aCell in self.visibleCells) {
			if ([aCell pointInside:[self convertPoint:point toView:aCell] withEvent:nil]) {
				newCell = aCell;
				break;
			}
		}
		
		// if it touched a different cell, tell the previous cell to resign
		// this gives it a chance to hide the keyboard or date picker or whatever
		if (newCell != activeCell) {
			self.activeCell = newCell;
		}
	}
	
	// return the super's hitTest result
	return [super hitTest:point withEvent:event];
}

-(void)setFrame:(CGRect)newFrame
{
#if 1
	NSLog(@"%s new=%3.0f,%3.0f %3.0f,%3.0f", __PRETTY_FUNCTION__,
		  newFrame.origin.x, newFrame.origin.y,
		  newFrame.size.width, newFrame.size.height);
#endif
	
	if (self.superview) {
		///NSLog(@"%s super=%@", __PRETTY_FUNCTION__, self.superview);
		
		if (newFrame.size.height > self.superview.frame.size.height) {
			// we got more than our superview's height, fix it
			// this happens when the keyboard is visible during a rotation to landscape
			newFrame.size.height = self.superview.frame.size.height;
		}
		
		if (!keyboardHidden && newFrame.size.height < (self.superview.frame.size.height * 0.25))
		{
			// we got less than 1/4 the superview's height, fix it,
			// this happens when the keyboard is visible during a rotation to portrait
			newFrame.size.height = self.superview.frame.size.height - keyboardHeight;
		}
	}
	
	[super setFrame:newFrame];
}

-(void)keyboardWillShow:(NSNotification*)aNotification
{
	// Get the size of the keyboard.
    NSDictionary* info  = [aNotification userInfo];
    NSValue* aValue     = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	keyboardHeight = keyboardSize.height;
	
	///NSLog(@"%s size=%@ %@", __PRETTY_FUNCTION__, NSStringFromCGSize(keyboardSize), aNotification);
	
	// Shrink the table view to make room for the keyboard at the bottom
	CGRect tvFrame = self.frame;
	tvFrame.size.height -= keyboardSize.height;
	self.frame = tvFrame;

	if (activePath) {
		[self scrollToRowAtIndexPath:activePath 
					atScrollPosition:UITableViewScrollPositionBottom 
							animated:YES];
	}
}

-(void)keyboardDidShow:(NSNotification*)aNotification
{
	keyboardHidden = NO;
}

-(void)keyboardWillHide:(NSNotification*)aNotification
{
	// Get the size of the keyboard.
    NSDictionary* info  = [aNotification userInfo];
    NSValue* aValue     = [info objectForKey:UIKeyboardBoundsUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
	
	///NSLog(@"keybdWillHide=(%1.0f,%1.0f) %@", keyboardSize.width, keyboardSize.height, self);
	
	// Enlarge the table view to use the space taken by the keyboard
	CGRect tvFrame = self.frame;
	tvFrame.size.height += keyboardSize.height;
	self.frame = tvFrame;	
}

-(void)keyboardDidHide:(NSNotification*)aNotification
{
	keyboardHidden = YES;
}

- (void)dealloc {
	[activeCell release];
	[activePath release];
	
    [super dealloc];
}

@end
