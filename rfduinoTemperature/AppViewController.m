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
    
    /*
    self.minimum_sensor_reading = MINIMUM_SENSOR_READING;
    self.maximum_sensor_reading = MAXIMUM_SENSOR_READING;
    self.minimum_scale_reading = MINIMUM_SCALE_READING;
    self.maximum_scale_reading = MAXIMUM_SCALE_READING;
    */

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disconnect:(id)sender
{
    NSLog(@"disconnect pressed");

    [rfduino disconnect];
}

-(void) saveSettings {
    
    [[NSUserDefaults standardUserDefaults] setFloat:[self.minSensor.text floatValue] forKey:@"minSensorValue"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.maxSensor.text floatValue] forKey:@"maxSensorValue"];
    
    [[NSUserDefaults standardUserDefaults] setFloat:[self.minScale.text floatValue] forKey:@"minScaleValue"];
    [[NSUserDefaults standardUserDefaults] setFloat:[self.maxScale.text floatValue] forKey:@"maxScaleValue"];
    
}

- (void) readSettings {
    
    self.minimum_sensor_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"minSensorValue"];
    self.maximum_sensor_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"maxSensorValue"];
    
    self.minimum_scale_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"minScaleValue"];
    self.maximum_scale_reading = [[NSUserDefaults standardUserDefaults] floatForKey:@"maxScaleValue"];
    
    [self.minSensor setText:[NSString stringWithFormat:@"%.2f", self.minimum_sensor_reading]];
    [self.maxSensor setText:[NSString stringWithFormat:@"%.2f", self.maximum_sensor_reading]];
    
    [self.minScale setText:[NSString stringWithFormat:@"%.2f", self.minimum_scale_reading]];
    [self.maxScale setText:[NSString stringWithFormat:@"%.2f", self.maximum_scale_reading]];
    
}

- (void)didReceive:(NSData *)data
{
    NSLog(@"ReceivedRX");
    
    float sensorReading = dataFloat(data);
    
    // Value betwen o and 1
    float normalizedReading = (sensorReading - self.minimum_sensor_reading)/(self.maximum_sensor_reading - self.minimum_sensor_reading);
    
    // Transform
    normalizedReading = 1 - normalizedReading;
    
    
    float scaleReading = (self.maximum_scale_reading - self.minimum_scale_reading)*normalizedReading + self.minimum_scale_reading;
    
    NSLog(@"Sensor, Normalized, and Scale reading: %.2f, %.2f %.2f", sensorReading, normalizedReading, scaleReading);
    
    NSString* string1 = [NSString stringWithFormat:@"Sensor: %.2f", sensorReading];
    NSString* string2 = [NSString stringWithFormat:@"Scale: %.2f", scaleReading];
    
    [self.sensorLabel setText:string1];
    [self.scaleLabel setText:string2];
    
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
