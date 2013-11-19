/*
 Copyright (c) 2013 OpenSourceRF.com.  All right reserved.
 
 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 See the GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <QuartzCore/QuartzCore.h>

#import "AppViewController.h"

@implementation AppViewController

@synthesize rfduino;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:101];  // left-pointing shape
        [backButton setTitle:@"Disconnect" forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(disconnect:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        [[self navigationItem] setLeftBarButtonItem:backItem];
        
        [[self navigationItem] setTitle:@"RFduino Sensor"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    [rfduino setDelegate:self];
    
    UIColor *start = [UIColor colorWithRed:58/255.0 green:108/255.0 blue:183/255.0 alpha:0.15];
    UIColor *stop = [UIColor colorWithRed:58/255.0 green:108/255.0 blue:183/255.0 alpha:0.45];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = [self.view bounds];
    gradient.colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)stop.CGColor, nil];
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    [self readSettings];
    [self updateUI];
    
     NSLog(@"*** AFTER VIEW DID LOAD, self.scale_reversed = %d", self.scale_reversed);
     NSLog(@"*** AFTER VIEW DID LOAD,toggle button: %@", self.toggleButton.titleLabel.text);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnect:(id)sender
{
    NSLog(@"+++ disconnect pressed");

    [rfduino disconnect];
}

-(void) saveSettings {
    
    [[NSUserDefaults standardUserDefaults] setFloat:[self.minSensor.text floatValue] forKey:@"minSensorValue"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.maxSensor.text floatValue] forKey:@"maxSensorValue"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:[self.minScale.text floatValue] forKey:@"minScaleValue"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.maxScale.text floatValue] forKey:@"maxScaleValue"];
    
    [[NSUserDefaults standardUserDefaults] setBool:self.scale_reversed forKey:@"scaleReversed"];
    
}


- (NSString *)  toggleButtonString {
    
    NSLog(@"^^^ I am toggleButtonString, self.scale_reversed = %d", self.scale_reversed);
    
    if (self.scale_reversed) {
        
         NSLog(@"^^^ I am toggleButtonString, and I say REVERSED");
        return @"Reversed";
        
        
    } else {
        
        NSLog(@"^^^ I am toggleButtonString, and I say NORMAL");
        return @"Normal";
        
    }
}

- (void) updateUI {
    
    [self.minSensor setText:[NSString stringWithFormat:@"%.2f", self.minimum_sensor_reading]];
    [self.maxSensor setText:[NSString stringWithFormat:@"%.2f", self.maximum_sensor_reading]];
    
    [self.minScale setText:[NSString stringWithFormat:@"%.2f", self.minimum_scale_reading]];
    [self.maxScale setText:[NSString stringWithFormat:@"%.2f", self.maximum_scale_reading]];
    
    [self.toggleButton setTitle:[self toggleButtonString] forState:UIControlStateNormal];
    
}

- (void) readSettings {
    

    self.minimum_sensor_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"minSensorValue"];
    self.maximum_sensor_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"maxSensorValue"];
    
    self.minimum_scale_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"minScaleValue"];
    self.maximum_scale_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"maxScaleValue"];
    
    self.scale_reversed = [[NSUserDefaults standardUserDefaults] boolForKey:@"scaleReversed"];
    
}

- (void) logSettings {
    
    NSLog(@" ^^^ scale_reversed = %d", self.scale_reversed);
    
}

- (void)didReceive:(NSData *)inputData
{
    NSLog(@"+++ ReceivedRX");
    
    /*
    char c[5] = "Hello";
    unsigned char *p;
    p = (unsigned char *) malloc(sizeof(p));
    *p = 255;
    
    // p = (unsigned char *) malloc(sizeof(p));
    // p = (unsigned char *) malloc(sizeof(p));
    char *sensorData = data(inputData);
     */
    
    NSLog(@"1");
    
    char *theData = data(inputData);
    
    NSLog(@"2");

     NSString *sensorReading = [NSString  stringWithUTF8String:theData];
    
     NSLog(@"2.1");
    
    char theData2 = "foobar";
    
    
    NSLog(@"2.2");

    
    NSLog(@"  strlen(theData2) = %d", (int) strlen(theData2));
    
     NSLog(@"3");
    
   //  NSString *sensorReading = [[NSString alloc] initWithUTF8String:theData2];
    
    NSString *sensorReading2 = [NSString  stringWithUTF8String:theData2];
    
     NSLog(@"4");
    
    // NSString *sensorReading = [NSString stringWithUTF8String:sensorData];
   
    NSLog(@"*** sensorReading = %@", sensorReading);
    //NSString *sensorReading = @"Test";
    
    
    // NSLog(@"Sensor, Normalized, and Scale reading: %.2f, %.2f %.2f", sensorReading, normalizedReading, scaleReading);
    

    
    [self.sensorLabel setText:sensorReading];
    [self.scaleLabel setText:sensorReading];
    
}

- (IBAction)toggle:(id)sender {
    
    self.scale_reversed = !self.scale_reversed;
    [self logSettings];
    [self updateUI];
    NSLog(@"^^^ I am toggle, and I am setting the value for 'scaleReversed' to %d", self.scale_reversed);
    [[NSUserDefaults standardUserDefaults] setBool:self.scale_reversed forKey:@"scaleReversed"];
    
}

- (IBAction) updateSettings:(id)sender {
    
    self.minimum_sensor_reading = [self.minSensor.text floatValue];
    self.maximum_sensor_reading = [self.maxSensor.text floatValue];
    
    self.minimum_scale_reading = [self.minScale.text floatValue];
    self.maximum_scale_reading = [self.maxScale.text floatValue];
    
    [self saveSettings];
    
    [self.view endEditing:YES];
    
}

@end
