/*
 *  Utilities.h
 *  DailyPointWatch
 *
 *  Created by Gary Morris on 9/12/09.
 *  Copyright 2009 Gary A. Morris. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);


@interface Utilities : NSObject
{
	
}

typedef unsigned short MinuteOfTheDay;		// time of day in minutes from midnight

//============================================================================
// Determines if date/time format is set for 12 or 24 hour clock
//============================================================================
+(BOOL) use24HourClock;

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			   withHour:(NSInteger)hour 
				 Minute:(NSInteger)min 
				 Second:(NSInteger)sec;

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			 withMinute:(NSInteger)min 
				 Second:(NSInteger)sec;

//============================================================================
// Given a date/time, returns NSDate for the specified time on that same day
//============================================================================
+(NSDate*) dateFromDate:(NSDate*)fromDate 
			 withSecond:(NSInteger)sec;

//============================================================================
// returns NSDate for the specified y/m/d/h/m/s using current calendar
//============================================================================
+(NSDate*) dateWithYear:(NSInteger)year
				  Month:(NSInteger)month
					Day:(NSInteger)day
				   Hour:(NSInteger)hour
				 Minute:(NSInteger)min 
				 Second:(NSInteger)sec;

//============================================================================
// Given a date/time, return the NSDate for midnight on the starting day
// of the week, given the day of the week that the week starts on.
//
// ie: fromDate="Tue 2009-11-03", startWeekday="Mon", returns "Mon 2009-11-02"
//     fromDate="Tue 2009-11-03", startWeekday="Tue", returns "Tue 2009-11-03"
//     fromDate="Tue 2009-11-03", startWeekday="Wed", returns "Wed 2009-10-28"
//
// startingWeekday is 0..6 where 0=Sunday, 6=Saturday
//============================================================================
+(NSDate*) getStartOfWeek:(NSDate*)fromDate StartingWeekday:(int)startWeekday;

//============================================================================
// Given a date/time, return the NSDate for a date X days in the future
// (if daysOffset > 0) or X days in the past (if daysOffset < 0)
//
// Note: the time returned will be somewhere around noon on the right day,
//       use newTimeFromDate if you need a specific time of day
//============================================================================
+(NSDate*) getRelativeDate:(NSDate*)fromDate DaysOffset:(int)daysOffset;

//----------------------------------------------------------------------------
// extracts hour/minutes from NSDate, converts to MinuteOfTheDay
//----------------------------------------------------------------------------
+(MinuteOfTheDay) getMinuteOfTheDay:(NSDate*)time;

//============================================================================
// Constrains a value to be within a range.  
// IF the value given is less than the min THEN min is returned, 
// ELSIF the value given is greater than the max THEN max is returned, 
// ELSE the value is returned
//============================================================================
+(long)constrain:(long)value min:(long)min max:(long)max;
	
//============================================================================
// The oldValue given is replaced by the input value but only if the
// input value is not a null string.  If the input value is a null string
// then the oldValue is returned.
//============================================================================
+(long)filterNullString:(NSString*)input oldValue:(long)oldValue;

//-----------------------------------------------------------------------------
// adds spaces to pad string length to desired length
// spaces are evenly divided between left and right side to center the string
// returns the string unchanged if no padding needed, otherwise
// it returns an autoreleased string.
//-----------------------------------------------------------------------------
+(NSString*)centerStringWithPadding:(NSString*)str Length:(int)len;

//-----------------------------------------------------------------------------
// Checks the value to see if it is between min..max, if so no alert is
// displayed and the value is returned unchanged.
// If the value is > max or < min, then it displays an alert saying that
// <thingName> is too much or too low and returns the min or max value
//-----------------------------------------------------------------------------
+(long)checkRangeAndAlert:(NSString*)thingName value:(long)value min:(long)min max:(long)max;

//----------------------------------------------------------------------
// Pops up an alert box with the given titel and message
//----------------------------------------------------------------------
+(void)showMessage:(NSString*)message title:(NSString*)title;

//----------------------------------------------------------------------
// Creates an object from a nib file
//----------------------------------------------------------------------
+(id)loadNib:(NSString*)nibName ClassName:(NSString*)className Owner:(id)owner;

//----------------------------------------------------------------------
// returns memory usage/free in bytes
//----------------------------------------------------------------------
vm_size_t usedMemory(void);
natural_t freeMemory(void);
size_t sizeofUIImage(UIImage* image);
void logMemUsage(void);		// writes used/free w/NSLog if changed

//----------------------------------------------------------------------
// Displays an alert telling that the "what" is not implemented yet
// Calls to this are used as a placeholder during developement,
// do nothing in release code (calls should be removed, but just in case)
//----------------------------------------------------------------------
#ifndef NS_BLOCK_ASSERTIONS
+(void)notImplementedYet:(NSString*)what;
#endif

//----------------------------------------------------------------------
// returns YES if multitasking is available (iOS 4.0 or >)
//----------------------------------------------------------------------
BOOL hasMultitasking();

//----------------------------------------------------------------------
// returns the fullpath of the app's Documents folder
//----------------------------------------------------------------------
NSString* documentsPath();

//----------------------------------------------------------------------
// prints list of files w/NSLog
// pass nil for directory param to get list of Documents folder
//----------------------------------------------------------------------
void listFiles(NSString* directory);

//----------------------------------------------------------------------
// returns YES if the URL is a file scheme URL and the path to the
// file is in the app's Documents folder.
//----------------------------------------------------------------------
BOOL isFileInDocuments(NSURL* fileURL);

//----------------------------------------------------------------------
// logs the event to the FlurryAPI 
// (or to NSLog if in development)
//----------------------------------------------------------------------
void logEvent(NSString* description); 

@end

