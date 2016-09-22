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
#import "ModalViewDelegate.h"


@interface AboutVC : UIViewController<ModalViewDelegate> {

    IBOutlet UILabel *labelVersionInfo;
    IBOutlet UILabel *labelBuildInfo;
    id<ModalViewDelegate> __weak delegate;

}

@property(nonatomic, weak) id<ModalViewDelegate> delegate;
@property(nonatomic, strong) UILabel *labelVersionInfo;
@property(nonatomic, strong) UILabel *labelBuildInfo;

-(NSString *)getVersionString;
-(NSString *)getBuildString;
- (IBAction)btnDoneTouchUp:(id)sender;
- (IBAction)btnTakeSurveyTouchUp:(id)sender;
- (IBAction)btnReadEulaTouchUp:(id)sender;


@end
