//----------------------------------------------------------------------------
// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
// http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
//
// Extends the UIImage class to support resizing/cropping
//
//----------------------------------------------------------------------------

@interface UIImage (Resize)

//----------------------------------------------------------------------------
// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
//----------------------------------------------------------------------------
- (UIImage *)croppedImage:(CGRect)bounds;

//----------------------------------------------------------------------------
// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size 
// will be added around the edges of the thumbnail. (Adding a transparent 
// border of at least one pixel in size has the side-effect of antialiasing
// the edges of the image when rotating it using Core Animation.)
//----------------------------------------------------------------------------
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

//----------------------------------------------------------------------------
// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds
// specified by the parameter
//----------------------------------------------------------------------------
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

//----------------------------------------------------------------------------
// Resizes the image according to the given content mode,
// taking into account the image's orientation
//----------------------------------------------------------------------------
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

@end
