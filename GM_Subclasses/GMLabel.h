//
//  GMLabel.h
//  NextSprinter
//
//  Created by Gary Morris on 7/14/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface GMLabel : UILabel {
    
	CAGradientLayer* glossLayer;

}

+(id)labelWithFrame:(CGRect)newFrame;
-(id)initWithFrame:(CGRect)newFrame;

@property (nonatomic, retain) CAGradientLayer* glossLayer;

@end
