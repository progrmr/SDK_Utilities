//
//  LoadImageOperation.h
//  ClockU
//
//  Created by Gary Morris on 5/16/10 from
//  http://www.dimzzy.com/blog/2009/11/remote-image-for-iphone/
//  Copyright 2010 Gary A. Morris. All rights reserved.
//
//----------------------------------------------------------------------------
//  This class extends NSOperation and represents a task to load remote image that could be performed asynchronously. What happens in Daily Deviations when user opens a feed? HTML page is scanned for images' urls and for each image a new LoadImageOperation is created and placed in the queue. OS picks these operations and performs them asynchronously notifying UI when they complete. User sees a grid of images' placeholders that are filled with images as they are loaded. At the same time user is free to scroll the grid and navigate within the application.
//----------------------------------------------------------------------------

#import <UIKit/UIKit.h>

#define kImageKey  @"image"
#define kURLKey    @"url"
#define kErrorKey  @"error"

typedef unsigned int RemoteImageStatus;
enum {
    kRemoteImageUnloaded,
    kRemoteImageLoading,
	kRemoteImageSaving,
    kRemoteImageFailedToLoad,
    kRemoteImageLoaded
};

@interface LoadImageOperation : NSOperation {
	SEL selector;
	id target;
	NSMutableDictionary *context;
}

- (id)initWithContext:(NSMutableDictionary *)aContext
			 selector:(SEL)aSelector
			   target:(id)aTarget;

@end
