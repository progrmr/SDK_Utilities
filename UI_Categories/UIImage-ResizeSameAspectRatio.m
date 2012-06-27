//
//  Tmp.m
//  ClockU
//
//  Created by Gary Morris on 5/24/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "UIImage-ResizeSameAspectRatio.h"

// RESIZE_IMPL can be 1 or 2
// 1 selects the first implementation below
// 2 selects the second implementation below
#define RESIZE_IMPL 1

@implementation UIImage (UIImage_ResizeSameAspectRatio)

#define radians(degrees) (degrees * M_PI / 180)

#if RESIZE_IMPL==1
//--------------------------------------------------------------------------------
// Resize image
//
// Derived in part from: 
//     http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
//     http://github.com/jchatard/UIImage-categories/blob/master/UIImage%2BResize.m
//
//     http://stackoverflow.com/questions/1260249#1262395
//     http://stackoverflow.com/questions/2235210
//
// *Thread Safe* - this implementation is thread safe because it avoids the
// thread unsafe methods in UIKit which can only be used in the main thread.
//--------------------------------------------------------------------------------
+(UIImage*)imageWithImage:(UIImage*)sourceImage 
				   Factor:(CGFloat)factor 
				  Quality:(CGInterpolationQuality)interpolationQuality
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
	
    size_t targetWidth  = width  * factor + 0.5f;	// bitmap size, round to nearest integer
    size_t targetHeight = height * factor + 0.5f;
	CGSize targetSize   = CGSizeMake(targetWidth, targetHeight);
	
    CGFloat scaledWidth  = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointZero;

#if DEBUG
	NSLog(@"%s imageSize=%@ targetSize=%@", __PRETTY_FUNCTION__, 
		  NSStringFromCGSize(imageSize), 
		  NSStringFromCGSize(targetSize));
#endif
	
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor  = targetWidth  / width;
        CGFloat heightFactor = targetHeight / height;
		CGFloat scaleFactor = 0;
		
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;  // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
		
        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
	
    CGImageRef imageRef = sourceImage.CGImage;
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
	// normal or 90° rotated image orientation?
	BOOL normal = (sourceImage.imageOrientation == UIImageOrientationUp || 
		           sourceImage.imageOrientation == UIImageOrientationDown); 
	size_t bitmapWidth  = normal ? targetWidth  : targetHeight;
	size_t bitmapHeight = normal ? targetHeight : targetWidth;
	
	size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
#if DEBUG	
	NSLog(@"bitmapWidth=%lu bitmapHeight=%lu bytesPerRow=%lu", bitmapWidth, bitmapHeight, bytesPerRow);
#endif
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, 
											   bitmapWidth, 
											   bitmapHeight, 
											   CGImageGetBitsPerComponent(imageRef), 
											   bytesPerRow, 
											   CGImageGetColorSpace(imageRef), 
											   bitmapInfo);

    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth  = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, M_PI/2);  // rotate +90°
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth  = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, -M_PI/2);  // rotate -90°
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // No changes in this case
		
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI);    // rotate -180°
    }

	CGContextSetInterpolationQuality(bitmap, interpolationQuality);
	
#if DEBUG
	NSLog(@"scaledWidth=%3.0f scaledHeight=%3.0f", scaledWidth, scaledHeight);
#endif
	
    CGContextDrawImage(bitmap, 
					   CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), 
					   imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return newImage; 
}
#endif

#if RESIZE_IMPL==2
//--------------------------------------------------------------------------------
// Resize image
//
// Derived from: 
//      http://stackoverflow.com/questions/1282830/
//
// *Thread Safe* - this implementation is thread safe because it avoids the
// thread unsafe methods in UIKit which can only be used in the main thread.
//--------------------------------------------------------------------------------
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
	
    CGFloat targetWidth  = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth  = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointZero;
	
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor  = targetWidth  / width;
        CGFloat heightFactor = targetHeight / height;
		
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
		
        scaledWidth  = width  * scaleFactor;
        scaledHeight = height * scaleFactor;
		
        // center the image
        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5; 
        }
        else if (widthFactor < heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }     
	
    CGImageRef imageRef = sourceImage.CGImage;
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);	
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
    CGContextRef bitmap;
	
    if (sourceImage.imageOrientation == UIImageOrientationUp || 
		sourceImage.imageOrientation == UIImageOrientationDown)
	{
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
		
    }   
	
    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
	
    CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
	
    CGContextRelease(bitmap);
    CGImageRelease(ref);
	
    return newImage; 
}
#endif

#if RESIZE_IMPL==3
//----------------------------------------------------------------------------
// resizeImage
//----------------------------------------------------------------------------
-(UIImage*)resizeImage:(UIImage*)origImage 
				Factor:(CGFloat)factor 
			   Quality:(CGInterpolationQuality)interpolationQuality
{
 	CGImageRef imageRef = origImage.CGImage;
	CGPoint origin = CGPointMake(0,0);
	
	// normal or 90 rotated image orientation?
	BOOL normal = (origImage.imageOrientation == UIImageOrientationUp || 
		           origImage.imageOrientation == UIImageOrientationDown); 
	
	// Round new width/height to nearest pixel size since bitmap takes in integer values
	int targetWidth  = (int) (origImage.size.width  * factor + 0.5f); 
	int targetHeight = (int) (origImage.size.height * factor + 0.5f);
	
	NSLog(@"%s resizing %@ to %@", __PRETTY_FUNCTION__, 
		  NSStringFromCGSize(origImage.size),
		  NSStringFromCGSize(CGSizeMake(targetWidth, targetHeight)));
	
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
	CGContextRef bitmap = CGBitmapContextCreate(NULL, 
												targetWidth, ///normal ? targetWidth  : targetHeight, 
												targetHeight, ///normal ? targetHeight : targetWidth, 
												CGImageGetBitsPerComponent(imageRef), 
												CGImageGetBytesPerRow(imageRef), 
												CGImageGetColorSpace(imageRef),
												bitmapInfo);
	
	if (origImage.imageOrientation == UIImageOrientationLeft) {
		///origin.x = targetHeight / 4;
		CGContextRotateCTM (bitmap, radians(90));
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
		NSLog(@"orientation = UIImageOrientationLeft");
		
	} else if (origImage.imageOrientation == UIImageOrientationRight) {
		origin.x = -targetHeight / 4;
		CGContextRotateCTM (bitmap, radians(-90));
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
		NSLog(@"orientation = UIImageOrientationRight");
		
	} else if (origImage.imageOrientation == UIImageOrientationUp) {
		// NOTHING
		NSLog(@"orientation = UIImageOrientationUp");
		
	} else if (origImage.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM (bitmap, radians(-180.));
		NSLog(@"orientation = UIImageOrientationDown");
	}
	
	CGContextSetInterpolationQuality(bitmap, interpolationQuality);
	
	// Draw into the context, this scales the image
	if (!normal) {
		int tmp = targetWidth;
		targetWidth = targetHeight;
		targetHeight = tmp;
	}
	// -targetWidth/2 a little too much
	// -targetHeight  ??
	// -targetHeight/2 very close, but too much
	// -targetHeight/4 very very close, not enough
	// -targetHeight/3 perfect == -targetWidth/4
	CGRect targetRect = CGRectMake(origin.x, origin.y, targetWidth, targetHeight);
	NSLog(@"targetRect = %@, factor = %f", NSStringFromCGRect(targetRect), factor);
	CGContextDrawImage(bitmap, targetRect, imageRef);
	
	// Get an image from the context and a UIImage
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	///#ifdef DEBUG
	///	GMImage* result = [[[GMImage alloc] initWithCGImage:ref] autorelease];
	///#else
	UIImage* result = [UIImage imageWithCGImage:ref];
	///#endif
	
	NSLog(@"%s resized to %@", __PRETTY_FUNCTION__, NSStringFromCGSize(result.size));
	
	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);
	
	return result;
}
#endif


@end
