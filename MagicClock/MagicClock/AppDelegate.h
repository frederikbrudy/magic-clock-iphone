//
//  AppDelegate.h
//  MagicClock
//
//  Created by Fabius Steinberger on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// main view
@property (strong, nonatomic) ViewController *viewController; 

// notification
@property (strong, nonatomic) UILocalNotification *notification;
- (void)showNotification:(NSString *) message;


@end
