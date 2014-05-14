#import "CAKeyframeAnimation+Additions.h"

@implementation CAKeyframeAnimation (Additions)

//
// gm_bounceAnimation:alongXAxis: returns a key frame animation that can be added
// to a CALayer to make it bounce along the x or y axis
//
// params:
//   maxBouncePoints - maximum height of the bounce in points
//   bounceXAxis - YES for a bounce to the right, NO for a bounce upwards
//
+ (CAKeyframeAnimation*)gm_bounceAnimation:(CGFloat)maxBouncePoints
                               bounceXAxis:(BOOL)bounceXAxis
{
    const CGFloat kFactorsPerSec   =  25;
    const CGFloat kFactorsMaxValue = 128;
    const CGFloat factors[] = {0, 60, 83, 100, 114, 124, 128, 128, 124, 114, 100, 83, 60, 0, 0, 18, 28, 32, 28, 18, 0};
    enum { kNumFactors = sizeof(factors) / sizeof(*factors) };
    
    NSMutableArray* transforms = [NSMutableArray arrayWithCapacity:kNumFactors];
    
    for (NSUInteger i = 0; i < kNumFactors; i++) {
        CGFloat positionOffset  = (factors[i] / kFactorsMaxValue) * maxBouncePoints;
        CATransform3D transform = CATransform3DMakeTranslation(bounceXAxis ? positionOffset : 0,
                                                               bounceXAxis ? 0 : -positionOffset,
                                                               0.0f);
        
        [transforms addObject:[NSValue valueWithCATransform3D:transform]];
    }
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.repeatCount           = 1;
    animation.duration              = kNumFactors / kFactorsPerSec;
    animation.fillMode              = kCAFillModeForwards;
    animation.values                = transforms;
    animation.removedOnCompletion   = YES;  // final stage is equal to starting stage
    animation.autoreverses          = NO;
    
    return animation;
}

@end
