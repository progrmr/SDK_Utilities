//
//  GMTableView.h
//  Clock
//
//  Created by Gary Morris on 3/18/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
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

#import <UIKit/UIKit.h>


@interface GMTableView : UITableView {
	
	UITableViewCell* activeCell;		// cell last hit
	NSIndexPath*     activePath;		// path to activeCell
	CGFloat keyboardHeight;
	BOOL    keyboardHidden;
}

@property (nonatomic, retain) UITableViewCell* activeCell;
@property (nonatomic, retain) NSIndexPath* activePath;

@end
