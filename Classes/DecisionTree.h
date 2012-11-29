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
#import "DTFootnotes.h"
@class DTNode;
@class NodeId;


@interface DecisionTree : NSObject {
    NSString *asText;
    NSString *name;
    NSString *groupName;
    NSUInteger number;
    NSMutableDictionary *decisionNodes;
    DTFootnotes *footnotes;
    
}


@property(nonatomic, retain) NSString *asText;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *groupName;
@property(nonatomic, retain) DTFootnotes *footnotes;
@property NSUInteger number;
@property(retain, nonatomic) NSMutableDictionary *decisionNodes;


-(id)initWithName:(NSString *)newName groupName:(NSString *)newGroupName number:(NSUInteger)newNumber;
-(void)addNode:(DTNode *)newDecisionNode;
-(DTNode *)getNodeForNodeId:(NodeId *)id;
-(NSString *)getKey;
+(NSString *)getKeyWithNumber:(NSUInteger)number;
-(void)addFootnote:(NSString *)newFootnote;
-(NSString *)getFootnoteAtIndex:(NSUInteger)theIndex;


@end


