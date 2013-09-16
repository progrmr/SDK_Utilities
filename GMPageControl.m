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

#import "GMPageControl.h"

#define kDesiredSectionHeight (20)   // preferred minimum section height for a reasonable touch area
#define kDesiredSectionWidth  (18)   // preferred minimum section width for a reasonable touch area
#define kPageDotSpacing       (kPageDotDiameter * 4)     /* max space between dots */

#define KEY(page,state)       ([NSNumber numberWithInteger:((uint32_t)page & 0xff) | (((uint32_t)state & 0xff)<<8)])
#define PageFromKey(keyInt)   (keyInt & 0xff)
#define StateFromKey(keyInt)  ((keyInt >> 8) & 0xff)

@interface GMPageControl() {
    CGFloat sectionMinimumOriginX;  // origin x for the page 0 area in view bounds
    CGFloat dotMinimumOriginX;      // origin x for the page 0 dot in view bounds
    CGFloat sectionWidth;           // width of each dot's section
}

@property (nonatomic, retain) NSMutableDictionary* customViews;

@end


@implementation GMPageControl

- (void)dealloc
{
    [_selectedColor     release];
    [_deselectedColor   release];
    [_highlightColor    release];
    [_customViews       release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _selectedColor     = [[UIColor whiteColor] retain];
        _deselectedColor   = [[UIColor grayColor] retain];
        _highlightColor    = nil;         // default to no highlight
        _highlightedPage   = -1;          // no highlight page
        _highlightWidth    = 2;           // default 2 points wide
        _indicatorDiameter = 6;         // default 6 points
    }
    return self;
}

- (CGSize)sizeForNumberOfPages:(NSInteger)pageCount
{
    return CGSizeMake(pageCount * kDesiredSectionWidth, kDesiredSectionHeight);
}

- (CGSize)sizeThatFits:(CGSize)size
{
	// calculate origin X for the first page dot
    CGSize result = [self sizeForNumberOfPages:_numberOfPages];
    
    if (result.width > size.width) {
        result.width = size.width;     // reduce it to fit the specified width
        
        // don't reduce below the minimum possible width, enough for the dot and a 1/2 dot of space
        if (result.width < _indicatorDiameter*_numberOfPages*1.5f) {
            result.width = _indicatorDiameter*_numberOfPages*1.5f; 
        }
    }
    
    if (result.height > size.height) {
        result.height = size.height;    // reduce to fit the specified height
        
        // but don't reduce below the minimum height, enough for 2 dots high
        if (result.height < _indicatorDiameter*2) {
            result.height = _indicatorDiameter*2;
        }
    }
    
    return result;
}

- (CGRect)frameForDot:(NSInteger)pageIndex
{
    CGRect dotRect = CGRectMake(dotMinimumOriginX + (pageIndex * sectionWidth),
                                (self.bounds.size.height-_indicatorDiameter)/2,
                                _indicatorDiameter,
                                _indicatorDiameter);
    return dotRect;
}

- (void)layoutSubviews
{
	// calculate parameters based on actual width
    if (_numberOfPages) {
        sectionWidth = self.bounds.size.width / _numberOfPages;
    } else {
        sectionWidth = 0;
    }
    
    if (sectionWidth > kDesiredSectionWidth) {
        sectionWidth = kDesiredSectionWidth;
    }
    
    sectionMinimumOriginX = CGRectGetMidX(self.bounds) - (sectionWidth*_numberOfPages)/2;
    dotMinimumOriginX     = sectionMinimumOriginX +  (sectionWidth - _indicatorDiameter) / 2;
    
    for (NSNumber* keyNum in self.customViews.allKeys) {
        UIView* customView = [self.customViews objectForKey:keyNum];
        uint32_t key = [keyNum integerValue];
        
        // set the custom view's frame based on what page it belongs to
        NSInteger page = PageFromKey(key);
        if (page >= 0 && page < _numberOfPages) {
            CGRect dotFrame = [self frameForDot:page];
            customView.center = CGPointMake(CGRectGetMidX(dotFrame), CGRectGetMidY(dotFrame));

            // add to view if this view state matches the page's current state
            UIControlState state = StateFromKey(key);
            if ((state == UIControlStateNormal      && _currentPage != page) ||
                (state == UIControlStateHighlighted && _currentPage == page))
            {
                [self addSubview:customView];
            } else {
                [customView removeFromSuperview];
            }
            
        } else {
            [customView removeFromSuperview];       // not currently needed in view
        }
    }
                                            
    [self setNeedsDisplay];
}

- (void)setIndicatorDiameter:(CGFloat)indicatorDiameter
{
    _indicatorDiameter = indicatorDiameter;
    [self setNeedsLayout];
}

- (void)setNumberOfPages:(NSInteger)numberOfPages
{
	_numberOfPages = numberOfPages;
    self.hidden = _hidesForSinglePage && _numberOfPages <= 1;
    [self setNeedsLayout];
}

- (void)setHidesForSinglePage:(BOOL)hidesForSinglePage
{
    _hidesForSinglePage = hidesForSinglePage;
    self.hidden = _hidesForSinglePage && _numberOfPages <= 1;
}

- (void)setHighlightedPage:(NSInteger)highlightedPage
{
    _highlightedPage = highlightedPage;
    [self setNeedsLayout];
}

- (void)setCurrentPage:(NSInteger)newPageIndex
{
	// validate range
	if (newPageIndex >= _numberOfPages) {
		newPageIndex = _numberOfPages - 1;
	}
    if (newPageIndex < 0) {
        newPageIndex = 0;
    }
    
	_currentPage = newPageIndex;
	
    // update which views are visible and redraw the dots
    [self setNeedsLayout];
}

// setView:forPage:forState: - sets custom views for page indicators,
// set a nil view to remove previous view.  State parameter must be either
// UIControlStateNormal or UIControlStateHighlight only
- (void)setView:(UIView*)view forPage:(NSInteger)pageIndex forState:(UIControlState)state
{
    if (_customViews == nil) {
        self.customViews = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    
    NSNumber* key = KEY(pageIndex,state);
    
    if (view==nil) {
        // remove a view
        [self.customViews removeObjectForKey:key];
    } else {
        // add a view
        [self.customViews setObject:view forKey:key];
    }
    
    [self setNeedsLayout];
}

#pragma mark -
#pragma mark View Drawing 
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (NSInteger page=0; page<_numberOfPages; page++) {
        // compute dot rectangle
        CGRect dotRect = [self frameForDot:page];
        
        if (page == _highlightedPage && _highlightColor && _highlightWidth > 0.1) {
            // draw the highlight behind this indicator dor
            CGRect highlightRect = CGRectInset(dotRect, -_highlightWidth, -_highlightWidth);
            
            // fill in the highlight area
            CGContextSetFillColorWithColor(ctx, _highlightColor.CGColor);
            CGContextFillEllipseInRect(ctx, highlightRect);            
        }
        
        // draw the indicator dot for this page
        CGContextSetFillColorWithColor(ctx, (page == _currentPage) ? _selectedColor.CGColor : _deselectedColor.CGColor);
        CGContextFillEllipseInRect(ctx, dotRect);
    }
}

#pragma mark -
#pragma mark Touch Tracking
//-----------------------------------------------------------------------
// touchingPage
//-----------------------------------------------------------------------
- (void)touchingPage:(UITouch*)touch
{
	CGPoint touchPoint  = [touch locationInView:self];
	if (touchPoint.x > self.bounds.size.width-1) {
		touchPoint.x = self.bounds.size.width-1;	// limit point to bounds
	} else if (touchPoint.x < 0) {
		touchPoint.x = 0;
	}
	NSInteger newPageIndex = (NSInteger) ((touchPoint.x-sectionMinimumOriginX) / sectionWidth);

	if (newPageIndex >= _numberOfPages) {
		newPageIndex = _numberOfPages-1;
	}
    if (newPageIndex < 0) {
        newPageIndex = 0;
    }
	
	if (newPageIndex != _currentPage) {
		// Moved to a new station, update everyone
		self.currentPage = newPageIndex;
			
		// Invoke action routine
		[self sendActionsForControlEvents: UIControlEventValueChanged];
	}
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches) {
		[self touchingPage:touch];
	}
	return YES;	
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches) {
		[self touchingPage:touch];
	}
	return YES;	
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	if (event.type == UIEventTypeTouches) {
		[self touchingPage:touch];
	}
}

@end
