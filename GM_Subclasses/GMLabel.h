//
//  GMLabel.h
//  NextSprinter
//
//  Created by Gary Morris on 7/14/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//
// This is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this file. If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h> 

@interface GMLabel : UILabel {
    
	CAGradientLayer* glossLayer;

}

+(id)labelWithFrame:(CGRect)newFrame;
-(id)initWithFrame:(CGRect)newFrame;

@property (nonatomic, retain) CAGradientLayer* glossLayer;

@end
