//
//  GMKeyboardViewConroller.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

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
