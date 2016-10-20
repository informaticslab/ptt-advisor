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
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Patient Evaluation Complete"
                                                                   message:@"Would you like to begin a new patient evaluation?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        DebugLog(@"User hit Yes on Begin New Evaluation Alert.");
                                        [visitedNodes restart];
                                        [self updateNodeUI];
                                        
                                        
                                    }];
    [alert addAction:defaultAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       DebugLog(@"User hit Cancel on Begin New Evaluation Alert.");
                                       
                                   }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)changeDecision:(DTConnector *)newChoice
{
    
    //NSUInteger answeredQuestions = [visitedNodes getNodeCount] - 1;
    NSUInteger currReviewQuestion = [visitedNodes getCurrentNodeIndex] + 1;
    
    NSString *warningMessage = [NSString stringWithFormat:@"You are about to change your answer to Step %lu. Therefore any previous responses past Step %lu will be discarded and you will be presented with new questions and information at Step %lu. Would you like to continue?", (unsigned long)currReviewQuestion, (unsigned long)currReviewQuestion, currReviewQuestion +1];
    
    newChoiceConnector = newChoice;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Change Decision Warning"
                                                                   message:warningMessage
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        DebugLog(@"User hit OK on Change Evaluation Alert.");
                                        [visitedNodes redoFromCurrentNodeUsingConnector:newChoiceConnector];
                                        [self updateNodeUI];
                                    }];
    [alert addAction:defaultAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       DebugLog(@"User hit Cancel on Change Evaluation Alert.");
                                       newChoiceConnector = nil;
                                       
                                   }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


- (void)didDismissModalView {
    
    // Dismiss the modal view controller
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Restart Patient Evaluation"
                                                                   message:@"Are you sure you want to restart the patient evaluation?"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        DebugLog(@"User hit OK on Reset Evaluation Alert View.");
                                        [visitedNodes restart];
                                        [self updateNodeUI];
                                    }];
    [alert addAction:defaultAction];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       DebugLog(@"User hit Cancel on Reset Evaluation Alert View.");
                                   }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)barBtnReviewEvalTouchUp:(id)sender
{
    
    // Create the modal view controller
    DecisionHistoryVC *viewController = [[DecisionHistoryVC alloc] initWithNibName:@"DecisionHistoryVC" bundle:nil];
    
    // we are the delegate that is responsible for dismissing the help view
//    viewController.delegate = self;
    viewController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentModalViewController:viewController animated:YES];
    
    // Clean up resources
    
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
    self.labelBtn1Tree.text = nil;
    self.labelBtn1Node.text = nil;
    self.labelBtn2Tree.text = nil;
    self.labelBtn2Node.text = nil;
    
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
//        [[btnAnswer1 layer] setBorderWidth:2.0f];
//        [[btnAnswer1 layer] setBorderColor:[UIColor colorWithRed:0.00 green:0.47 blue:1.00 alpha:1.0].CGColor];
        
        
        if ([appMgr isDebugInfoEnabled]) {
            self.labelBtn1Tree.text = [NSString stringWithFormat:@"Tree %lu", (unsigned long)btn1Connector.endNode.treeNumber];
            self.labelBtn1Node.text = [NSString stringWithFormat:@"Node %lu", (unsigned long)btn1Connector.endNode.nodeNumber];
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
//        [[btnAnswer2 layer] setBorderWidth:1.0f];
//        [[btnAnswer2 layer] setBorderColor:[UIColor colorWithRed:0.00 green:0.47 blue:1.00 alpha:1.0].CGColor];
        
        if ([appMgr isDebugInfoEnabled]) {
            self.labelBtn2Tree.text = [NSString stringWithFormat:@"Tree %lu", (unsigned long)btn2Connector.endNode.treeNumber];
            self.labelBtn2Node.text = [NSString stringWithFormat:@"Node %lu", (unsigned long)btn2Connector.endNode.nodeNumber];
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
        debugInfo = [NSString stringWithFormat:@"Tree %lu, Node %lu, Footnotes %@",(unsigned long)currNode.nodeId.treeNumber,(unsigned long)currNode.nodeId.nodeNumber, [currNode getFootnoteIdsAsDebugInfo]];
        if (reviewing) {
            self.lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %lu, %@",[visitedNodes getCurrentNodeIndex] +1, debugInfo];
        } else {
            self.lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %lu, %@",(unsigned long)[visitedNodes getNodeCount], debugInfo];
        }
    } else {
        if (reviewing)
            self.lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %lu",[visitedNodes getCurrentNodeIndex] +1];
        else
            self.lblCurrentPageIndicator.text = [NSString stringWithFormat:@"Step %lu",(unsigned long)[visitedNodes getNodeCount]];
    }
    
    // should we enable back button
    if ([visitedNodes hasPreviousNode])
        self.barBtnBack.enabled = TRUE;
    else
        self.barBtnBack.enabled = FALSE;
    
    // should we enable next button or jump to last?
    if ([visitedNodes hasNextNode]) {
        self.barBtnNext.enabled = TRUE;
        self.barBtnBackToLast.enabled = TRUE;
    } else {
        self.barBtnNext.enabled = FALSE;
        self.barBtnBackToLast.enabled = FALSE;
    }
    
    // should we enable next button or jump?
    if ([visitedNodes isAtFirstNode] && [visitedNodes isAtUnansweredNode] ) {
        self.barBtnRestartEval.enabled = FALSE;
        self.barBtnReviewEval.enabled = FALSE;
    } else {
        self.barBtnRestartEval.enabled = TRUE;
        self.barBtnReviewEval.enabled = TRUE;
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
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIFont *customFont = [UIFont fontWithName:@"LucidaGrande" size:17];
    nodeText.font = customFont;
    
    appMgr = [AppManager singletonAppManager];
    visitedNodes = appMgr.dc.visitedNodes;
    [self updateNodeUI];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    
//    if (appMgr.agreedWithEula == FALSE) {
//        [self presentEulaModalView];
//    }
    
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

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {

    [self dismissViewControllerAnimated:YES completion:nil];

}

@end
