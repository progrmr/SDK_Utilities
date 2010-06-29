//
//  GMTableView.h
//  Clock
//
//  Created by Gary Morris on 3/18/10.
//  Copyright 2010 Gary A. Morris. All rights reserved.
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
