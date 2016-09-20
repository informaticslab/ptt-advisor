//
//  TableViewHelper.h
//  anticoagmon
//
//  Created by Greg Ledbetter on 9/19/16.
//
//

#ifndef TableViewHelper_h
#define TableViewHelper_h

@interface TableViewHelper : NSObject

+ (CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font;
+ (CGSize)text:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size;

@end

#endif /* TableViewHelper_h */
