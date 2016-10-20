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

#import "FootnoteVC.h"
#import "AppManager.h"
#import "DTNode.h"
#import "TableViewHelper.h"

@implementation FootnoteVC

@synthesize tvFootnotes, imageView, currNode;

AppManager *appMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    // Do any additional setup after loading the view from its nib.
    [self.tvFootnotes setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
    self.tvFootnotes.delegate = self;
    appMgr = [AppManager singletonAppManager];
    self.currNode = appMgr.dc.visitedNodes.currNode;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *currCellText = [self footnoteTextForRow:indexPath];
    
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [TableViewHelper text:currCellText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] constrainedToSize:constraintSize];
    
    return labelSize.height + 16;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [self.currNode getFootnoteCount];
    } else
        return 1;
    
}

-(NSString *)footnoteTextForRow:(NSIndexPath *)indexPath
{
    
    NSString *footnoteText = nil;
    int footnoteId;

    footnoteId = [self.currNode getFootnoteIdAtIndex:indexPath.row];

    if ([appMgr isDebugInfoEnabled]) {
        footnoteText = [self.currNode.myTree getFootnoteAtIndex:footnoteId-1];
        footnoteText = [NSString stringWithFormat:@"%d. %@", footnoteId, footnoteText]; 
    } else {
        footnoteText = [self.currNode.myTree getFootnoteAtIndex:footnoteId-1];
        
    }
    
    return footnoteText;
   
}

//
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *CellIdentifier = @"FootnoteCell";
    
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
		//[cell.textLabel setFont:appMgr.tableFont];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        
    }
    
    // Get the object to display and set the value in the cell.
    // get the footnote
    cell.textLabel.text = [self footnoteTextForRow:indexPath]; 
	
	cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel sizeToFit];
    
	return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1]];
}


- (IBAction)btnDoneTouchUp:(id)sender {
    
    
}

@end
