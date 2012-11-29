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
//#import "DTNode.h"

@interface DTConnector : NSObject {
    NodeId *startNode;
    NodeId *endNode;
    NSString *text;
    
}

@property(nonatomic, retain) NodeId *startNode;
@property(nonatomic, retain) NodeId *endNode;
@property(nonatomic, retain) NSString *text;

-(id)initWithStartNode:(NodeId *)newStartNode
               endNode:(NodeId *)newEndNode
                  text:(NSString *)newText;
-(id)initWithStartTree:(NSUInteger)newStartTree
             startNode:(NSUInteger)newStartNode
               endTree:(NSUInteger)newEndTree
               endNode:(NSUInteger)newEndNode
                  text:(NSString *)newText;

-(NodeId *)getNextNodeId;



@end
