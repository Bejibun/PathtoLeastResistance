//
//  MFCustomGridViewCell.m
//  GridViewDemo
//
//  Created by Maxim Pervushin on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MFCustomGridViewCell.h"
#import "GridViewController.h"
#define CELL_SIZE 50

@interface MFCustomGridViewCell ()
{
    UIView *_contentView;
    BOOL randomNumber;
}

@end

@implementation MFCustomGridViewCell
@synthesize input;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
//        CGRect contentViewFrame = CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10);
//        _contentView = [[UIView alloc] initWithFrame:contentViewFrame];
        _contentView = [[UIView alloc] init];
        _contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        _contentView.backgroundColor = [UIColor colorWithWhite:(CGFloat)(arc4random() % 254) / 254 alpha:1];
        _contentView.backgroundColor = [UIColor lightGrayColor];
        input = [[UITextField alloc]initWithFrame:CGRectMake(CELL_SIZE/2-12, CELL_SIZE/2-20, 30, 30)];
        [input setFont:[UIFont fontWithName:@"arial" size:12]];
        input.keyboardType = UIKeyboardTypeNumberPad;
        input.clearsOnBeginEditing = YES;
        input.delegate = self;
        input.text = @"0";
        [_contentView addSubview:input];
        [self addSubview:_contentView];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = CGRectMake(5, 5, self.bounds.size.width - 10, self.bounds.size.height - 10);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.superview.bounds.size.width, 44)];
        
        
        UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
        [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1;
    }
    return YES;
}

- (void)doneButtonClicked {
    //Write your code whatever you want to do on done button tap
    for (UITextField *txtfld in _contentView.subviews) {
        if(txtfld.text.integerValue > 50)
        {
            txtfld.text = @"50";
        }
        [txtfld resignFirstResponder];
    }
}

+ (float)CellSize
{
    return CELL_SIZE;
}


@end
