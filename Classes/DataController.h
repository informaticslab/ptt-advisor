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

#import <Foundation/Foundation.h>
#import "DecisionTrees.h"
#import "PatientEvaluation.h"
#import "VisitedDecisionNodes.h"
#import "DecisionTree.h"

@interface DataController : NSObject 
{
    
    PatientEvaluation *currPatientEncounter;
    DecisionTrees *allTrees;
    DecisionTree *currDecisionTree;
    DTNode *currNode;
    DecisionTree *startingTree;
    DTNode *startingNode;
    VisitedDecisionNodes *visitedNodes;

}


@property(nonatomic, retain) PatientEvaluation *currPatientEncounter;
@property(nonatomic, retain) DecisionTrees *allTrees;
@property(nonatomic, retain) DecisionTree *currDecisionTree;
@property(nonatomic, retain) DTNode *currDecisionNode;
@property(nonatomic, retain) DecisionTree *startingTree;
@property(nonatomic, retain) DTNode *startingNode;
@property(nonatomic, retain) VisitedDecisionNodes *visitedNodes;


-(void)loadDecisionTrees;
-(DTNode *)getRootNode;
-(PatientEvaluation *)createPatientEncounter;
-(DTNode *)goToNodeUsingConnector:(DTConnector *)chosenConnector;
-(DecisionTree *)loadTreeWithName:(NSString *)newTreeName 
                        groupName:(NSString *)newGroupName 
                           number:(NSUInteger)newTreeNumber;
-(DTNode *)loadNodeWithText:(NSString *)bodyText tree:(DecisionTree *)newTree nodeNumber:(NSUInteger)newNodeNumber;
-(void)restartPatientEvaluation;

@end
