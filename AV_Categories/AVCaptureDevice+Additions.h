//
//  AVCaptureDevice.h
//  GM_Utilities
//
//  Created by Gary Morris on 12/1/14.
//  Copyright (c) 2014 Gary Morris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AVCaptureDevice (Additions)

// starts flashes the torch (LED) the number of flashes specified
// (flashing is done asynchronously)
//
+ (void)flashTorch:(unsigned)flashCount;

@end
