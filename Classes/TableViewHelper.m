//
//  TableViewHelper.m
//  anticoagmon
//
//  Created by Greg Ledbetter on 9/19/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TableViewHelper.h"

@implementation TableViewHelper : NSObject 

+ (CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font {
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName: font}];
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
}

+ (CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size {
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName: font}
                                         context:nil];
    return CGSizeMake(ceilf(textRect.size.width), ceilf(textRect.size.height));
}


@end


