//
//  LocationPickerViewController.m
//  MagicClock
//
//  Created by Fabius Steinberger on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationPickerViewController.h"

@interface LocationPickerViewController ()

@end

@implementation LocationPickerViewController
@synthesize viewController;

// let view controller send fake location to server
- (void)sendFakeLocationToServer:(NSString *) location {
    [viewController sendFakeLocationToServer:location];
}


// update the strings with the strings that your server expects from the mobile apps.
// fake locations
- (IBAction)homePressed {
    [self sendFakeLocationToServer:@"home"];
}

- (IBAction)workPressed {
    [self sendFakeLocationToServer:@"work"];
}

- (IBAction)partyPressed {
    [self sendFakeLocationToServer:@"feiern"];
}

- (IBAction)relaxPressed {
    [self sendFakeLocationToServer:@"chillen"];
}

- (IBAction)sportPressed {
    [self sendFakeLocationToServer:@"sport"];
}

- (IBAction)onTheWayPressed {
    [self sendFakeLocationToServer:@"unterwegs"];
}

- (IBAction)universityPressed {
    [self sendFakeLocationToServer:@"uni"];
}

- (IBAction)prisonPressed {
    [self sendFakeLocationToServer:@"prison"];
}

- (IBAction)travelPressed {
    [self sendFakeLocationToServer:@"aufreisen"];
}

- (IBAction)lunchPressed {
    [self sendFakeLocationToServer:@"essen"];
}

- (IBAction)hospitalPressed {
    [self sendFakeLocationToServer:@"krankenhaus"];
}

- (IBAction)lostPressed {
    [self sendFakeLocationToServer:@"aufreisen"];
}







- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
