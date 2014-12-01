//
//  GMNavController.h
//  ClockU
//
//  Created by Gary Morris on 5/22/10.
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GMNavController : UINavigationController {

	BOOL didPushViewController;		// indicates if last VC change was push or pop
	
}

@property (nonatomic, readonly) BOOL didPushViewController;

@end
