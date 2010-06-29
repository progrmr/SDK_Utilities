//
//  GMNavController.h
//  ClockU
//
//  Created by Gary Morris on 5/22/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMNavController : UINavigationController {

	BOOL didPushViewController;		// indicates if last VC change was push or pop
	
}

@property (nonatomic, readonly) BOOL didPushViewController;

@end
