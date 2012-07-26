//
//  AppDelegate.m
//  MagicClock
//
//  Created by Fabius Steinberger on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController;
@synthesize notification;

// init stuff
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // set property
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.viewController = (ViewController*) [mainStoryboard instantiateViewControllerWithIdentifier: @"mainview"];  
    
    // init notification
    notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    return YES;
}

// set location monitoring
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // in background
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        // disable significant, enable precise monitoring if tracking enabled
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"trackingEnabled"]) {
            [viewController.locationManagerBackground stopMonitoringSignificantLocationChanges];
            [viewController.locationManagerBackground startUpdatingLocation];
            [self showNotification:@"App did become active in background, startUpdatingLocation"];
            NSLog(@"%s startUpdatingLocation", __PRETTY_FUNCTION__);
        }
    }
    // in foreground 
    else {
        [viewController.locationManagerBackground stopMonitoringSignificantLocationChanges];
        [viewController.locationManagerForeground startUpdatingLocation];
    }
    

}


//  set location monitoring.
// uncomment line if you only want cell tower positioning when app is in background. (even if app is in background and hasn't been terminated by the OS)
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [viewController.locationManagerForeground stopUpdatingLocation];
    [viewController.locationManagerBackground stopUpdatingLocation];
//    viewController.locationManagerForeground = NULL; // uncomment this if you only want cell tower positioning
    NSLog(@"%s stopUpdatingLocation (both)", __PRETTY_FUNCTION__);
    
    bool trackingEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:@"trackingEnabled"];
    
    // start background monitoring if tracking enabled
    if(trackingEnabled) {
        [viewController.locationManagerBackground startMonitoringSignificantLocationChanges];
        NSLog(@"%s locationManagerBackground", __PRETTY_FUNCTION__);
    } else {
        NSLog(@"%s No location monitoring because user didn't enable it", __PRETTY_FUNCTION__);
    }
}


- (void)showNotification:(NSString *) message {
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}


- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
