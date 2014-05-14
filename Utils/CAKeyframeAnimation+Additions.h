#import <QuartzCore/QuartzCore.h>

@interface CAKeyframeAnimation (Additions)

//
// gm_bounceAnimation:alongXAxis: returns a key frame animation that can be added
// to a CALayer to make it bounce along the x or y axis
//
// params:
//   maxBouncePoints - maximum height of the bounce in points
//   bounceXAxis - YES for a bounce to the right, NO for a bounce upwards
//
// sample usage:
//   CAKeyframeAnimation* bounce = [CAKeyframeAnimation gm_bounceAnimation:50 bounceXAxis:NO];
//   [self.view.layer addAnimation:bounce forKey:@"bouncer"];
//

+ (CAKeyframeAnimation*)gm_bounceAnimation:(CGFloat)maxBouncePoints
                               bounceXAxis:(BOOL)bounceXAxis;

@end
