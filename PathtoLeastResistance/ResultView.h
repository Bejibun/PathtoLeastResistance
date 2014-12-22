//
//  ResultView.h
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/17/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultView : UIView
{
    NSArray *columnsWidths;
    uint numRows;
    uint dy;
}

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns;
- (void)addRecord:(NSArray*)record;

@end
