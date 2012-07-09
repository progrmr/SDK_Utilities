//
//  GMObject.h
//  NextSprinter
//
//  Created by Gary Morris on 8/23/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GMObject : NSObject {
    
#ifdef DEBUG
    int32_t myRetainCount;
#endif
    
}

@end
