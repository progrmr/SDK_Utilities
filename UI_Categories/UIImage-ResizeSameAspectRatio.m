//
//  Tmp.m
//  ClockU
//
//  Created by Gary Morris on 5/24/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
//

#import "UIImage-ResizeSameAspectRatio.h"


@implementation UIImage (UIImage_ResizeSameAspectRatio)

#define radians(degrees) (degrees * M_PI / 180)

+(UIImage*)imageWithImage:(UIImage*)sourceImage 
				   Factor:(CGFloat)factor 
				  Quality:(CGInterpolationQuality)interpolationQuality
///+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
{  
    CGSize imageSize = sourceImage.size;
    CGFloat width  = imageSize.width;
    CGFloat height = imageSize.height;
	
	CGSize targetSize = CGSizeMake(width*factor, height*factor);
    CGFloat targetWidth  = targetSize.width;
    CGFloat targetHeight = targetSize.height;
	
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	NSLog(@"%s imageSize=%@ targetSize=%@", __PRETTY_FUNCTION__, 
		  NSStringFromCGSize(imageSize), 
		  NSStringFromCGSize(targetSize));
	
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor  = targetWidth  / width;
        CGFloat heightFactor = targetHeight / height;
		
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
	
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
	
    CGContextRef bitmap;
	
    if (sourceImage.imageOrientation == UIImageOrientationUp || 
		sourceImage.imageOrientation == UIImageOrientationDown)
	{
        NSLog(@"bitmap width=%3.0f height=%3.0f", targetWidth, targetHeight);
		bitmap = CGBitmapContextCreate(NULL, 
									   targetWidth, 
									   targetHeight, 
									   CGImageGetBitsPerComponent(imageRef), 
									   CGImageGetBytesPerRow(imageRef), 
									   CGImageGetColorSpace(imageRef), 
									   bitmapInfo);
		
	} else {
		NSLog(@"bitmap width=%3.0f height=%3.0f", targetHeight, targetWidth);
		bitmap = CGBitmapContextCreate(NULL, 
									   targetHeight, 
									   targetWidth, 
									   CGImageGetBitsPerComponent(imageRef), 
									   CGImageGetBytesPerRow(imageRef), 
									   CGImageGetColorSpace(imageRef), 
									   bitmapInfo);
    }   

    // In the right or left cases, we need to switch scaledWidth and scaledHeight,
    // and also the thumbnail point
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth  = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
        CGFloat oldScaledWidth = scaledWidth;
        scaledWidth  = scaledHeight;
        scaledHeight = oldScaledWidth;
		
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
		
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
		
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }

	CGContextSetInterpolationQuality(bitmap, interpolationQuality);
	
	NSLog(@"scaledWidth=%3.0f scaledHeight=%3.0f", scaledWidth, scaledHeight);
	
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
