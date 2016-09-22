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

@interface DecisionVC : UIViewController <UIAlertViewDelegate,ModalViewDelegate> {
    
    IBOutlet UITextView *nodeText;
    IBOutlet UILabel *toolbarText;
    IBOutlet UIButton *btnAnswer1;
    IBOutlet UIButton *btnAnswer2;
    DTConnector *btn1Connector;
    DTConnector *btn2Connector;
    IBOutlet UIImageView *doneImage;
    IBOutlet UIImageView *iconImage;
    IBOutlet UIButton *btnDone;
    IBOutlet UIBarButtonItem *barBtnBack;
    IBOutlet UIBarButtonItem *barBtnNext;
    IBOutlet UIBarButtonItem *barBtnBackToLast;
    IBOutlet UIBarButtonItem *barBtnRestartEval;
    IBOutlet UIBarButtonItem *barBtnReviewEval;
    IBOutlet UILabel *lblCurrentPageIndicator;
    IBOutlet UIBarButtonItem *barBtnItemInfo;
    IBOutlet UIBarButtonItem *barBtnItemFootnotes;
    
    IBOutlet UILabel *labelBtn1Tree;
    IBOutlet UILabel *labelBtn1Node;
    IBOutlet UILabel *labelBtn2Tree;
    IBOutlet UILabel *labelBtn2Node;
    
}

@property(nonatomic, strong) UITextView *nodeText;
@property(nonatomic, strong) UILabel *toolbarText;
@property(nonatomic, strong) UIImageView *doneImage;
@property(nonatomic, strong) UIButton *btnAnswer1;
@property(nonatomic, strong) UIButton *btnAnswer2;
@property(nonatomic, strong) UIButton *btnDone;
@property(nonatomic, strong) DTConnector *btn1Connector;
@property(nonatomic, strong) DTConnector *btn2Connector;
@property(nonatomic, strong) UIImageView *iconImage;
@property(nonatomic, strong) IBOutlet UIBarButtonItem *barBtnItemFootnotes;

- (IBAction)btnInfoTouchUp:(id)sender;
- (IBAction)btnHelpTouchUp:(id)sender;
- (IBAction)btnFootnotesTouchUp:(id)sender;

-(void)updateNodeUI;
- (IBAction)btnAnswer2TouchUp:(id)sender;
- (IBAction)btnDoneTouchUp:(id)sender;
- (IBAction)barBtnBackTouchUp:(id)sender;
- (IBAction)barBtnNextTouchUp:(id)sender;
- (IBAction)barBtnBackToLastTouchUp:(id)sender;
- (IBAction)barBtnRestartEvalTouchUp:(id)sender;
- (IBAction)barBtnReviewEvalTouchUp:(id)sender;
-(void)changeDecision:(DTConnector *)newChoice;

@end
