//
//  RemoteImage.h
//  ClockU
//
//  Created by Gary Morris on 5/16/10 from
//  http://www.dimzzy.com/blog/2009/11/remote-image-for-iphone/
//  Copyright 2010 Gary A. Morris. All rights reserved.
//
//----------------------------------------------------------------------------
//  Remote Image
//  from: http://www.dimzzy.com/blog/2009/11/remote-image-for-iphone/
// 
//  RemoteImage class is the implementation of the image proxy that wraps UIImage and manages its lifecycle. It provides the following features:
//
//  * Dedicated NSOperationQueue shared by all remote images. Each LoadImageOperation is performed on this queue. Why this is an advantage is not obvious but if you consider how Daily Deviations operates it becomes clear. Each day site publishes a list of selected images, also known as daily deviations. User can change the date and see the page for that day. If not all images are loaded for the current day yet and user changes the date Daily Deviations cancels all operations in the queue thus freeing the bandwidth for the next batch of images. With a single queue it is one method call: [[RemoteImage queue] cancelAllOperations].
//  * Ability to quickly unload all images. Application should use it when memory is low to drop all remote images' data. It's also possible to lock particular images so they are not unloaded. Daily Deviations for example locks the remote image that is viewed in the details screen so thumbnails could be unloaded if the detailed image is too big.
//  * Notifications on status change. When image starts loading, is loaded, is unloaded or is failed to load RemoteImage posts a notification using default NSNotificationCenter. All UI components that are interested in the state of the remote image could listen to these events and update themselves accordingly.
//
//  Two main properties of the RemoteImage are link and image. Link is the URL of the remote image and can be changed anytime, typically during creation of the RemoteImage instance. Image property is read-only and points to the UIImage instance when loaded. There is no property for the placeholder image since it really depends on UI component but you may add one if necessary.
//----------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import "LoadImageOperation.h"

// Sent only when image is loaded, failed to load or was unloaded.
extern NSString * const RemoteImageStatusChangedNotification;

@interface RemoteImage : NSObject {
	NSString *imageURL;
	UIImage  *image;
	LoadImageOperation *operation;
	RemoteImageStatus status;
	NSString *errorMsg;		// set when image load failed
	BOOL locked;
}

@property(assign) BOOL locked;					// true if image in use and should not be unloaded
@property(readonly) RemoteImageStatus status;	// image state
@property(readonly) NSString *imageURL;			// image URL
@property(readonly) UIImage *image;				// actual image, retained
@property(readonly) NSString *errorMsg;			// error message from loading image, nil if no error

- (void)setImage:(UIImage*)newImage withURL:(NSString*)newURL;

- (void)load;
- (void)unload;
- (BOOL)remove;	// removes imageURL file IF it is in the Documents folder only, returns YES if removed

- (void)operateWithPriority:(NSOperationQueuePriority)priority;

@end

