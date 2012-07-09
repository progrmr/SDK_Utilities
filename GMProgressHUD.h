//
//  GMProgressHUD.h
//  NextSprinter
//
//  Created by Gary Morris on 7/28/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GMProgressHUD : UIView {
    
    UILabel* msgLabel;
    UIProgressView* progressView;
    UIActivityIndicatorView* activityView;
    
    CGSize messageSize;
    
}

+(GMProgressHUD*)showHUDWithMessage:(NSString*)newMessage showProgress:(BOOL)useProgressView;

-(id)initWithMessage:(NSString*)newMessage showProgress:(BOOL)useProgressView;

-(void)show;       // display the progress view above the window
-(void)dismiss;    // remove the view from the window

@property (nonatomic, readonly, getter=isVisible) BOOL visible;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, assign) float progress;

@end
