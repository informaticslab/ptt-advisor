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

#import "DecisionTree.h"
#import "DTNode.h"
#import "AppManager.h"

@implementation DecisionTree

AppManager *appMgr;

@synthesize asText, name, groupName, number, decisionNodes, footnotes;

-(id)initWithName:(NSString *)newName groupName:(NSString *)newGroupName number:(NSUInteger)newNumber
{
    // load application manager
    appMgr = [AppManager singletonAppManager];
    
    self = [super init];
    
    if (self) {
        
        DebugLog(@"Create decision tree with name %@", newName);
        name = newName;
        groupName = newGroupName;
        number = newNumber;
        asText = [NSString stringWithFormat:@"%lu:%@", (unsigned long)newNumber, newName];
        decisionNodes = [[NSMutableDictionary alloc] init];
        footnotes = [[DTFootnotes alloc] init];
    }
    
    return self;
    
}


-(void)addFootnote:(NSString *)newFootnote
{
    [self.footnotes addNewFootnode:newFootnote];
    
}

-(NSString *)getFootnoteAtIndex:(NSUInteger)theIndex
{
    
    return [self.footnotes getFootnoteAtIndex:theIndex];
    
}

-(void)addNode:(DTNode *)newDecisionNode
{

    DebugLog(@"Adding child node with entry text %@ to decision node %@", [newDecisionNode bodyText], self.name);
    [self.decisionNodes setObject:newDecisionNode forKey:[newDecisionNode.nodeId getKey]];

}


-(DTNode *)getNodeForNodeId:(NodeId *)id
{
    NSString *nodeKey = [id getKey];
    DTNode *node = [self.decisionNodes objectForKey:nodeKey];
    DebugLog("Found node with %@ for node id %@", node, id);
    return node;
}

-(NSString *)getKey
{
    return [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
}

+(NSString *)getKeyWithNumber:(NSUInteger)number
{
    return [NSString stringWithFormat:@"%lu",(unsigned long)number];
}


-(NSString *)description
{
    
    return  [NSString stringWithFormat:@"DecisionTree: asText=%s number=%lu name=%@", [self.asText UTF8String], (unsigned long)self.number, self.name];
}


@end
