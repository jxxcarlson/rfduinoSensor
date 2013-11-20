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

@synthesize rfduino, labelArray;

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
    
    self.labelArray = @[self.sensorLabel0, self.sensorLabel1, self.sensorLabel2, self.sensorLabel3, self.sensorLabel4, self.sensorLabel5, self.sensorLabel6];
    
    for (UILabel *label in self.labelArray) {
        
        label.text = @"";
    }
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


- (NSString *) temperatureString: (NSString *) dataString {
    
    float C = [dataString floatValue];
    C = C/10;
    float F = 1.8*C + 32;
    return [NSString stringWithFormat:@"Temp: %1.1f C, %1.1f F", C, F];
    //return [NSString stringWithFormat:@"Temp: %@", dataString];;
    
}

- (NSString *) lightString: (NSString *) dataString {
    
    int L = [dataString integerValue];
    L = 1023 - L;
    L = L - 282;
    L = 100*L/682.0;
    
    return [NSString stringWithFormat:@"Light: %d", L];
    
}

- (NSString *) calibrationString: (NSString *) dataString {
    
    return [NSString stringWithFormat:@"Calibration: %@", dataString];
    
}

- (NSString *) lowPoint: (NSString *) dataString {
    
    return [NSString stringWithFormat:@"Low: %@", dataString];
    
}

- (NSString *) highPoint: (NSString *) dataString {
    
    return [NSString stringWithFormat:@"High: %@", dataString];
    
}


- (void) executeCommand: (unichar) command wthData: (NSString *) dataString {
    

    switch (command) {
            
            
        case 'T':
            
            [self.sensorLabel1 setText:[self temperatureString:dataString]];
            break;
            
        case 'L':
            
            [self.sensorLabel2 setText:[self lightString:dataString]];
            break;
            
        case 'X':
            
            [self.sensorLabel3 setText:[self calibrationString:dataString]];
            break;
            
        case '0':
            
            [self.sensorLabel4 setText:[self lowPoint:dataString]];
            break;
            
        case 'H':
            
            [self.sensorLabel5 setText:[self highPoint:dataString]];
            break;
            
        default:
            break;
    }
    
    
}

- (void)didReceive:(NSData *)inputData
{
    
    NSString *sensorReading = [NSString stringWithUTF8String:[inputData bytes]];
    unichar command = [sensorReading characterAtIndex:0];
    NSString *dataString = [sensorReading substringFromIndex:1];
    
    [self executeCommand:command wthData:dataString];
    
    // NSLog(@"RDX: [%@] => %c, %@", sensorReading, command, dataString);
    
   

}


- (IBAction) updateSettings:(id)sender {
    
    
}

@end
