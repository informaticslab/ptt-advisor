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

#import "DecisionVC.h"
#import "DecisionHistoryVC.h"
#import "AppManager.h"
#import "DTNode.h"
#import "VisitedDecisionNodes.h"
#import "EulaViewController.h"
#import "AboutVC.h"
#import "HelpVC.h"
#import "FootnoteVC.h"

#define RESTART_ALERT_VIEW_TAG 1
#define DONE_RESTART_ALERT_VIEW_TAG 2
#define CHANGE_DECISION_ALERT_VIEW_TAG 3

@implementation DecisionVC

AppManager *appMgr;
DTConnector *newChoiceConnector;
BOOL inReviewMode;
VisitedDecisionNodes *visitedNodes;

@synthesize nodeText, toolbarText, btnAnswer1, btnAnswer2, btn1Connector, btn2Connector, btnDone, barBtnItemFootnotes;
@synthesize doneImage, iconImage;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        UIButton *btnInfo =  [UIButton buttonWithType:UIButtonTypeCustom];
        [btnInfo setImage:[UIImage imageNamed:@"orange_i.png"] forState:UIControlStateNormal];
        [btnInfo setFrame:CGRectMake(0, 0, 32, 32)];
        
        //create a UIBarButtonItem with the button as a custom view
        barBtnItemInfo.customView = btnInfo;
        barBtnItemInfo.style = UIBarButtonItemStylePlain;


        UIFont *customFont = [UIFont fontWithName:@"LucidaGrande" size:17];
        nodeText.font = customFont;
        
        appMgr = [AppManager singletonAppManager];

        
    }
    return self;
}

- (void)dealloc
{
    [nodeText release];
    [btnAnswer1 release];
    [btnAnswer2 release];
    [toolbarText release];
    [doneImage release];
    [iconImage release];
    [btnDone release];
    [barBtnBack release];
    [barBtnNext release];
    [barBtnBackToLast release];
    [barBtnRestartEval release];
    [barBtnReviewEval release];
    [lblCurrentPageIndicator release];
    [barBtnItemInfo release];
    [barBtnItemFootnotes release];
    [labelBtn1Tree release];
    [labelBtn1Node release];
    [labelBtn2Tree release];
    [labelBtn2Node release];
    [super dealloc];
}

- (IBAction)btnAnswer1TouchUp:(id)sender {
    
    if ([visitedNodes hasDifferentChosenConnectorForCurrentNode:btn1Connector]) 
        [self changeDecision:btn1Connector];
    else
        [visitedNodes goToNodeUsingConnector:btn1Connector];
    
    [self updateNodeUI];
    
}

- (IBAction)btnAnswer2TouchUp:(id)sender {
    
    if ([visitedNodes hasDifferentChosenConnectorForCurrentNode:btn2Connector]) 
        [self changeDecision:btn2Connector];
    else
        [visitedNodes goToNodeUsingConnector:btn2Connector];
    
    [self updateNodeUI];
    
}

- (IBAction)btnDoneTouchUp:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Patient Evaluation Complete"
                          message: @"Would you like to begin a new patient evaluation?"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Yes",nil];
// No Take Survey Button for now.                         otherButtonTitles:@"New Evaluation",@"Take Survey",nil];
    alert.tag = DONE_RESTART_ALERT_VIEW_TAG;
    
    [alert show];
    [alert release];
    
}

-(void)changeDecision:(DTConnector *)newChoice
{
    
    //NSUInteger answeredQuestions = [visitedNodes getNodeCount] - 1;
    NSUInteger currReviewQuestion = [visitedNodes getCurrentNodeIndex] + 1; 
    
    NSString *warningMessage = [NSString stringWithFormat:@"You are about to change your answer to Step %d. Therefore any previous responses past Step %d will be discarded and you will be presented with new questions and information at Step %d. Would you like to continue?", currReviewQuestion, currReviewQuestion, currReviewQuestion +1];
    
    newChoiceConnector = newChoice;
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Change Decision Warning"
                          message: warningMessage
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    alert.tag = CHANGE_DECISION_ALERT_VIEW_TAG;
    
    [alert show];
    [alert release];
    
}

- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissModalViewControllerAnimated:YES];
    [self updateNodeUI];
    
}

- (IBAction)barBtnBackTouchUp:(id)sender 
{
    [visitedNodes getPreviousNode];
    [self updateNodeUI];
    
}

- (IBAction)barBtnNextTouchUp:(id)sender 
{
    
    [visitedNodes getNextNode];
    [self updateNodeUI];
    

}

- (IBAction)barBtnBackToLastTouchUp:(id)sender {
    
    [visitedNodes getUnansweredNode];
    [self updateNodeUI];
    
}

- (IBAction)barBtnRestartEvalTouchUp:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: @"Restart Patient Evaluation"
                          message: @"Are you sure you want to restart the patient evaluation?"
                          delegate: self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"OK",nil];
    alert.tag = RESTART_ALERT_VIEW_TAG;
    [alert show];
    [alert release];
    
}

- (IBAction)barBtnReviewEvalTouchUp:(id)sender 
{
    
    // Create the modal view controller
    DecisionHistoryVC *viewController = [[DecisionHistoryVC alloc] initWithNibName:@"DecisionHistoryVC" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
	viewController.delegate = self;
	viewController.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentModalViewController:viewController animated:YES];
    
    // Clean up resources
    [viewController release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == CHANGE_DECISION_ALERT_VIEW_TAG) {
        if (buttonIndex == 0) {
            DebugLog(@"User hit Cancel on Change Evaluation Alert View.");
            newChoiceConnector = nil;
        }
        else {
            DebugLog(@"User hit OK on Change Evaluation Alert View.");
            [visitedNodes redoFromCurrentNodeUsingConnector:newChoiceConnector];
            [self updateNodeUI];            
        }
    } else if (alertView.tag == DONE_RESTART_ALERT_VIEW_TAG) {

        if (buttonIndex == 0) {
            DebugLog(@"User hit Cancel on Reset Evaluation Alert View.");
        }
        else if (buttonIndex == 1) {
            DebugLog(@"User hit OK on Reset Evaluation Alert View.");
            [visitedNodes restart];
            [self updateNodeUI];
            
        }
        else if (buttonIndex == 2) {
            DebugLog(@"User hit Survey on Reset Evaluation Alert View.");
            NSURL *url = [NSURL URLWithString:@"http://www.surveygizmo.com/s3/620161/PTT-Advisor-Survey-Test"];
            [[UIApplication sharedApplication] openURL:url];
            [visitedNodes restart];
            [self updateNodeUI];
            
        }
      
        
    } else if (alertView.tag == RESTART_ALERT_VIEW_TAG){
    
        
        if (buttonIndex == 0) {
            DebugLog(@"User hit Cancel on Reset Evaluation Alert View.");
        }
        else {
            DebugLog(@"User hit OK on Reset Evaluation Alert View.");
            [visitedNodes restart];
            [self updateNodeUI];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

- (IBAction)btnInfoTouchUp:(id)sender {
    
    AboutVC *aboutVC = [[AboutVC alloc] initWithNibName:@"AboutView" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
	aboutVC.delegate = self;
	aboutVC.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentModalViewController:aboutVC animated:YES];
    
    // Clean up resources
    [aboutVC release];
    
}

- (IBAction)btnFootnotesTouchUp:(id)sender {
    
    FootnoteVC *footnoteVC = [[FootnoteVC alloc] initWithNibName:@"FootnoteVC" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
	footnoteVC.delegate = self;
	footnoteVC.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentModalViewController:footnoteVC animated:YES];
    
    // Clean up resources
    [footnoteVC release];
 
}


- (IBAction)btnHelpTouchUp:(id)sender {
    
    HelpVC *helpVC = [[HelpVC alloc] initWithNibName:@"HelpVC" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
	helpVC.delegate = self;
	helpVC.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentModalViewController:helpVC animated:YES];
    
    // Clean up resources
    [helpVC release];
    
    
}

-(void)updateNodeUI
{
    DTNode *currNode;
    DTConnector *chosenConnector;
    NSString *debugInfo = nil;

    NSUInteger answerCount;
    BOOL reviewing = ![visitedNodes isAtUnansweredNode];
    
    // update UI using a review node or new node
    currNode = visitedNodes.currNode;
    chosenConnector = visitedNodes.chosenConnector;
    
    [nodeText setText:currNode.bodyText];
    if ([currNode.bodyText length] > 160) 
        nodeText.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    else
        nodeText.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
    
    [btnAnswer1 setHidden:YES];
    [btnAnswer2 setHidden:YES];
    [btnDone setHidden:YES];
    labelBtn1Tree.text = nil;
    labelBtn1Node.text = nil;
    labelBtn2Tree.text = nil;
    labelBtn2Node.text = nil;
    
    // set first decision (connector) button
    answerCount = [currNode.exitConnectors count];
    if (answerCount >= 1) {
        btn1Connector = [currNode.exitConnectors objectAtIndex:0];
        if (reviewing && (btn1Connector == chosenConnector))
            [btnAnswer1 setHighlighted:YES];
        else
            [btnAnswer1 setHighlighted:NO];
        
        [btnAnswer1 setTitle:btn1Connector.text forState:UIControlStateNormal];
        [btnAnswer1 setHidden:NO];


        if ([appMgr isDebugInfoEnabled]) {
            labelBtn1Tree.text = [NSString stringWithFormat:@"Tree %d", btn1Connector.endNode.treeNumber];
            labelBtn1Node.text = [NSString stringWithFormat:@"Node %d", btn1Connector.endNode.nodeNumber];
        }
        
    }
    
    // set second decision (connector) button
    if (answerCount >= 2) {
        btn2Connector = [currNode.exitConnectors objectAtIndex:1];
        if (reviewing && (btn2Connector == chosenConnector))
            [btnAnswer2 setHighlighted:YES];
        else
            [btnAnswer2 setHighlighted:NO];
        
        [btnAnswer2 setTitle:btn2Connector.text forState:UIControlStateNormal];
        [btnAnswer2 setHidden:NO];

        if ([appMgr isDebugInfoEnabled]) {
            labelBtn2Tree.text = [NSString stringWithFormat:@"Tree %d", btn2Connector.endNode.treeNumber];
            labelBtn2Node.text = [NSString stringWithFormat:@"Node %d", btn2Connector.endNode.nodeNumber];
        } 
    }
    
    if ( (answerCount == 0) && ([currNode isLastNode])) {
        [btnDone setHidden:NO];
        
    }
    
    // set icon image
    UIImage *currImage = nil;
    
    if ([currNode isRootNode]) {
        currImage = [UIImage imageNamed: @"to_begin_header.png"];
    } else if ([currNode isLastNode]) {
        currImage = [UIImage imageNamed: @"recommendation_header.png"];
    } else if ([currNode isEvalNode]) {
        currImage = [UIImage imageNamed: @"describe_pt_header.png"];
    } else  {
        currImage = [UIImage imageNamed: @"eval_guide_header.png"];
    }
    
    // should we enable footnotes button
    if ([currNode hasFootnotes])
        barBtnItemFootnotes.enabled = TRUE;
    else
        barBtnItemFootnotes.enabled = FALSE;

    [iconImage setImage:currImage];
    
    self.toolbarText.text = appMgr.dc.currDecisionTree.groupName;
    
    // set page indication label
    if ([appMgr isDebugInfoEnabled]) {
        debugInfo = [NSString stringWithFormat:@"Tree %d, Node %d, Footnotes %@",currNode.nodeId.treeNumber,currNode.nodeId.nodeNumber, [currNode getFootnoteIdsAsDebugInfo]];
        if (reviewing) {
            lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %d, %@",[visitedNodes getCurrentNodeIndex] +1, debugInfo];
        } else {
                lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %d, %@",[visitedNodes getNodeCount], debugInfo];
        }
    } else {
        if (reviewing) 
            lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %d",[visitedNodes getCurrentNodeIndex] +1];
        else 
            lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %d",[visitedNodes getNodeCount]];
    }
    
    // should we enable back button
    if ([visitedNodes hasPreviousNode])
        barBtnBack.enabled = TRUE;
    else
        barBtnBack.enabled = FALSE;
    
    // should we enable next button or jump to last?
    if ([visitedNodes hasNextNode]) {
        barBtnNext.enabled = TRUE;
        barBtnBackToLast.enabled = TRUE;
    } else {
        barBtnNext.enabled = FALSE;
        barBtnBackToLast.enabled = FALSE;
    }

    // should we enable next button or jump?
    if ([visitedNodes isAtFirstNode] && [visitedNodes isAtUnansweredNode] ) {
        barBtnRestartEval.enabled = FALSE;
        barBtnReviewEval.enabled = FALSE;
    } else {
        barBtnRestartEval.enabled = TRUE;
        barBtnReviewEval.enabled = TRUE;
    }
    

}

- (void)presentEulaModalView
{
    
    if (appMgr.agreedWithEula == TRUE)
        return;
    
    // store the data
    NSDictionary *appInfo = [[NSBundle mainBundle] infoDictionary];
    NSString *currVersion = [NSString stringWithFormat:@"%@.%@", 
                             [appInfo objectForKey:@"CFBundleShortVersionString"], 
                             [appInfo objectForKey:@"CFBundleVersion"]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersionEulaAgreed = (NSString *)[defaults objectForKey:@"agreedToEulaForVersion"];
    
    
    // was the version number the last time EULA was seen and agreed to the 
    // same as the current version, if not show EULA and store the version number
    if (![currVersion isEqualToString:lastVersionEulaAgreed]) {
        [defaults setObject:currVersion forKey:@"agreedToEulaForVersion"];
        [defaults synchronize];
        NSLog(@"Data saved");
        NSLog(@"%@", currVersion);
        
        // Create the modal view controller
        EulaViewController *eulaVC = [[EulaViewController alloc] initWithNibName:@"EulaViewController" bundle:nil];
        
        // we are the delegate that is responsible for dismissing the help view
        eulaVC.delegate = self;
        eulaVC.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentModalViewController:eulaVC animated:YES];
        
    }

    
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    appMgr = [AppManager singletonAppManager];
    visitedNodes = appMgr.dc.visitedNodes;    
    [self updateNodeUI];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if (appMgr.agreedWithEula == FALSE) {
        [self presentEulaModalView];
    }
    
}


- (void)viewDidUnload
{
    [nodeText release];
    nodeText = nil;
    [btnAnswer1 release];
    btnAnswer1 = nil;
    [btnAnswer2 release];
    btnAnswer2 = nil;
    [toolbarText release];
    toolbarText = nil;
    [doneImage release];
    doneImage = nil;
    [iconImage release];
    iconImage = nil;
    [btnDone release];
    btnDone = nil;
    [barBtnBack release];
    barBtnBack = nil;
    [barBtnNext release];
    barBtnNext = nil;
    [barBtnBackToLast release];
    barBtnBackToLast = nil;
    [barBtnRestartEval release];
    barBtnRestartEval = nil;
    [barBtnReviewEval release];
    barBtnReviewEval = nil;
    [lblCurrentPageIndicator release];
    lblCurrentPageIndicator = nil;
    [barBtnItemInfo release];
    barBtnItemInfo = nil;
    [barBtnItemFootnotes release];
    barBtnItemFootnotes = nil;
    [labelBtn1Tree release];
    labelBtn1Tree = nil;
    [labelBtn1Node release];
    labelBtn1Node = nil;
    [labelBtn2Tree release];
    labelBtn2Tree = nil;
    [labelBtn2Node release];
    labelBtn2Node = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
