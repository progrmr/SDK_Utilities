//
//  GMKeyboardViewConroller.h
//  NextSprinter
//
//  Created by Gary Morris on 3/26/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

// This UIViewController subclass handles keyboard notifications and 
// moves the view so that the field being edited is not obscured by
// the popup keyboard

@interface GMKeyboardVC : UIViewController {
    
    CGRect beforeFrame;             // frame before keyboard appeared
    
    NSTimeInterval animDuration;    // keyboard animation duration  
    UIViewAnimationCurve animCurve; // keyboard animation curve
    
    BOOL viewMovedUp;
    
}

@end
