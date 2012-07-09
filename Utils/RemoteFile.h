//
//  RemoteFile.h
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
//  RemoteFile class is the implementation of the image proxy that wraps UIImage and manages its lifecycle. It provides the following features:
//
//  * Dedicated NSOperationQueue shared by all remote images. Each LoadFileOp is performed on this queue. Why this is an advantage is not obvious but if you consider how Daily Deviations operates it becomes clear. Each day site publishes a list of selected images, also known as daily deviations. User can change the date and see the page for that day. If not all images are loaded for the current day yet and user changes the date Daily Deviations cancels all operations in the queue thus freeing the bandwidth for the next batch of images. With a single queue it is one method call: [[RemoteFile queue] cancelAllOperations].
//  * Ability to quickly unload all images. Application should use it when memory is low to drop all remote images' data. It's also possible to lock particular images so they are not unloaded. Daily Deviations for example locks the remote image that is viewed in the details screen so thumbnails could be unloaded if the detailed image is too big.
//  * Notifications on status change. When image starts loading, is loaded, is unloaded or is failed to load RemoteFile posts a notification using default NSNotificationCenter. All UI components that are interested in the state of the remote image could listen to these events and update themselves accordingly.
//
//  Two main properties of the RemoteFile are link and image. Link is the URL of the remote image and can be changed anytime, typically during creation of the RemoteFile instance. Image property is read-only and points to the UIImage instance when loaded. There is no property for the placeholder image since it really depends on UI component but you may add one if necessary.
//----------------------------------------------------------------------------


#import <Foundation/Foundation.h>
#import "LoadFileOp.h"

// Sent only when file is loaded, failed to load or was unloaded.
extern NSString* const RemoteFileStatusChangedNotification;

@interface RemoteFile : NSObject {
	NSString* fileURL;      // URL to file on the remote server
    NSString* filePath;     // path to file in local filesystem
    
	LoadFileOp* operation;
	RemoteFileStatus status;
	NSString* errorMsg;		// set when file load failed
}

@property(readonly) RemoteFileStatus status;	// file load state
@property(retain)   NSString* fileURL;			// remote file URL
@property(retain)   NSString* filePath;			// path to file in local filesystem
@property(readonly) NSString* errorMsg;			// error message from loadin, nil if no error

- (void)load;

@end



#if 0
//----------------------------------------------------------------------------
// The sample code below shows how a user of this class can start a file
// download (which runs as an NSOperation in a separate thread) and receive 
// asynchronous notifications from this class and act upon them
//----------------------------------------------------------------------------

// a "remoteFile" object must be declared somewhere where it will last
// for the duration of the load operation.
// ie: 
//    RemoteFile* remoteFile;

//----------------------------------------------------------------------------
// fileStatusChanged - called when RemoteFile sends a notification
//----------------------------------------------------------------------------
-(void)fileStatusChanged:(NSNotification*)notification
{
	switch (remoteFile.status) {
		case kRemoteFileLoading:
			NSLog(@"%s Loading...", __PRETTY_FUNCTION__);
			break;
            
		case kRemoteFileFailedToLoad:
            NSLog(@"%s Load FAILED: %@", __PRETTY_FUNCTION__, remoteFile.errorMsg);
			break;
            
		case kRemoteFileLoadCancelled:
            NSLog(@"%s Load Cancelled", __PRETTY_FUNCTION__);
			break;
            
		case kRemoteFileLoaded:
			NSLog(@"%s Load Complete: %@", __PRETTY_FUNCTION__, remoteFile.filePath);
            // file at remoteFile.filePath is available for use
			break;
            
		default:
			NSLog(@"%s Load Status unknown: %d", __PRETTY_FUNCTION__, remoteFile.status);
	}
}

//-------------------------------------------------------------
// Start the download of a remote file in a separate thread
//-------------------------------------------------------------
-(void)startDownloadFrom:(NSString*)fileURLString
{
    // set up notifications so we will know when the file load is done or failed
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(fileStatusChanged:)
                                                 name:RemoteFileStatusChangedNotification
                                               object:remoteFile];	
    remoteFile = [[RemoteFile alloc] init];
    remoteFile.fileURL = fileURLString;        
    
    [remoteFile load];  // start the load operation
}
#endif