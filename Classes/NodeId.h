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


@interface NodeId : NSObject {
    NSString *asText;
    NSUInteger treeNumber;
    NSUInteger nodeNumber;
    
}

@property(strong, nonatomic) NSString *asText;
@property NSUInteger treeNumber;
@property NSUInteger nodeNumber;

-(id)initWithTreeNumber:(NSUInteger)treeNumber nodeNumber:(NSUInteger)newNodeNumber;
-(NSString *)getKey;

@end
