//
//  GMButtonPeaked.h
//  ThoughtLog
//
//  Created by Gary Morris on 4/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
// This file is part of SDK_Utilities.repo
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
#import <UIKit/UIKit.h>

@interface GMButtonPeaked : UIButton {
    
    CGFloat peakHeight;
    
}

@property (nonatomic, assign) CGFloat peakHeight;

@end
