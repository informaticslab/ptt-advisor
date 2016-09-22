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

#import "ReviewCell.h"
#import "AppManager.h"
#import "TableViewHelper.h"

@implementation ReviewCell

@synthesize imageView, nodeLabel, connLabel;

AppManager *appMgr;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Initialization code
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        nodeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        connLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        self.backgroundView = [[UIImageView alloc] init];
        self.selectedBackgroundView = [[UIImageView alloc] init];
        
        appMgr = [AppManager singletonAppManager];
        
        nodeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        nodeLabel.contentMode = UIViewContentModeTop;
        nodeLabel.backgroundColor = [UIColor clearColor];
        nodeLabel.numberOfLines = 0;
        nodeLabel.font = NODE_FONT;

        connLabel.contentMode = UIViewContentModeTop;
        connLabel.backgroundColor = [UIColor clearColor];
        connLabel.textColor = [UIColor colorWithRed:(27.0/255) green:(109.0/255) blue:(120.0/255) alpha:1.0];
        connLabel.lineBreakMode = NSLineBreakByWordWrapping;
        connLabel.numberOfLines = 1;
        connLabel.font = CONNECTOR_FONT;


    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)formatConnectorTextForCell:(NSIndexPath *)currIndexPath 
{
    NSString *connectorText = nil;
    AppManager *appMgr = [AppManager singletonAppManager];
    
    if (currIndexPath.section == 0) 
        connectorText = [appMgr.dc.visitedNodes getConnectorTextAtIndex:currIndexPath.row];

    return connectorText;
    
}


+(NSString *)formatNodeTextForCell:(NSIndexPath *)currIndexPath
{
    NSString *formattedText = nil;
    NSString *nodeText = nil;
    
    if (currIndexPath.section == 1) {
        nodeText = appMgr.dc.visitedNodes.currNode.bodyText;
    } else {
        nodeText = [appMgr.dc.visitedNodes getNodeTextAtIndex:currIndexPath.row];
        
    }
    
    if (currIndexPath.section == 0)
        formattedText = [NSString stringWithFormat:@"%ld.  %@", currIndexPath.row + 1, nodeText];
    else
        formattedText = [NSString stringWithFormat:@"%lu.  %@", (unsigned long)[appMgr.dc.visitedNodes getNodeCount], nodeText];
    
    return formattedText;
    
}

-(CGSize)heightForNodeText:(NSString *)currNodeText
{
    
    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize nodeTextSize = CGSizeMake(0.0, 0.0);
    
    if (currNodeText != nil) 
        nodeTextSize = [TableViewHelper text:currNodeText sizeWithFont:NODE_FONT constrainedToSize:constraintSize];
    
    return nodeTextSize;
}

+(CGFloat)heightForReviewCellAtIndexPath:(NSIndexPath *)currIndexPath
{
    
    NSString *nodeText = [ReviewCell formatNodeTextForCell:currIndexPath];
    NSString *connectorText = [ReviewCell formatConnectorTextForCell:currIndexPath];
    
    CGSize constraintSize = CGSizeMake(CELL_TEXT_LABEL_WIDTH, MAXFLOAT);
    CGSize nodeTextSize = CGSizeMake(0.0, 0.0);
    CGSize connectorTextSize = CGSizeMake(0.0, 0.0);
    
    if (nodeText != nil) 
        nodeTextSize = [TableViewHelper text:nodeText sizeWithFont:NODE_FONT constrainedToSize:constraintSize];
    
    if (connectorText != nil) 
        connectorTextSize = [TableViewHelper text:connectorText sizeWithFont:CONNECTOR_FONT];
        
    return  nodeTextSize.height + connectorTextSize.height + (2 * CELL_PADDING);

}

-(void)initWithNode:(DTNode *)newNode inTableView:(UITableView *)tv atIndexPath:(NSIndexPath *)aIndexPath
{
    
    NSString *nodeText = [ReviewCell formatNodeTextForCell:aIndexPath];
    CGSize nodeTextSize = [self heightForNodeText:nodeText];
    NSString *connectorText = [ReviewCell formatConnectorTextForCell:aIndexPath];
    

    // Configure the cell...
    //DebugLog(@"Row = %d", aIndexPath.row);
    
    node = newNode;
    indexPath = aIndexPath;
    parentTableView = tv;
    
    imageView.contentMode = UIViewContentModeTop;
    imageView.backgroundColor = [UIColor clearColor];

    nodeLabel.text = nodeText; 
    nodeLabel.frame = CGRectMake(52,5,nodeTextSize.width,nodeTextSize.height);

    connLabel.text = connectorText;         
    connLabel.frame = CGRectMake(52, nodeLabel.frame.size.height + 7,CELL_TEXT_LABEL_WIDTH, 20);
       
    [self setBackgroundImagesAtIndexPath];
    
    [self setImageForNode];

    
    
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self.contentView addSubview:imageView];
    [self.contentView addSubview:nodeLabel];
    [self.contentView addSubview:connLabel];
    
    
    self.nodeLabel.frame = CGRectMake(nodeLabel.frame.origin.x, 
                                      4.0, 
                                      nodeLabel.frame.size.width, 
                                      nodeLabel.frame.size.height);
    
    self.connLabel.frame = CGRectMake(self.connLabel.frame.origin.x, 
                                            8.0 + self.nodeLabel.frame.size.height, 
                                            self.connLabel.frame.size.width, 
                                            self.connLabel.frame.size.height);

    
//    DebugLog(@"Node label frame origin (%f,%f)" , nodeLabel.frame.origin.x, 4.0);
//    DebugLog(@"Node label frame size (%f,%f)" , nodeLabel.frame.size.width, nodeLabel.frame.size.height);
    
//    DebugLog(@"Connector label frame origin (%f,%f)" , connLabel.frame.origin.x, connLabel.frame.origin.y);
//    DebugLog(@"Connector label frame size (%f,%f)" , connLabel.frame.size.width, connLabel.frame.size.height);
    
    
}

-(void)setBackgroundImagesAtIndexPath 
{
    
    UIImage *rowBackground;
    UIImage *selectionBackground;
    NSInteger sectionRows = [parentTableView numberOfRowsInSection:[indexPath section]];
    NSInteger row = [indexPath row];
    
    if (row == 0 && row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"cell_top_bottom.png"];
        selectionBackground = [UIImage imageNamed:@"cell_top_bottom_focus.png"];
    }
    else if (row == 0)
    {
        rowBackground = [UIImage imageNamed:@"cell_top.png"];
        selectionBackground = [UIImage imageNamed:@"cell_top_focus.png"];
    }
    else if (row == sectionRows - 1)
    {
        rowBackground = [UIImage imageNamed:@"cell_bottom.png"];
        selectionBackground = [UIImage imageNamed:@"cell_bottom_focus.png"];
    }
    else
    {
        rowBackground = [UIImage imageNamed:@"cell_mid.png"];
        selectionBackground = [UIImage imageNamed:@"cell_mid_focus.png"];
    }
    
    ((UIImageView *)self.backgroundView).image = rowBackground;
    ((UIImageView *)self.selectedBackgroundView).image = selectionBackground;
    

}

-(void)setImageForNode
{

    UIImage *image = nil;
    if ( [node isStatementNode] || [node isLastNode])
        image = [UIImage imageNamed:@"statement_icon_updated.png"];
    else 
        image = [UIImage imageNamed:@"question_icon_updated.png"];
    [imageView setImage:image];
    imageView.frame = CGRectMake(5,7,32,32);
    
}



@end
