//
//  GMNavController.m
//  ClockU
//
//  Created by Gary Morris on 5/22/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
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
