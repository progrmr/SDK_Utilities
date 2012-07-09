//
//  LoadFileOp.m
//  ClockU
//
//  Created by Gary Morris on 5/16/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "LoadFileOp.h"

@implementation LoadFileOp

- (id)initWithContext:(NSMutableDictionary *)aContext
			 selector:(SEL)aSelector
			   target:(id)aTarget
{
	if ((self = [super init])) {
		selector = aSelector;
		target   = [aTarget retain];
		context  = [aContext retain];
	}
	return self;
}

- (void)dealloc {
	[target  release];
	[context release];
	[super dealloc];
}

//----------------------------------------------------------------------------
// main
//----------------------------------------------------------------------------
- (void)main {
	@try {
		NSString* urlStr   = [context objectForKey:kURLKey];        // get URL string
        NSString* filePath = [context objectForKey:kFilepathKey];   // get dest file path
		NSString* errorMsg = nil;
		
		if (urlStr) {
			NSURL* url = [NSURL URLWithString:urlStr];
			NSURLResponse* response;
			NSError* error;
			
			NSLog(@"%s requesting %@", __PRETTY_FUNCTION__, urlStr);
			
			NSData *data = [NSURLConnection
							sendSynchronousRequest:[NSURLRequest requestWithURL:url]
							returningResponse:&response
							error:&error];
			if (self.isCancelled) return;

			if (data) {
                // then we write it out 
                [data writeToFile:filePath atomically:NO]; 
                
            } else {
                // error: unable to load file
				NSLog(@"%s ERROR: %@, URL=%@", __PRETTY_FUNCTION__, error.localizedDescription, urlStr);
				errorMsg = [NSString stringWithFormat:@"Not Found: %@", urlStr];
				[context setObject:errorMsg forKey:kErrorKey];
                [context setObject:@"" forKey:kFilepathKey];        // no file path
			}
		}
	}
	@catch (NSException *exception) {
		NSLog(@"%s: EXCEPTION %@: %@", __PRETTY_FUNCTION__, exception.name, exception.reason);
		[context setObject:exception.name forKey:kErrorKey];
	}
	
	// Notify target that the operation is completed.
	[target performSelectorOnMainThread:selector
							 withObject:context waitUntilDone:NO];
}

@end
