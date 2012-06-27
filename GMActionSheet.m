//
//  GMActionSheet.m
//  NextSprinter
//
//  Created by Gary Morris on 11/21/11.
//  Copyright (c) 2011 Gary A. Morris. All rights reserved.
//

#import "GMActionSheet.h"
#import "Utilities.h"

@implementation GMActionSheet

- (void) showInView:(UIView *)view {
    if (hasMultitasking()) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(applicationDidEnterBackground:) 
                                                     name:UIApplicationDidEnterBackgroundNotification 
                                                   object:nil];
    }
    [super showInView:view];
}

- (void) dealloc {
    if (hasMultitasking()) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [super dealloc];
}

- (void) applicationDidEnterBackground:(NSNotification*) notification {
    // We should not be here when entering background state
    [self dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:NO];
}

@end
