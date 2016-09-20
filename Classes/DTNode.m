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

#import "DTNode.h"
#import "DTConnector.h"
#import "AppManager.h"

@implementation DTNode

@synthesize nodeId, bodyText, exitConnectors, nodeType, footnoteIds, myTree;

AppManager *appMgr;


-(id)initWithBodyText:(NSString *)newBodyText
             treeNumber:(NSUInteger)theTreeNumber
           nodeNumber:(NSUInteger)newNodeNumber
{
    
    self = [super init];
    if (self)
    {
        appMgr = [AppManager singletonAppManager];
        bodyText = newBodyText;
        nodeId = [[NodeId alloc] initWithTreeNumber:theTreeNumber nodeNumber:newNodeNumber];
        footnoteIds = [[NSMutableArray alloc] init];
        myTree = [appMgr.dc.allTrees getTreeWithNumber:theTreeNumber];
    }
    
    return self;

}

-(id)initWithBodyText:(NSString *)newBodyText
           tree:(DecisionTree *)theTree
           nodeNumber:(NSUInteger)newNodeNumber
{
    
    self = [super init];
    if (self)
    {
        appMgr = [AppManager singletonAppManager];
        bodyText = newBodyText;
        myTree = theTree;
        nodeId = [[NodeId alloc] initWithTreeNumber:myTree.number nodeNumber:newNodeNumber];
        footnoteIds = [[NSMutableArray alloc] init];
    }
    
    return self;
    
}

-(void)dealloc
{
    myTree = nil;
    [nodeId release];
    [footnoteIds release];
    [super dealloc];

}

// add exit paths
-(void)addExitConnector:(DTConnector *)newConnector
{
    
    if (newConnector) {
        if (exitConnectors == nil) {
            exitConnectors = [[NSMutableArray alloc] init];
        }
        [exitConnectors addObject:newConnector];
    }
}

-(void)addExitConnectorWithText:(NSString *)text exitTree:(NSUInteger)newExitTree exitNode:(NSUInteger)newExitNode
{
    NodeId *exitNode = [[NodeId alloc] initWithTreeNumber:newExitTree nodeNumber:newExitNode];
    DTConnector *connector = [[DTConnector alloc] initWithStartNode:self.nodeId endNode:exitNode text:text]; 
    
    [self addExitConnector:connector];
    
    [exitNode release];
    [connector release];
    
}

-(void)addFootnoteId:(NSNumber *)newFootnoteId
{
    [self.footnoteIds addObject:newFootnoteId];
}

-(NSUInteger)getFootnoteCount
{
    return [self.footnoteIds count];
}

-(BOOL)hasFootnotes
{
    if ([self getFootnoteCount] == 0)
        return FALSE;
    else
        return TRUE;
}

-(int)getFootnoteIdAtIndex:(NSUInteger)aIndex
{
    
    NSNumber *id = [self.footnoteIds objectAtIndex:aIndex];
    
    return [id intValue] + 1;
    
}


-(NSString *)getFootnoteAtIndex:(NSUInteger)aIndex
{
    return [self.myTree.footnotes getFootnoteAtIndex:aIndex];
}

-(NSString *)getFootnoteIdsAsDebugInfo
{

    NSString *debugInfo = [NSString stringWithFormat:@"("];
    int index = 0;
    NSUInteger idCount = [self getFootnoteCount];

    if (idCount == 0)
        return @"()";
    
    while (idCount != 0) {
        if (idCount == 1)
            debugInfo = [NSString stringWithFormat:@"%@%d)", debugInfo, [self getFootnoteIdAtIndex:index]];
        else
            debugInfo = [NSString stringWithFormat:@"%@%d,", debugInfo, [self getFootnoteIdAtIndex:index]];
        index++;
        idCount--;

    }
    return debugInfo;
    
}


-(void)asLastNode
{
    self.nodeType |= DECISION_NODE_TYPE_LAST;
}

-(BOOL)isLastNode
{
    return ((self.nodeType & DECISION_NODE_TYPE_LAST) == DECISION_NODE_TYPE_LAST);
}

-(void)asRootNode
{
    self.nodeType |= DECISION_NODE_TYPE_ROOT;
}

-(BOOL)isRootNode
{
    return ((self.nodeType & DECISION_NODE_TYPE_ROOT) == DECISION_NODE_TYPE_ROOT);
}

-(void)asEvalNode
{
    self.nodeType |= DECISION_NODE_TYPE_EVAL;
}

-(BOOL)isEvalNode
{
    return ((self.nodeType & DECISION_NODE_TYPE_EVAL) == DECISION_NODE_TYPE_EVAL);
}

-(void)asStatementNode
{
    self.nodeType |= DECISION_NODE_TYPE_STATEMENT;
}

-(BOOL)isStatementNode
{
    return ((self.nodeType & DECISION_NODE_TYPE_STATEMENT) == DECISION_NODE_TYPE_STATEMENT);
}


-(void)asFootnoteNode
{
    self.nodeType |= DECISION_NODE_TYPE_FOOTNOTE;
}

-(BOOL)isFootnoteNode
{
    return ((self.nodeType & DECISION_NODE_TYPE_FOOTNOTE) == DECISION_NODE_TYPE_FOOTNOTE);
}

-(NSString *)description
{
    
    return  [NSString stringWithFormat:@"DTNode: body text=%s", [self.bodyText UTF8String]];

}

@end
