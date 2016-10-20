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

#import <UIKit/UIKit.h>
#import "DTConnector.h"
#import "ModalViewDelegate.h"

@interface DecisionVC : UIViewController <UIAlertViewDelegate, ModalViewDelegate>
    
    @property(nonatomic, weak) IBOutlet UITextView *nodeText;
    @property(nonatomic, weak) IBOutlet UILabel *toolbarText;
    @property(nonatomic, weak) IBOutlet UIButton *btnAnswer1;
    @property(nonatomic, weak) IBOutlet UIButton *btnAnswer2;
    @property(nonatomic, weak) IBOutlet UIImageView *doneImage;
    @property(nonatomic, weak) IBOutlet UIImageView *iconImage;
    @property(nonatomic, weak) IBOutlet UIButton *btnDone;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnBack;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnNext;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnBackToLast;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnRestartEval;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnReviewEval;
    @property(nonatomic, weak) IBOutlet UILabel *lblCurrentPageIndicator;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnItemInfo;
    @property(nonatomic, weak) IBOutlet UIBarButtonItem *barBtnItemFootnotes;
    
    @property(nonatomic, weak) IBOutlet UILabel *labelBtn1Tree;
    @property(nonatomic, weak) IBOutlet UILabel *labelBtn1Node;
    @property(nonatomic, weak) IBOutlet UILabel *labelBtn2Tree;
    @property(nonatomic, weak) IBOutlet UILabel *labelBtn2Node;
    


@property(nonatomic, strong) DTConnector *btn1Connector;
@property(nonatomic, strong) DTConnector *btn2Connector;

- (IBAction)btnInfoTouchUp:(id)sender;
- (IBAction)btnHelpTouchUp:(id)sender;
- (IBAction)btnFootnotesTouchUp:(id)sender;

-(void)updateNodeUI;
- (IBAction)btnAnswer1TouchUp:(id)sender;
- (IBAction)btnAnswer2TouchUp:(id)sender;
- (IBAction)btnDoneTouchUp:(id)sender;
- (IBAction)barBtnBackTouchUp:(id)sender;
- (IBAction)barBtnNextTouchUp:(id)sender;
- (IBAction)barBtnBackToLastTouchUp:(id)sender;
- (IBAction)barBtnRestartEvalTouchUp:(id)sender;
- (IBAction)barBtnReviewEvalTouchUp:(id)sender;
-(void)changeDecision:(DTConnector *)newChoice;

@end
