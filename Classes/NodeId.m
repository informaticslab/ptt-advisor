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

#import "NodeId.h"


@implementation NodeId

@synthesize asText, treeNumber, nodeNumber;

-(id)initWithTreeNumber:(NSUInteger)newTreeNumber nodeNumber:(NSUInteger)newNodeNumber
{
    
    self = [super init];
    
    if (self) {
        self.asText = [NSString stringWithFormat:@"%d:%d", newTreeNumber, newNodeNumber];
        self.treeNumber = newTreeNumber;
        self.nodeNumber = newNodeNumber;
    }
    
    return self;
}

// key used for node dictionary
-(NSString *)getKey
{
    return self.asText;
    
}

-(NSUInteger)getNodeIndex
{
    return self.nodeNumber;
    
}

-(NSString *)description
{
    
    return  [NSString stringWithFormat:@"NodeId: address=0x%x asText=%s treeNumber=%d nodeNumber=%d", self, [self.asText UTF8String], self.treeNumber, self.nodeNumber];
}

@end
