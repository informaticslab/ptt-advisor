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
#import "NodeId.h"
#import "DTConnector.h"
#import "DecisionTree.h"
@class DecisionTree;

typedef enum DecisionNodeTypes {
    DECISION_NODE_TYPE_UNDEFINED = 0,
    DECISION_NODE_TYPE_ROOT = 1,
    DECISION_NODE_TYPE_CHILD = 1 << 1,    
    DECISION_NODE_TYPE_STATEMENT = 1 << 2,
    DECISION_NODE_TYPE_LAST = 1 << 3,
    DECISION_NODE_TYPE_NO = 1 << 4,
    DECISION_NODE_TYPE_EVAL = 1 << 5,
    DECISION_NODE_TYPE_FOOTNOTE = 1 << 6
} DecisionNodeTypes;


@interface DTNode : NSObject {
    
    NodeId *nodeId;
    NSString *bodyText;
    NSMutableArray *exitConnectors;
    NSMutableArray *footnoteIds;
    DecisionNodeTypes nodeType;
    DecisionTree *myTree;

}

@property(nonatomic, strong) NodeId *nodeId;
@property(nonatomic, strong) NSString *bodyText;
@property(nonatomic, strong) NSMutableArray *exitConnectors;
@property(nonatomic, strong) NSMutableArray *footnoteIds;
@property DecisionNodeTypes nodeType;
@property(nonatomic, strong) DecisionTree *myTree;

-(id)initWithBodyText:(NSString *)newBodyText
           treeNumber:(NSUInteger)theTreeNumber
           nodeNumber:(NSUInteger)newNodeNumber;

-(id)initWithBodyText:(NSString *)newBodyText
                 tree:(DecisionTree *)theTree
           nodeNumber:(NSUInteger)newNodeNumber;

-(void)addExitConnector:(DTConnector *)newConnector;

-(void)addExitConnectorWithText:(NSString *)text exitTree:(NSUInteger)tree exitNode:(NSUInteger)node;
-(void)addFootnoteId:(NSNumber *)newFootnoteId;
-(NSUInteger)getFootnoteCount;
-(BOOL)hasFootnotes;
-(NSString *)getFootnoteAtIndex:(NSUInteger)aIndex;
-(int)getFootnoteIdAtIndex:(NSUInteger)aIndex;
-(NSString *)getFootnoteIdsAsDebugInfo;


-(void)asLastNode;
-(BOOL)isLastNode;
-(void)asRootNode;
-(BOOL)isRootNode;
-(void)asEvalNode;
-(BOOL)isEvalNode;
-(BOOL)isStatementNode;
-(void)asStatementNode;
-(void)asFootnoteNode;
-(BOOL)isFootnoteNode;

@end
