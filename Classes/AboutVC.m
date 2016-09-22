//
//  Copyright 2011  U.S. Centers for Disease Control and Prevention
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software 
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "AboutVC.h"
#import "AppManager.h"
#import "EulaViewController.h"

@implementation AboutVC

@synthesize labelVersionInfo, labelBuildInfo, delegate;

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.navigationItem.title = @"Info";
    self.labelVersionInfo.text = [NSString stringWithFormat:@"%@ %@", [self getVersionString], [self getBuildString]];
    

}


- (void)viewDidUnload
{
    labelVersionInfo = nil;
    labelBuildInfo = nil;
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSString *)getVersionString
{
    
    return [NSString stringWithFormat:@"Version %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
}

-(NSString *)getBuildString
{
    return [NSString stringWithFormat:@"Build %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
}

- (IBAction)btnDoneTouchUp:(id)sender {
    
    [delegate didDismissModalView];

}

- (IBAction)btnTakeSurveyTouchUp:(id)sender {
    
    DebugLog(@"User hit Take Survey from About View.");
    NSURL *url = [NSURL URLWithString:@"http://www.surveygizmo.com/s3/620161/PTT-Advisor-Survey-Test"];
    [[UIApplication sharedApplication] openURL:url];
    
}


- (void)presentEulaModalView
{
    
    // Create the modal view controller
    EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
	eulaVC.delegate = self;
	eulaVC.modalPresentationStyle = UIModalPresentationPageSheet;
	[self presentModalViewController:eulaVC animated:YES];
    
    // Clean up resources
    
}

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)btnReadEulaTouchUp:(id)sender {
    
    [self presentEulaModalView];
}
     


@end
