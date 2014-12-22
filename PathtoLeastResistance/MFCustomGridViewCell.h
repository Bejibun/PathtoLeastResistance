//
//  MFCustomGridViewCell.h
//  GridViewDemo
//
//  Created by Maxim Pervushin on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MFGridViewCell.h"

@interface MFCustomGridViewCell : MFGridViewCell<UITextFieldDelegate>

@property (strong, nonatomic) UITextField *input;

+ (float)CellSize;

@end
