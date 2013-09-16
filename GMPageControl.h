//
// GMPageControl.h
//
// Created by Gary Morris on 3/4/11.
// Copyright 2011 Gary A. Morris. All rights reserved.
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

#import <UIKit/UIKit.h>

@interface GMPageControl : UIControl

@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger numberOfPages;

@property (nonatomic) BOOL hidesForSinglePage;
@property (nonatomic) CGFloat indicatorDiameter;        // default is 6 points

@property (nonatomic, retain) UIColor* selectedColor;   // default white
@property (nonatomic, retain) UIColor* deselectedColor; // default gray

// highlighting properties
@property (nonatomic) NSInteger highlightedPage;        // ignored if out of range
@property (nonatomic) CGFloat highlightWidth;           // width of highlight border
@property (nonatomic, retain) UIColor* highlightColor;  // default nil

// setView:forPage:forState: - sets custom views for page indicators,
// set a nil view to remove previous view.  State parameter must be either
// UIControlStateNormal or UIControlStateHighlight only
- (void)setView:(UIView*)view forPage:(NSInteger)pageIndex forState:(UIControlState)state;

// sizeForNumberOfPages: - returns best bounds size for the page control
- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount;

@end
