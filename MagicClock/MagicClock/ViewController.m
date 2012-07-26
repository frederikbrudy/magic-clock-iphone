//
//  ViewController.m
//  MagicClock
//
//  Created by Fabius Steinberger on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationPickerViewController.h"


@implementation ViewController

@synthesize nameTextField;
@synthesize saveButton;
@synthesize trackingSwitch;
@synthesize latLabel;
@synthesize longLabel;
@synthesize fakeLocationButton;
@synthesize notification;
@synthesize locationManagerForeground;
@synthesize locationManagerBackground;
@synthesize latestLocation;


#pragma mark - Location --------------------------------------------------------------------

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    latestLocation = newLocation;
    
    
// uncomment these lines if you want to receive notifications about which location manager was responsible for receiving the lastest location. (this is interesting if since you can't test significantUpdateChanges (cell tower changes) with XCode.)    
//    if (manager == locationManagerBackground) {
//        NSLog(@"%s locationManagerBackground", __PRETTY_FUNCTION__);
//        [self showNotification:@"didUpdateToLocation with locationManagerBackground"];
//    }
//    else if (manager == locationManagerForeground) {
//        NSLog(@"%s locationManagerForeground", __PRETTY_FUNCTION__);
//        [self showNotification:@"didUpdateToLocation with locationManagerForeground"];
//    }
//    else if (locationManagerForeground == locationManagerForeground) {
//        NSLog(@"%s LOCATION MANAGERS ARE SAME", __PRETTY_FUNCTION__);
//        [self showNotification:@"LOCATION MANAGERS ARE SAME"];
//    }
//    else {
//        NSLog(@"%s neithernor location manager", __PRETTY_FUNCTION__);
//        [self showNotification:@"didUpdateToLocation with unknown location manager"];
//    }
    
    
    // background
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSLog(@"%s in background", __PRETTY_FUNCTION__);
        
        // start background task
        __block UIBackgroundTaskIdentifier backgroundTask;
        backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask]; 
        }];
        
        // send new location to server
        [self sendLocationToServer:newLocation];
        
        // stop precise, start significant background location monitoring
        [locationManagerForeground stopUpdatingLocation];
        [locationManagerBackground stopUpdatingLocation];
        [locationManagerBackground startMonitoringSignificantLocationChanges];
//        NSLog(@"%s in background: stopUpdatingLocation (both)", __PRETTY_FUNCTION__);
        
        // end background task
        if (backgroundTask != UIBackgroundTaskInvalid) {
            [[UIApplication sharedApplication] endBackgroundTask:backgroundTask];
            backgroundTask = UIBackgroundTaskInvalid;
        }
    }
    
    // foreground
    else {
        NSLog(@"%s in foreground", __PRETTY_FUNCTION__);
        // send new location to server
        [self updateLabels];
        [self sendLocationToServer:newLocation];
    }
}

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


// replace XXXXX with your URL to send locations to your server
- (void)sendLocationToServer:(CLLocation *)location {
        
    // create request url
    NSString *baseUrl = [NSString stringWithFormat:@"http://XXXXX.de/rest/updateLocation?"];
    NSString *lon = [NSString stringWithFormat:@"lon=%f", location.coordinate.longitude];
    NSString *lat = [NSString stringWithFormat:@"&lat=%f", location.coordinate.latitude];
    NSString *key = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@&key=%@", baseUrl, lon, lat, key];
    NSLog(@"%s urlString: %@", __PRETTY_FUNCTION__, urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%s error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }
    
    // response
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
    NSLog(@"%s server response: %@", __PRETTY_FUNCTION__, responseString);
    
    
    if ([responseString isEqualToString:@"0"]) {
        NSLog(@"%s Location was sent to server.", __PRETTY_FUNCTION__);
        [self showNotification:@"Location was sent to server"];
        
    }
    else if ([responseString isEqualToString:@"1"]) {
        NSLog(@"%s Location was NOT sent to server.", __PRETTY_FUNCTION__);
        [self showNotification:@"Location was NOT sent to's server"];
    }
    else {
        NSLog(@"%s Location was NOT sent", __PRETTY_FUNCTION__);
        [self showNotification:@"Location was NOT sent to server"];
    }

}


#pragma mark - User input --------------------------------------------------------------------

- (IBAction)trackingSwitched:(id)sender {
    
    // save
    [[NSUserDefaults standardUserDefaults] setBool:trackingSwitch.on forKey:@"trackingEnabled"];
    
    // On
    if (trackingSwitch.on) {        
        [locationManagerForeground startUpdatingLocation];
        NSLog(@"%s Started location monitoring", __PRETTY_FUNCTION__);

    }
    // Off
    else {        
        [locationManagerForeground stopUpdatingLocation];
        [locationManagerBackground stopMonitoringSignificantLocationChanges];
        NSLog(@"%s Stopped location monitoring", __PRETTY_FUNCTION__);
    }
    
    [self updateLabels];
}

- (void)handleNameInput {
    // dismiss keyboard and save
    [nameTextField resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setObject:nameTextField.text forKey:@"name"];
    NSLog(@"%s Name saved: %@", __PRETTY_FUNCTION__, [[NSUserDefaults standardUserDefaults] stringForKey:@"name"]);
}

- (IBAction)nameSaved:(id)sender {
    [self handleNameInput];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self handleNameInput];

    return YES;
}

// replace XXXXX with your URL to send locations to your server.
// disable automatic location tracking and send fake location to server
- (void)sendFakeLocationToServer:(NSString *) location {
    // disable tracking
    [self.locationManagerForeground stopUpdatingLocation];
    [self.locationManagerBackground stopUpdatingLocation];
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"trackingEnabled"];
    [self updateLabels];
    
    // send fake location to server
    // create request url (CLAUDIUS SERVER)
    NSString *baseUrl = [NSString stringWithFormat:@"http://XXXXX.de/rest/updateLocation?"];
    NSString *key = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    NSString *urlString = [NSString stringWithFormat:@"%@location=%@&key=%@", baseUrl, location, key];
    NSLog(@"%s urlString: %@", __PRETTY_FUNCTION__, urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    // Send a synchronous request to the server (i.e. sit and wait for the response)
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if an error occurred    
    if (error != nil) {
        NSLog(@"%s error: %@", __PRETTY_FUNCTION__, [error localizedDescription]);
    }
    
    // response
    NSString *responseString = [[NSString alloc] initWithData:responseData  encoding:NSUTF8StringEncoding];
    NSLog(@"%s server response: %@", __PRETTY_FUNCTION__, responseString);
    
    
    if ([responseString isEqualToString:@"0"]) {
        NSLog(@"%s Fake location was sent to server.", __PRETTY_FUNCTION__);
        [self showNotification:@"Fake location was sent to server"];
        
    }
    else if ([responseString isEqualToString:@"1"]) {
        NSLog(@"%s Fake location was NOT sent to server.", __PRETTY_FUNCTION__);
        [self showNotification:@"Fake location was NOT sent to server"];
    }
    else {
        NSLog(@"%s Fake location was NOT sent", __PRETTY_FUNCTION__);
        [self showNotification:@"Fake location was NOT sent to server"];
    }
}


#pragma mark - View lifecycle --------------------------------------------------------------------

- (void)showNotification:(NSString *) message {
    notification.alertBody = message;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)updateLabels {    
    // lat, long labels
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"trackingEnabled"]) {
        self.latLabel.text = @"";
        self.longLabel.text = @"";
    } else {
        self.longLabel.text = [NSString stringWithFormat:@"Latitude: %f", latestLocation.coordinate.latitude];
        self.latLabel.text = [NSString stringWithFormat:@"Longitude: %f", latestLocation.coordinate.longitude];
    }

    // name textfield
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"name"] isEqualToString:@""]) {
        nameTextField.text = @"Enter your name";
    }
    else {
        nameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"name"];
    }
    
    // tracking switch
    trackingSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"trackingEnabled"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateLabels];
    [nameTextField setDelegate:self];
    
    // location manager
    locationManagerForeground = [[CLLocationManager alloc] init];
    [locationManagerForeground setDelegate:self];
    [locationManagerForeground setDesiredAccuracy:kCLLocationAccuracyBest];
    [locationManagerForeground setDistanceFilter: 500]; 
    
    locationManagerBackground = [[CLLocationManager alloc] init];
    [locationManagerBackground setDelegate:self];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"trackingEnabled"]) {
        [locationManagerForeground startUpdatingLocation];
    }

    
    // init notification TODO: in app delegate
    notification = [[UILocalNotification alloc] init];
    notification.soundName = UILocalNotificationDefaultSoundName;
}

- (void)viewDidUnload
{
    [self setNameTextField:nil];
    [self setSaveButton:nil];
    [self setTrackingSwitch:nil];
    [self setLatLabel:nil];
    [self setLongLabel:nil];
    [self setFakeLocationButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// set property in location picker view controller
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    LocationPickerViewController *locationPicker = (LocationPickerViewController *) [segue destinationViewController];
    locationPicker.viewController = self;
}



@end
