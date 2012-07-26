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




____
MagicClock, a clock that displays people's locations
Copyright (C) 2012 www.magicclock.de

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

You can contact the authors via authors@magicclock.de or www.magicclock.de