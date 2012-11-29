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

#import "DTConnector.h"


@implementation DTConnector

@synthesize startNode, endNode, text;

-(id)initWithStartNode:(NodeId *)newStartNode
            endNode:(NodeId *)newEndNode
              text:(NSString *)newText

{

    self = [super init];
    if (self) {
        self.startNode = newStartNode;
        self.endNode = newEndNode;
        self.text = newText;
    }
    
    return self;
     
}

-(id)initWithStartTree:(NSUInteger)newStartTree
               startNode:(NSUInteger)newStartNode
               endTree:(NSUInteger)newEndTree
               endNode:(NSUInteger)newEndNode
                  text:(NSString *)newText
{
    
    self = [super init];
    if (self) {
        startNode = [[NodeId alloc] initWithTreeNumber:newStartTree nodeNumber:newStartNode];
        endNode = [[NodeId alloc] initWithTreeNumber:newEndTree nodeNumber:newEndNode];
        text = newText;
    }
    
    return self;
    
}

-(void)dealloc
{
    [startNode release];
    [endNode release];
    [super dealloc];
}


-(NodeId *)getNextNodeId
{
    
    return self.endNode;
    
}

-(NSString *)description
{
    
    return  [NSString stringWithFormat:@"DTConnector: address=0x%x, text=%s", self, [self.text UTF8String]];
}


@end