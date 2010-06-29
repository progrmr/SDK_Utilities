//
//  RemoteImage.m
//  ClockU
//
//  Created by Gary Morris on 5/16/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "RemoteImage.h"
#import "Utilities.h"

NSString* const RemoteImageStatusChangedNotification = @"RemoteImageStatusChangedNotification";

@implementation RemoteImage

@synthesize imageURL, image, status, locked, errorMsg;


+ (NSOperationQueue *)queue {
	static NSOperationQueue *queue;
	
	if (!queue) {
		queue = [[NSOperationQueue alloc] init];
	}
	return queue;
}

+ (void)cancelLoadingAllImages {
	[[RemoteImage queue] cancelAllOperations];
}

- (void)dealloc {
	[operation cancel];
	[operation release];

	[image    release];
	[imageURL release];
	[errorMsg release];
	
	[super dealloc];
}

- (id)init {
	if (self = [super init]) {
		status = kRemoteImageUnloaded;
	}
	return self;
}

-(void)setStatus:(RemoteImageStatus)newStatus
{
	if (status != newStatus) {
		status = newStatus;
		[[NSNotificationCenter defaultCenter]
		 postNotificationName:RemoteImageStatusChangedNotification object:self];
	}
}

-(void)setImage:(UIImage *)newImage
{
	[newImage retain];
	[image release];	
	image = newImage;
}

-(void)setImageURL:(NSString*)newImageURL
{
	[newImageURL retain];
	[imageURL release];
	imageURL = newImageURL;
}

-(void)setErrorMsg:(NSString*)newErrorMsg
{
	[newErrorMsg retain];
	[errorMsg release];
	errorMsg = newErrorMsg;
}

- (void)imageOperationDone:(NSMutableDictionary *)context
{
	self.image    = [context objectForKey:kImageKey];
	self.imageURL = [context objectForKey:kURLKey];
	self.errorMsg = [context objectForKey:kErrorKey];

	[operation release];
	operation = nil;
	self.status = image ? kRemoteImageLoaded : kRemoteImageFailedToLoad;
}

- (void)setImage:(UIImage*)newImage withURL:(NSString*)newURL
{
	if (self.locked) return;
	
	self.imageURL = newURL;		// update URL, if provided

	if (newImage != image) {
		[newImage retain];	
		[self unload];		// unload existing image if any, image gets nil	
		image = newImage;	
		
		if (image && imageURL==nil) {
			// have image but no URL, need to save this image, to create a URL
			[self load];	// saves the image
		} else if (image==nil && imageURL) {
			// have URL but no image, need to load the image
			[self load];	// loads the image
		} else {
			// we have an image+URL, or no image no URL
			self.status = image ? kRemoteImageLoaded : kRemoteImageUnloaded;
		}
		
	} else {
		// image not changed, image==newImage, both valid or both nil
		if (image) {
			// images are the same and are loaded
			if (imageURL) {
				self.status = kRemoteImageLoaded;
			} else {
				// have image but no URL, need to write it to a file, create URL
				[self load];	// saves the image
			}
			
		} else {
			// image/newImage are nil but status should be unloaded
			if (imageURL) {
				[self load];	// loads the image
			} else {
				self.status = kRemoteImageUnloaded;
			}
		}
	}
}

- (void)operateWithPriority:(NSOperationQueuePriority)priority {
	NSLog(@"%s", __PRETTY_FUNCTION__);

	if (operation && [operation isCancelled]) {
		[operation release];
		operation = nil;
		self.status = kRemoteImageUnloaded;
	}
	
	NSMutableDictionary *context = nil;

	if (image) {
		if (imageURL) {
			// already have both image and URL, this is an error
			NSLog(@"%s ERROR: already have image and URL", __PRETTY_FUNCTION__);
			self.status = kRemoteImageLoaded;
			return;
		} else {
			// already have an image but no URL, save it to a file
			// and create a file URL
			self.status = kRemoteImageSaving;
			context = [NSMutableDictionary dictionary];
			[context setObject:image forKey:kImageKey];	// pass image in
		}
	} else {
		if (imageURL) {
			// have a URL but need to load the image
			self.status = kRemoteImageLoading;
			context = [NSMutableDictionary dictionary];
			[context setObject:imageURL forKey:kURLKey]; // pass URL in as string
		} else {
			// have no URL and no image, nothing we can do here
			NSLog(@"%s no image, no URL", __PRETTY_FUNCTION__);
			self.status = kRemoteImageFailedToLoad;
			return;
		}
	}
	
	operation = [[LoadImageOperation alloc] initWithContext:context
												   selector:@selector(imageOperationDone:)
													 target:self];
	[operation setQueuePriority:priority];
	NSLog(@"%s queuing op", __PRETTY_FUNCTION__);
	[[RemoteImage queue] addOperation:operation];
}

- (void)load {
	[self operateWithPriority:NSOperationQueuePriorityNormal];
}

- (void)unload {
	if (self.locked) return;

	if (operation) {
		[operation cancel];
		[operation release];
		operation = nil;
	}
	self.image = nil;
	self.status = kRemoteImageUnloaded;
}

// removes imageURL file IF it is in the Documents folder only, returns YES if removed
- (BOOL)remove {
    NSURL* url = [NSURL URLWithString:imageURL];
	BOOL removed = NO;
	
	if (isFileInDocuments(url)) {
		NSError* error = nil;
		removed = [[NSFileManager defaultManager] removeItemAtURL:url error:&error];
		if (!removed) {
			NSLog(@"ERROR: %@ when removing %@", error.localizedDescription, imageURL);
		} 
	}
	
	return removed;
}

@end


