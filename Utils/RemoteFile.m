//
//  RemoteFile.m
//  ClockU
//
//  Created by Gary Morris on 5/16/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "RemoteFile.h"
#import "Utilities.h"

NSString* const RemoteFileStatusChangedNotification = @"RemoteFileStatusChangedNotification";

@implementation RemoteFile

@synthesize status, fileURL, filePath, errorMsg;


+(NSOperationQueue *)queue {
	static NSOperationQueue *queue;
	
	if (queue == nil) {
		queue = [[NSOperationQueue alloc] init];
	}
	return queue;
}

+(void)cancelLoadingAllImages {
	[[self queue] cancelAllOperations];
}

-(void)dealloc {
	[operation cancel];
	[operation release];

	[filePath  release];
	[fileURL   release];
	[errorMsg  release];
	
	[super dealloc];
}

-(id)init {
	if ((self = [super init])) {
		status = kRemoteFileStatusUnknown;
	}
	return self;
}

-(void)setStatus:(RemoteFileStatus)newStatus
{
	if (status != newStatus) {
		status = newStatus;
        // on status change, send notification to observers
		[[NSNotificationCenter defaultCenter]
            postNotificationName:RemoteFileStatusChangedNotification object:self];
	}
}

-(void)setErrorMsg:(NSString*)newErrorMsg
{
	[newErrorMsg retain];
	[errorMsg release];
	errorMsg = newErrorMsg;
}

-(void)loadOpDone:(NSMutableDictionary *)context
{
	self.filePath = [context objectForKey:kFilepathKey];
	self.fileURL  = [context objectForKey:kURLKey];
	self.errorMsg = [context objectForKey:kErrorKey];

	[operation release];
	operation = nil;
	self.status = filePath ? kRemoteFileLoaded : kRemoteFileFailedToLoad;
}

-(void)load {
	///NSLog(@"%s", __PRETTY_FUNCTION__);
    
	if (operation && [operation isCancelled]) {
		[operation release];
		operation = nil;
		self.status = kRemoteFileLoadCancelled;
	}
	
    if (fileURL == nil) {
        // have no URL, nothing we can do here
        NSLog(@"%s ERROR: no URL", __PRETTY_FUNCTION__);
        self.status = kRemoteFileFailedToLoad;
        return;
    }
    
    // have a URL and need to load the file
    self.status = kRemoteFileLoading;       // started loading...
    
    NSMutableDictionary* context = [NSMutableDictionary dictionaryWithCapacity:3];
    
    [context setObject:fileURL forKey:kURLKey]; // pass URL in as string
    
    if (filePath) {
        // pass in path specifying where to put the downloaded file
        [context setObject:filePath forKey:kFilepathKey];
    }
    
	operation = [[LoadFileOp alloc] initWithContext:context
                                           selector:@selector(loadOpDone:)
                                             target:self];
    
	[operation setQueuePriority:NSOperationQueuePriorityNormal];
	[[RemoteFile queue] addOperation:operation];
}

@end


