//
//  LoadFileOp.h
//  ClockU
//
//  Created by Gary Morris on 5/16/10 from
//  http://www.dimzzy.com/blog/2009/11/remote-image-for-iphone/
//  Copyright 2010 Gary A. Morris. All rights reserved.
//
//----------------------------------------------------------------------------
//  This class extends NSOperation and represents a task to load remote files 
//  that could be performed asynchronously.
//----------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#define kFilepathKey   @"filepath"
#define kURLKey        @"url"
#define kErrorKey      @"error"

typedef unsigned int RemoteFileStatus;
enum {
    kRemoteFileStatusUnknown,
    kRemoteFileLoading,
    kRemoteFileFailedToLoad,
    kRemoteFileLoadCancelled,
    kRemoteFileLoaded
};

@interface LoadFileOp : NSOperation {
	SEL selector;
	id target;
	NSMutableDictionary *context;
}

- (id)initWithContext:(NSMutableDictionary *)aContext
			 selector:(SEL)aSelector
			   target:(id)aTarget;

@end
