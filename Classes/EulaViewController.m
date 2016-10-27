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

#import "EulaViewController.h"
#import "AppManager.h"

@implementation EulaViewController
@synthesize btnAgree;

@synthesize webView;

AppManager *appMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        

    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    appMgr = [AppManager singletonAppManager];

    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"neweula"
                                                     ofType:@"html"];    
    
    NSString *html = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    // Custom initialization
    webView.backgroundColor = [UIColor whiteColor];
   [self.webView loadHTMLString:html baseURL:nil];
    self.webView.delegate = self;
    
    if (appMgr.agreedWithEula == TRUE) {
        btnAgree.title = @"Done";
    }
    

}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnDeclineTouchUp:(id)sender 
{
    appMgr.agreedWithEula = FALSE;

}

- (IBAction)btnAcceptTouchUp:(id)sender 
{

    appMgr.agreedWithEula = TRUE;

}

@end
