//
//  LocationPickerViewController.h
//  MagicClock
//
//  Created by Fabius Steinberger on 12.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface LocationPickerViewController : UIViewController

// main view controller
@property (strong, nonatomic) ViewController *viewController;

// UI methods
- (IBAction)homePressed;
- (IBAction)workPressed;
- (IBAction)partyPressed;
- (IBAction)relaxPressed;


@end
