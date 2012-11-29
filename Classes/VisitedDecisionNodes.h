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
#import "DTNode.h"

#define LIVE_MODE 1
#define REVIEW_MODE 0

@interface VisitedDecisionNodes : NSObject 
{
    
    NSMutableArray *visitedNodes;
    NSMutableArray *chosenConnectors;
    DTNode *currNode;
    DTConnector *chosenConnector;
    NSUInteger currNodeIndex;
    
}

@property(nonatomic, retain) NSMutableArray *visitedNodes;
@property(nonatomic, retain) NSMutableArray *chosenConnectors;
@property(nonatomic, retain) DTNode *currNode;
@property(nonatomic, retain) DTConnector *chosenConnector;


-(void)restart;
-(void)newVisitedNode:(DTNode *)visitedNode;
-(void)newVisitedConnector:(DTConnector *)visitedConnector;
-(NSUInteger)getNodeCount;
-(NSUInteger)getConnectorCount;
-(NSString *)getNodeTextAtIndex:(NSUInteger)index;
-(NSString *)getConnectorTextAtIndex:(NSUInteger)index;
-(BOOL)hasPreviousNode;
-(BOOL)hasNextNode;
-(DTNode *)getPreviousNode;
-(DTNode *)getNextNode;
-(DTNode *)getNodeAtIndex:(NSUInteger)theIndex;
-(DTNode *)goToNodeAtIndex:(NSUInteger)newIndex;
-(DTConnector *)getChosenConnectorForCurrentNode;
-(DTConnector *)getConnectorAtIndex:(NSUInteger)index;
-(BOOL)hasDifferentChosenConnectorForCurrentNode:(DTConnector *)newChoice;
-(DTNode *)getUnansweredNode;
-(NSUInteger)getCurrentNodeIndex;
-(void)redoFromCurrentNodeUsingConnector:(DTConnector *)newConnector;
-(DTNode *)goToNodeUsingConnector:(DTConnector *)chosenConnector;
-(BOOL)isAtUnansweredNode;
-(BOOL)isAtReviewNode;
-(BOOL)isAtFirstNode;
-(BOOL)isAtLastNode;



@end
