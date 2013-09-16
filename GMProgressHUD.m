//
//  GMProgressHUD.m
//  NextSprinter
//
//  Created by Gary Morris on 7/28/11.
//  Copyright 2011 Gary A. Morris. All rights reserved.
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

#import "GMProgressHUD.h"
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "UtilitiesUI.h"
#import "AppDelegate_iPhone.h"

@implementation GMProgressHUD

@dynamic visible;
@dynamic progress;
@dynamic message;

#define kFadeInOutDuration (0.3)
#define kDisplayAlpha (0.6)

#define kSpacer (12)
#define kProgressBarWidth (180)
#define kProgressBarHeight (20)
#define kActivityIndicatorWidth  (20)
#define kActivityIndicatorHeight (20)

-(void)dealloc
{
    [msgLabel     release];
    [progressView release];
    [activityView release];
    [super dealloc];
}

-(CGSize)sizeThatFits:(CGSize)oldSize
{
    // size the msgView frame
    CGSize size = CGSizeMake(kSpacer*2, kSpacer*2); // start with spacers
    
    if (activityView) {
        size.width  += kSpacer + MAX(messageSize.width,  kActivityIndicatorWidth);
        size.height += kSpacer + messageSize.height + kActivityIndicatorHeight;
    } else if (progressView) {
        size.width  += kSpacer + MAX(messageSize.width,  kProgressBarWidth);
        size.height += kSpacer + messageSize.height + kProgressBarHeight;
    } else {
        size.width  += messageSize.width;
        size.height += messageSize.height;
    }
    return size;
}

-(void)layoutSubviews
{
    CGSize viewSize = self.bounds.size;

    msgLabel.frame = CGRectMake((viewSize.width-messageSize.width)/2, kSpacer, messageSize.width, messageSize.height); 
    
    if (activityView) {
        activityView.frame = CGRectMake((viewSize.width-kActivityIndicatorWidth)/2, 
                                        (viewSize.height-kActivityIndicatorHeight)-kSpacer, 
                                        kActivityIndicatorWidth, 
                                        kActivityIndicatorHeight);
        
    } else if (progressView) {
        progressView.frame = CGRectMake((viewSize.width-kProgressBarWidth)/2, 
                                        (viewSize.height-kProgressBarHeight)-kSpacer, 
                                        kProgressBarWidth, 
                                        kProgressBarHeight);
    }
}

-(id)initWithMessage:(NSString*)newMessage showProgress:(BOOL)useProgressView
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:kDisplayAlpha];
        self.autoresizesSubviews = YES;
        self.layer.cornerRadius = 10;
        
        // create the label for the message
        msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        msgLabel.backgroundColor = [UIColor clearColor];
        msgLabel.textColor       = [UIColor whiteColor];
        msgLabel.font            = [UIFont systemFontOfSize:14];
        msgLabel.textAlignment   = UITextAlignmentCenter;
        msgLabel.clipsToBounds   = NO;
        [self addSubview:msgLabel];

        if (useProgressView) {
            // create the progress bar view
            progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(kSpacer, kSpacer,
                                                                            kProgressBarWidth,
                                                                            kProgressBarHeight)];
            [self addSubview:progressView];
            
        } else {
            // create the activity indicator view
            activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [self addSubview:activityView];
        }
        
        // set the message, which resizes to fit the text
        self.message = newMessage;
    }    
    return self;
}

-(void)show
{
    // add view centered in the window (but up a little from center)
    UIWindow* window = [[AppDelegate_iPhone instance] window];
    CGRect wBounds = window.bounds;
    self.center = CGPointMake(CGRectGetMidX(wBounds), CGRectGetMidY(wBounds) * 0.7f);
    [window addSubview:self];
    
    if (activityView) {
        [activityView startAnimating];
    }
    
    // animate the alpha from 0 to kDisplayAlpha to fade in
    self.alpha = 0;        
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kFadeInOutDuration];
    [UIView setAnimationDelegate:nil];
    self.alpha = 1;
    [UIView commitAnimations];
}

+(GMProgressHUD*)showHUDWithMessage:(NSString*)newMessage showProgress:(BOOL)useProgressView
{
    GMProgressHUD* hud = [[[GMProgressHUD alloc] initWithMessage:newMessage 
                                                showProgress:useProgressView] autorelease];
    [hud show];
    
    return hud;
}

-(void)animationFinished:(NSString*)animationID finished:(BOOL)finished context:(void*)context
{
    [self removeFromSuperview];
}

-(void)dismiss
{
    if (activityView) {
        [activityView stopAnimating];
    }
    
    // remove hud view from the window
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kFadeInOutDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    self.alpha = 0;
    [UIView commitAnimations];
}

-(void)setMessage:(NSString *)newMessage
{
    msgLabel.text = newMessage;
    messageSize = [newMessage sizeWithFont:msgLabel.font];
    
    // resize the view to fit
    CGRect bounds = self.bounds;
    bounds.size = [self sizeThatFits:bounds.size];
    self.bounds = bounds;

    [self setNeedsLayout];
    DLog(@"msg=\"%@\", size=%@, bounds=%@", newMessage, NSStringFromCGSize(messageSize), NSStringFromCGSize(bounds.size));
}

-(NSString*)message
{
    return msgLabel.text;
}

-(void)setProgress:(float)newProgress
{
    progressView.progress = newProgress;
}

-(float)progress
{
    return progressView.progress;
}

-(BOOL)isVisible
{
    return self.window != nil;
}

@end
