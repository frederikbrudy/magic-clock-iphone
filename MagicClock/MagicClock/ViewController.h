//
//  ViewController.h
//  MagicClock
//
//  Created by Fabius Steinberger on 24.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate>

// UI elements
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UISwitch *trackingSwitch;
@property (weak, nonatomic) IBOutlet UILabel *latLabel;
@property (weak, nonatomic) IBOutlet UILabel *longLabel;
@property (weak, nonatomic) IBOutlet UIButton *fakeLocationButton;

// properties
@property (strong, nonatomic) CLLocationManager *locationManagerForeground;
@property (strong, nonatomic) CLLocationManager *locationManagerBackground;
@property (strong, nonatomic) UILocalNotification *notification;
@property (strong, nonatomic) CLLocation *latestLocation;

// UI methods
- (IBAction)nameSaved:(id)sender;
- (IBAction)trackingSwitched:(id)sender;
- (void)updateLabels;

// methods
- (void)showNotification:(NSString *) message;
- (void)sendLocationToServer:(CLLocation *) location;
- (void)sendFakeLocationToServer:(NSString *) location;

@end
