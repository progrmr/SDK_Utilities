//
//  GMAlertView.m
//
//  Created by Gary Morris on 8/19/11.
//  Code originally from http://stackoverflow.com/questions/3105974/dismissing-uialertviews-when-entering-background-state/3181223#3181223
//

#import "GMAlertView.h"
#import "Utilities.h"

@implementation GMAlertView

- (void) show {
    if (hasMultitasking()) {
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(applicationDidEnterBackground:) 
                                                     name:UIApplicationDidEnterBackgroundNotification 
                                                   object:nil];
    }
    [super show];
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
