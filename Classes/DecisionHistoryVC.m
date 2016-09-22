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

#import "DecisionHistoryVC.h"
#import "DTNode.h"
#import "DTConnector.h"
#import "AppManager.h"
#import "ReviewCell.h"

#define HEADER_HEIGHT 38.0

@implementation DecisionHistoryVC

@synthesize tvVisitedNodes, delegate, imageView;

AppManager *appMgr;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        appMgr = [AppManager singletonAppManager];
        
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
    [self.tvVisitedNodes reloadData];    
    
    //
    // Change the properties of the imageView and tableView (these could be set
    // in interface builder instead).
    //
    tvVisitedNodes.separatorStyle = UITableViewCellSeparatorStyleNone;
    tvVisitedNodes.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"background.png"];
    
    
}

- (void)viewDidUnload
{
    tvVisitedNodes = nil;
    imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [tvVisitedNodes reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    
}


#pragma mark -
#pragma mark Table view data source

//
// Create a header view. Wrap it in a container to allow us to position
// it better.
//
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    // create the parent view that will hold header Label
	UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, HEADER_HEIGHT)];
	
	// create the button object
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.shadowColor = [UIColor blackColor];
    headerLabel.shadowOffset = CGSizeMake(0, 1);
	headerLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0f];;
	headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, HEADER_HEIGHT);
    
    if (section == 0) 
        headerLabel.text = NSLocalizedString(@"Completed Steps", @"");
    else {
        if ([appMgr.dc.visitedNodes isAtLastNode])
            headerLabel.text = NSLocalizedString(@"Recommendation", @"");
        else
            headerLabel.text = NSLocalizedString(@"Current Step", @"");
        
    }
    
    [customView addSubview:headerLabel];
    return customView;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [appMgr.dc.visitedNodes getNodeCount] - 1;
    } else
        return 1;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [ReviewCell heightForReviewCellAtIndexPath:indexPath];
}

//
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DTNode *nodeAtRow = nil;
    
    static NSString *CellIdentifier = @"DecisionHistoryReviewCell";

    // set the DTNode
    if (indexPath.section == 0) 
        nodeAtRow = [appMgr.dc.visitedNodes getNodeAtIndex:indexPath.row];
    else 
        nodeAtRow = [appMgr.dc.visitedNodes getUnansweredNode];
    
    
    ReviewCell *cell = (ReviewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
        cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    [cell initWithNode:nodeAtRow inTableView:tvVisitedNodes atIndexPath:indexPath];
    
    return cell;

}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) 
        [appMgr.dc.visitedNodes goToNodeAtIndex:indexPath.row];
    else
        [appMgr.dc.visitedNodes getUnansweredNode];
    
    [delegate didDismissModalView];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)btnDoneTouchUp:(id)sender {
    
    
	DebugLog(@"Evaluation Review Modal View Done button hit");
	[delegate didDismissModalView];
    
}
@end
