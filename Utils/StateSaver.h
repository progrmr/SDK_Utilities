//
//  StateSaver.h
//
//  Created by Gary Morris on 9/21/09.
//  Copyright 2009 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>

//--------------------------------------------------------------------------
// StateSaver will store the contents of the dictionary to a file on app 
// exit and reread the contents when the app loads.  Data stored here is 
// non-volatile and persists across app invocations.  You can have multiple
// StateSaver objects but they must each have a unique filename by calling
// initWithFile when they are created.
//
// Note: data will not get written out if StateSaver object is deallocated
//       before the app terminates.
//--------------------------------------------------------------------------

@interface StateSaver : NSObject {
	NSString* fullPathname;			// full path filename to use to save data
	NSMutableDictionary* stateData;	// state data saved here, by key
}

//----------------------------------------------------------------
// init class - reads from StateData.xml, file will be created if
// needed in the app's documents folder
//----------------------------------------------------------------
-(id)init;

//----------------------------------------------------------------
// init class - reads from specified file, file will be created if
// needed in the app's documents folder
//----------------------------------------------------------------
-(id)initWithFile:(NSString*)filename;		// filename only, no path

//----------------------------------------------------------------
// saveDataToFile: - forces a save of state data to the file, 
// notification parameter is not used, may be nil
//----------------------------------------------------------------
-(void)saveDataToFile:(NSNotification*)notification;

- (void)synchronize;

//----------------------------------------------------------------
// Count of items in dictionary, if count is 0 after init then
// file was not read in and you should set your default values.
//----------------------------------------------------------------
-(NSUInteger)count;					// number of objects in dictionary

//---------------------------------------------------------------------
// put values into the dictionary
//---------------------------------------------------------------------
-(void)setFloatForKey:(NSString*)key  value:(float)value;
-(void)setIntForKey:(NSString*)key    value:(int)value;

- (void)setObject:(id)value forKey:(NSString *)key;

//---------------------------------------------------------------------
// return values out of the dictionary
//---------------------------------------------------------------------
-(float)floatForKey:(id)key;
-(int)intForKey:(id)key;
-(id)objectForKey:(id)key;		// returns nil if not in dictionary

@property (nonatomic, retain) NSMutableDictionary* stateData;
@property (nonatomic, readonly) NSString* fullPathname;

@end
