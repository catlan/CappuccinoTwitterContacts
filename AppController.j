/*
 * AppController.j
 * NewApplication
 *
 * Created by You on April 9, 2010.
 * Copyright 2010, Your Company All rights reserved.
 */

@import <Foundation/CPObject.j>

@import <LPKit/LPKit.j>
@import "CPALoginViewController.j"
@import "CPAConctactsViewController.j"

@implementation AppController : CPObject
{
    CPWindow theWindow;
    CPView contentView;
    CPALoginViewController loginViewController;
    CPALoginViewController conctactsViewController;
}

- (void)applicationDidFinishLaunching:(CPNotification)aNotification
{
    theWindow = [[CPWindow alloc] initWithContentRect:CGRectMakeZero() styleMask:CPBorderlessBridgeWindowMask];
    contentView = [theWindow contentView];
    
    var screenname = [[LPCookieController sharedCookieController] valueForKey:@"screenname"];
    if (screenname) {
        conctactsViewController = [[CPAConctactsViewController alloc] initWithScreenname:screenname];

        [[conctactsViewController view] setFrame:[contentView bounds]];
        [contentView addSubview:[conctactsViewController view]];
        
        [conctactsViewController loadContacts];
    }
    else
    {
        loginViewController = [[CPALoginViewController alloc] init];

        [[loginViewController view] setFrame:[contentView bounds]];
        [contentView addSubview:[loginViewController view]];
    }

    [theWindow orderFront:self];
    
    // Replace default Menu with an empty one so that 
    // the default New Item doesn't catch CMD+N
    var _mainMenu = [[CPMenu alloc] initWithTitle:@"MainMenu"];
    [[CPApplication sharedApplication] setMainMenu:_mainMenu];

    // Uncomment the following line to turn on the standard menu bar.
    //[CPMenu setMenuBarVisible:YES];
}

- (void)applicationDidFinishLogin:(CPString)screenname
{
    conctactsViewController = [[CPAConctactsViewController alloc] initWithScreenname:screenname];

    [[conctactsViewController view] setFrame:[contentView bounds]];
    [contentView addSubview:[conctactsViewController view]];
    
    var animation = [[CPViewAnimation alloc] initWithViewAnimations:[
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:[loginViewController view], 
			CPViewAnimationEffectKey:CPViewAnimationFadeOutEffect
		}],
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:[conctactsViewController view], 
			CPViewAnimationEffectKey:CPViewAnimationFadeInEffect
		}]
	]];
	[animation setAnimationCurve:CPAnimationLinear];
	[animation setDuration:0.5];
	[animation startAnimation];
	
    [[loginViewController view] removeFromSuperview];
    loginViewController = nil;
    
    [conctactsViewController loadContacts];
}

- (void)applicationDidFinishLogout
{   
    loginViewController = [[CPALoginViewController alloc] init];

    [[loginViewController view] setFrame:[contentView bounds]];
    [contentView addSubview:[loginViewController view]];
    
    var animation = [[CPViewAnimation alloc] initWithViewAnimations:[
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:[conctactsViewController view], 
			CPViewAnimationEffectKey:CPViewAnimationFadeOutEffect
		}],
		[CPDictionary dictionaryWithJSObject:{
			CPViewAnimationTargetKey:[loginViewController view], 
			CPViewAnimationEffectKey:CPViewAnimationFadeInEffect
		}]
	]];
	[animation setAnimationCurve:CPAnimationLinear];
	[animation setDuration:0.5];
	[animation startAnimation];
        
    [[conctactsViewController view] removeFromSuperview];
    conctactsViewController = nil;
}

@end
