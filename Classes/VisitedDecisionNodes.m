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

#import "VisitedDecisionNodes.h"
#import "AppManager.h"
#import "DTConnector.h"
#import "DTNode.h"

@implementation VisitedDecisionNodes

AppManager *appMgr;

@synthesize visitedNodes, chosenConnectors, currNode, chosenConnector;

-(id)init
{
    
    self = [super init];
    if (self) 
    {
        visitedNodes = [[NSMutableArray alloc] init];
        chosenConnectors = [[NSMutableArray alloc] init]; 
        currNode = nil;
        chosenConnector = nil;
        appMgr = [AppManager singletonAppManager];
        currNodeIndex = 0; 
        
    }
    
    return self;

}

-(void)dealloc
{
    [visitedNodes release];
    [chosenConnectors release];
    [super dealloc];
}

-(void)logVisitedNodeInfo
{
    
    DebugLog("Node count = %d, connector count = %d, node index = %d", [visitedNodes count], [chosenConnectors count], currNodeIndex);
    DebugLog("Current node Info:");
    if (self.currNode)
        DebugLog("%@",self.currNode);
    
}

-(void)restart
{
    
    [self.visitedNodes removeAllObjects];
    [self.chosenConnectors removeAllObjects];
    self.currNode = nil;
    self.chosenConnector = nil;
    currNodeIndex = 0;
    [self logVisitedNodeInfo];
    
    // get root node from data controller's decision trees
    self.currNode = [appMgr.dc getRootNode];
    
    // store root node in visited nodes
    [self newVisitedNode:self.currNode];
    


}


// called to check if previous button on displays should be disabled
-(BOOL)hasPreviousNode
{
    
    if (currNodeIndex > 0) 
        return TRUE;
    
    return FALSE;

}


// called to check if next button on displays should be disabled
-(BOOL)hasNextNode
{

    // if only one visited node, no next node 
    if ([visitedNodes count] < 2)
        return FALSE;

    // current index is referencing last node
    if (currNodeIndex >= ([visitedNodes count] -1)) 
        return FALSE;
    
    return TRUE;
    
}

-(BOOL)isAtUnansweredNode
{
    
    if (self.currNode == [visitedNodes lastObject]) 
        return TRUE;
    
    return FALSE;
    
}

-(BOOL)isAtReviewNode
{
    
    if (self.currNode != [visitedNodes lastObject]) 
        return TRUE;
    
    return FALSE;
    
}

-(BOOL)isAtLastNode
{
    
    if ( [self.currNode isLastNode]) 
        return TRUE;
    
    return FALSE;
    
}


-(BOOL)isAtFirstNode
{
    
    if ([visitedNodes count] == 1) 
        return TRUE;
    
    return FALSE;
    
}

-(BOOL)hasDifferentChosenConnectorForCurrentNode:(DTConnector *)newChoice
{
    if (chosenConnector == nil)
        return FALSE;
    else if (chosenConnector == newChoice)
        return FALSE;
    else
        return TRUE;
    
}


-(DTNode *)getPreviousNode
{
    // if previous node exists
    if ([self hasPreviousNode]) {
        
        // decrement index and get node at new index
        currNodeIndex--;
        self.currNode = [visitedNodes objectAtIndex:currNodeIndex];
        self.chosenConnector = [chosenConnectors objectAtIndex:currNodeIndex];
        
    }
    
    [self logVisitedNodeInfo];
    return self.currNode;
    
}


-(DTNode *)getNextNode
{
    
    // if next node exists
    if ([self hasNextNode]) {
        
        // increment index and get node at new index
        currNodeIndex++;
        self.currNode = [visitedNodes objectAtIndex:currNodeIndex];
        if ([self isAtUnansweredNode])
            self.chosenConnector = nil;
        else
            self.chosenConnector = [chosenConnectors objectAtIndex:currNodeIndex];
        
    }
    
    [self logVisitedNodeInfo];
    return self.currNode;

}


// sets the currrent node to the visited node at the specified index
-(DTNode *)goToNodeAtIndex:(NSUInteger)newIndex
{
    
    // if new index is within range
    if (newIndex < [visitedNodes count]) {
        
        // modify index and get node at new index
        currNodeIndex = newIndex;
        self.currNode = [visitedNodes objectAtIndex:currNodeIndex];
        if ([self isAtUnansweredNode])
            self.chosenConnector = nil;
        else
            self.chosenConnector = [chosenConnectors objectAtIndex:currNodeIndex];
        
    }
    
    [self logVisitedNodeInfo];
    return self.currNode;
    
}

// sets the currrent node to the visited node at the specified index
-(DTNode *)getNodeAtIndex:(NSUInteger)theIndex
{
    
    DTNode *nodeAtIndex = nil;
    
    // if new index is within range
    if (theIndex < [visitedNodes count]) 
        
        nodeAtIndex = [visitedNodes objectAtIndex:theIndex];

    return nodeAtIndex;
    
}



-(DTNode *)getUnansweredNode
{
    currNodeIndex = [visitedNodes count] - 1;
    self.currNode = [visitedNodes lastObject];
    self.chosenConnector = nil;
    [self logVisitedNodeInfo];
    return self.currNode;
    
}


-(DTConnector *)getChosenConnectorForCurrentNode
{
    return self.chosenConnector;
}


// find the next node for 
-(DTNode *)goToNodeUsingConnector:(DTConnector *)newChosenConnector
{
    // at unanswered node 
    if ([self isAtUnansweredNode]) {
        
        // get new node from data controller's decision trees
        self.currNode = [appMgr.dc goToNodeUsingConnector:newChosenConnector];
        
        // store new node in visited nodes
        [self newVisitedNode:self.currNode];
        
        // store connector in chosen connectors
        [self newVisitedConnector:newChosenConnector];
        
    } 
    
    // if reviewing and chosen connector has not changed
    else if (newChosenConnector == self.chosenConnector) {
            self.currNode = [self getNextNode];
    }
    
    // if review and changing chosen connector
    else {
        
        // get rid of all decisions previously made past this one
        [self redoFromCurrentNodeUsingConnector:newChosenConnector];

        // get new node from data controller's decision trees
        self.currNode = [appMgr.dc goToNodeUsingConnector:newChosenConnector];
        
        // store new node in visited nodes
        [self newVisitedNode:self.currNode];
        
        // store connector in chosen connectors
        [self newVisitedConnector:newChosenConnector];

    
    }
        
        
    return self.currNode;
    
}


-(void)redoFromCurrentNodeUsingConnector:(DTConnector *)newConnector
{
    
    DebugLog("Before redo from current node...");
    [self logVisitedNodeInfo];

    // calculate which nodes to delete
    NSUInteger countNodesToDelete = [visitedNodes count] - (currNodeIndex + 1);
    NSRange nodesToDelete = NSMakeRange(currNodeIndex +1, countNodesToDelete);
    
    // delete nodes
    [visitedNodes removeObjectsInRange:nodesToDelete];
    
    // calculate which connectors to delete
    NSUInteger countConnectorsToDelete = [chosenConnectors count] - currNodeIndex;
    NSRange connectorsToDelete = NSMakeRange(currNodeIndex, countConnectorsToDelete);
    
    // delete connectors
    [chosenConnectors removeObjectsInRange:connectorsToDelete];
    
    [self goToNodeUsingConnector:newConnector];
    
    DebugLog("After redo from current node...");
    [self logVisitedNodeInfo];

}


-(void)newVisitedNode:(DTNode *)visitedNode
{
    
    if (visitedNode)
    {
        
        [visitedNodes addObject:visitedNode];
        currNodeIndex = [visitedNodes count] - 1;
        DebugLog("New visited node = %@", visitedNode);
        [self logVisitedNodeInfo];
    }

}


-(void)newVisitedConnector:(DTConnector *)visitedConnector
{
    
    if (visitedConnector)
    {
        [chosenConnectors addObject:visitedConnector];
        self.chosenConnector = nil;
        DebugLog("New visited connector = %@", visitedConnector);
        [self logVisitedNodeInfo];
    }
    
}


-(NSString *)getNodeTextAtIndex:(NSUInteger)index
{
    
    if (index >= [self getNodeCount] )
        return @"";
    
    DTNode *node = [visitedNodes objectAtIndex:index];
    return node.bodyText;
    
}


-(NSString *)getConnectorTextAtIndex:(NSUInteger)index
{
    
    if (index >= [self getConnectorCount] )
        return nil;
    
    DTConnector *conn = [chosenConnectors objectAtIndex:index];
    return conn.text;

}

-(DTConnector *)getConnectorAtIndex:(NSUInteger)index
{
    
    if (index >= [self getConnectorCount] )
        return nil;
    
    DTConnector *conn = [chosenConnectors objectAtIndex:index];
    return conn;
    
}


-(NSUInteger)getNodeCount
{
    
    return [self.visitedNodes count];

}


-(NSUInteger)getConnectorCount
{
    
    return [self.chosenConnectors count];
    
}

-(NSUInteger)getCurrentNodeIndex
{
    
    return currNodeIndex;
}


@end
