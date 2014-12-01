//
//  AVCaptureDevice.m
//  GM_Utilities
//
//  Created by Gary Morris on 12/1/14.
//  Copyright (c) 2014 Gary Morris. All rights reserved.
//

#import "AVCaptureDevice+Additions.h"
#import <UIKit/UIKit.h>

enum {
    kFlashDurationMillisec  = 50,           // length of time flash (torch) is on
    kFlashIntervalMillisec  = 150,          // time interval between flashes

    MILLISEC_PER_SECOND     = 1000,
    NANOS_PER_MILLISEC      = 1000000,
};


@implementation AVCaptureDevice(Additions)

// sleeps the current thread for specified number of milliseconds
void MilliSleep(unsigned milliseconds)
{
    struct timespec timeDelay = {0};
    timeDelay.tv_sec  = milliseconds / MILLISEC_PER_SECOND;
    timeDelay.tv_nsec = (milliseconds % MILLISEC_PER_SECOND) * NANOS_PER_MILLISEC;
    nanosleep(&timeDelay, NULL);
}

// turns torch (LED) on or off on the specified AVCaptureDevice
void SetTorch(AVCaptureDevice* device, BOOL torchOn)
{
    [device lockForConfiguration:nil];
    [device setTorchMode:torchOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

+ (void)flashTorch:(unsigned)flashCount
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    if ([device hasTorch]) {
        __block UIBackgroundTaskIdentifier taskID = UIBackgroundTaskInvalid;

        // start a background task to make sure we complete this, otherwise torch
        // could get left in the on state
        taskID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            SetTorch(device, NO);       // make sure torch is off

            if (taskID != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:taskID];
                taskID = UIBackgroundTaskInvalid;
            }
        }];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            for (unsigned count=0; count<flashCount; count++) {
                SetTorch(device, YES);

                MilliSleep(kFlashDurationMillisec);

                SetTorch(device, NO);

                // pause for the interval time if we have another flash to do
                if (count < flashCount-1) {
                    MilliSleep(kFlashIntervalMillisec);
                }
            }

            if (taskID != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:taskID];
                taskID = UIBackgroundTaskInvalid;
            }
        });
    }
}

@end
