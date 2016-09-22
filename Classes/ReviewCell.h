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

#import <UIKit/UIKit.h>
#import "DTNode.h"

#define CELL_TEXT_LABEL_WIDTH 230.0
#define NODE_FONT [UIFont fontWithName:@"Helvetica" size:14.0f]
#define CONNECTOR_FONT [UIFont fontWithName:@"Helvetica-Bold" size:16.0f]

#define NODE_LABEL_TAG 120
#define CONNECTOR_LABEL_TAG 121
#define IMAGE_TAG 122


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 230.0f
#define CELL_CONTENT_MARGIN 10.0f

#define CELL_PADDING 10.0

@interface ReviewCell : UITableViewCell {
    UIImageView *imageView;
    UILabel *nodeLabel;
    UILabel *connLabel;
    UITableView *parentTableView;
    DTNode *node;
    NSIndexPath *indexPath;
    
}

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *nodeLabel;
@property(nonatomic, strong) UILabel *connLabel;

-(void)setBackgroundImagesAtIndexPath;
-(void)setImageForNode;
-(void)initWithNode:(DTNode *)node inTableView:(UITableView *)tv atIndexPath:(NSIndexPath *)indexPath;
+(CGFloat)heightForReviewCellAtIndexPath:(NSIndexPath *)currIndexPath;
+(NSString *)formatConnectorTextForCell:(NSIndexPath *)currIndexPath; 
+(NSString *)formatNodeTextForCell:(NSIndexPath *)currIndexPath;

@end
