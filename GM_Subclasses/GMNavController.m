//
//  GMNavController.m
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

#import "GMNavController.h"


@implementation GMNavController

@synthesize didPushViewController;

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	NSLog(@"%s", __PRETTY_FUNCTION__);
	didPushViewController = YES;
	[super pushViewController:viewController animated:animated];
}

-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
	didPushViewController = NO;
	return [super popViewControllerAnimated:animated];
}

-(NSArray*)popToRootViewControllerAnimated:(BOOL)animated
{
	didPushViewController = NO;
	return [super popToRootViewControllerAnimated:animated];
}

-(NSArray*)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
	didPushViewController = NO;
	return [super popToViewController:viewController animated:animated];
}

@end
