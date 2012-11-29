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

#import "DecisionTrees.h"


@implementation DecisionTrees

@synthesize trees;


- (id)init 
{
    
    self = [super init];
    if (self) {
        trees = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

-(void)dealloc
{
    [trees release];
    [super dealloc];
    
}

-(void)addTree:(DecisionTree *)newTree
{
    if ((trees != nil) && (newTree != nil)) {
        
        // make sure key does not exist
        if ([self.trees objectForKey:[newTree getKey]] == nil)
            
            [self.trees setObject:newTree forKey:[newTree getKey]];
        
    }
    
    return;
    
}

-(void)addNode:(DTNode *)node toTreeNumber:(NSUInteger)treeNumber
{
    DecisionTree *destinationTree = [self getTreeWithNumber:treeNumber];
    [destinationTree addNode:node];
}

-(void)addNode:(DTNode *)node toTree:(DecisionTree *)tree
{
    DecisionTree *destinationTree = [self getTreeWithNumber:tree.number];
    [destinationTree addNode:node];
}

-(DecisionTree *)getTreeWithNumber:(NSUInteger)number
{
    
    NSString *key = [DecisionTree getKeyWithNumber:number];
    
    return [self.trees objectForKey:key];

}


@end
