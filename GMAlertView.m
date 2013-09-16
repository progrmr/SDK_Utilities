//
//  GMAlertView.m
//
//  Created by Gary Morris on 8/19/11.
//  Code originally from http://stackoverflow.com/questions/3105974/dismissing-uialertviews-when-entering-background-state/3181223#3181223
//
// This file is part of SDK_Utilities.repo
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
