//
//  Tmp.m
//  ClockU
//
//  Created by Gary Morris on 5/24/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "UIImage-ResizeSameAspectRatio.h"


@implementation UIImage (UIImage_ResizeSameAspectRatio)

//------------------------------------------------------------------------------------------------------
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
//------------------------------------------------------------------------------------------------------
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
	NSLog(@"%s bitmapWidth=%d bitmapHeight=%d bytesPerRow=%d", bitmapWidth, bitmapHeight, bytesPerRow);
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

@end
