//
//  GMKeyboardViewConroller.m
//  NextSprinter
//
//  Created by Gary Morris on 3/26/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
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

#import "GMKeyboardVC.h"
#import "Utilities.h"

@implementation GMKeyboardVC

//---------------------------------------------------------------------------
// keyboardWillShow - moves view controller's view up so that the field
//    that is firstResponder will be visible above the keyboard
//---------------------------------------------------------------------------
-(void)keyboardWillShow:(NSNotification*)aNotification
{
    // Save the view's frame before the keyboard appeared
	beforeFrame = self.view.frame;
	
    // Get the size of the keyboard.
    NSDictionary* info  = [aNotification userInfo];
    NSValue* aValue     = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;

    // Get the animation duration
    NSNumber* aNumber = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    animDuration = aNumber.doubleValue;
    
    // Get the animation curve
    aNumber = [info objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    animCurve = aNumber.intValue;
    
    // Find the first responder that caused the keyboard to appear
    CGRect firstRespFrame = self.view.bounds;         // in case not found
    for (UIView* v in self.view.subviews) {
        if ([v isFirstResponder]) {
            firstRespFrame = v.frame;
            break;
        }
    }
    CGFloat curBottom = firstRespFrame.origin.y + firstRespFrame.size.height;
    CGFloat newBottom = self.view.frame.size.height - keyboardSize.height - 20;
    CGFloat deltaY = curBottom - newBottom;
    
    // Move the view controller's view up because of the keyboard
    if (deltaY > 0) {
        CGRect newFrame = self.view.frame;
        newFrame.origin.y -= deltaY;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animDuration];
        [UIView setAnimationCurve:animCurve];
        
        self.view.frame = newFrame;
        viewMovedUp = YES;
        
        [UIView commitAnimations];
    }
}

//---------------------------------------------------------------------------
// keyboardWillHide - put view back where it belongs
//---------------------------------------------------------------------------
-(void)keyboardWillHide:(NSNotification*)aNotification
{
    if (viewMovedUp) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animDuration];
        [UIView setAnimationCurve:animCurve];
        
        // Set the view controller's view back to where it was
        self.view.frame = beforeFrame;
        viewMovedUp = NO;
        
        [UIView commitAnimations];
    }
}

//---------------------------------------------------------------------------
// viewWillAppear - subscribe to keyboard notifications
//---------------------------------------------------------------------------
-(void)viewWillAppear:(BOOL)animated
{
    viewMovedUp = NO;
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(keyboardWillShow:)
                                                 name: UIKeyboardWillShowNotification 
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(keyboardWillHide:)
                                                 name: UIKeyboardWillHideNotification 
                                               object: nil];
    [super viewWillAppear:animated];
}

//---------------------------------------------------------------------------
// viewWillDisappear - unsubscribe to keyboard notifications
//---------------------------------------------------------------------------
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];	
    
    if (viewMovedUp) {
        self.view.frame = beforeFrame;      // undo the move
        viewMovedUp = NO;
    }
    
    [super viewWillDisappear:animated];
}

@end
