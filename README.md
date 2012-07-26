magic-clock-iphone
==================
www.magicclock.de


In order for your iPhone app to send location updates to your server and thus to your Magic Clock, you have to change a couple of things in the code.

In ViewController.m:

- (void)sendLocationToServer:(CLLocation *)location
and
- (void)sendFakeLocationToServer:(NSString *) location

replace XXXXX with your URL to send locations to your server.


In LocationPickerViewController.m:
- (IBAction)homePressed
update the strings with the strings that your server expects from the mobile apps.