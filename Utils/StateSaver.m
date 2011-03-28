//
//  StateSaver.m
//
//  Created by Gary Morris on 9/21/09.
//  Copyright 2009 Gary A. Morris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateSaver.h"

@implementation StateSaver

@synthesize stateData;
@synthesize fullPathname;

//----------------------------------------------------------------
// init state data - reads from StateData.xml, file need not exist
//----------------------------------------------------------------
-(id)init
{
	return [self initWithFile:@"StateData.xml"];
}

//----------------------------------------------------------------
// loadFromFile - loads from fullPathname, file need not exist
//----------------------------------------------------------------
-(void)loadFromFile
{
	NSMutableDictionary* tmp = nil;
	
	if ([[NSFileManager defaultManager] fileExistsAtPath:fullPathname]) { 
		// Read the last updated date and points values from the plist file
		tmp = [[NSMutableDictionary alloc] initWithContentsOfFile:fullPathname];
		NSLog(@"%s read %d from %@", __PRETTY_FUNCTION__, [tmp count], fullPathname);
		///NSLog(@"%@", tmp);
		
	} else {
		// file not found, create empty dictionary
		tmp = [[NSMutableDictionary alloc] initWithCapacity:6];
		NSLog(@"%s file not found: %@", __PRETTY_FUNCTION__, fullPathname);
	}
	
	self.stateData = tmp;
	[tmp release];
}

//----------------------------------------------------------------
// Save state data to file - app terminating or memory low
//----------------------------------------------------------------
-(void)saveDataToFile:(NSNotification*)notification {
	if ([stateData count]) {
		// write out the dictionary to the file			
		[stateData writeToFile:fullPathname atomically:YES];
		NSLog(@"%s wrote %d to %@", __PRETTY_FUNCTION__, [stateData count], fullPathname);
		///NSLog(@"%@", stateData);
	}
}

//----------------------------------------------------------------
// dealloc
//----------------------------------------------------------------
-(void)dealloc
{
	// remove self as observer before we get deallocated
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
    // save data before discarding it
    [self saveDataToFile:nil];
    
	[stateData	  release];
	[fullPathname release];
    
	[super dealloc];
}

//----------------------------------------------------------------
// stateData getter - reload the file if necessary
//----------------------------------------------------------------
-(NSMutableDictionary*)stateData
{
	if (stateData == nil && fullPathname) {
		// we have the filename but we don't have the data,
		// read in the file
		[self loadFromFile];
	}
	
	return [[stateData retain] autorelease];
}

-(void)setStateData:(NSMutableDictionary *)newDict
{
	if (fullPathname && [stateData count]) {
		// old stateData should be written out 
		// before being replaced with newDict
		[self saveDataToFile:nil];
	}
	[newDict retain];
	[stateData release];
	stateData = newDict;
}

//----------------------------------------------------------------
// Init state data - read from file
//----------------------------------------------------------------
-(id)initWithFile:(NSString*)filename
{
	// determine the full pathname to the state file
	NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString* documentsDirectory = [paths objectAtIndex:0];
	fullPathname = [documentsDirectory stringByAppendingPathComponent:filename];
	[fullPathname retain];
	
	[self loadFromFile];
	
	UIApplication* app = [UIApplication sharedApplication];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(saveDataToFile:) 
												 name:UIApplicationWillTerminateNotification 
											   object:app];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(saveDataToFile:) 
												 name:UIApplicationWillResignActiveNotification 
											   object:app];
	return self;
}

//----------------------------------------------------------------
// Count of items in dictionary, if count is 0 after init then
// file was not found and you should set your default values.
//----------------------------------------------------------------
-(NSUInteger)count
{
	return [self.stateData count];	// return number of objects in stateData
}

//---------------------------------------------------------------------
// put values into the dictionary
//---------------------------------------------------------------------
-(void)setFloatForKey:(NSString*)key value:(float)value
{
	NSNumber* num = [NSNumber numberWithFloat:value];
	[self.stateData setValue:num forKey:key];
	///NSLog(@"setFloatForKey: %@ %g", key, value);
}

-(void)setIntForKey:(NSString*)key value:(int)value
{
	NSNumber* num = [NSNumber numberWithInt:value];
	[self.stateData setValue:num forKey:key];
	///NSLog(@"setIntForKey: %@ %d", key, value);
}

-(void)setObjectForKey:(NSString*)key object:(id)object
{
	[self.stateData setValue:object forKey:key];
	///NSLog(@"setObjectForKey: %@ %@", key, [object class]);
}


//---------------------------------------------------------------------
// return values out of the dictionary
//---------------------------------------------------------------------
-(float)floatForKey:(id)key
{
	NSNumber* tmpNum = [self.stateData objectForKey:key];
	return [tmpNum floatValue];
}

-(int)intForKey:(id)key
{
	NSNumber* tmpNum = [self.stateData objectForKey:key];
	return [tmpNum intValue];
}

-(id)objectForKey:(id)key
{
	return [self.stateData objectForKey:key];
}

@end
