//
//  ViewController.h
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/17/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewController.h"

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *rowField;

@property (strong, nonatomic) IBOutlet UITextField *columnField;

@property (strong, nonatomic) UIButton *doneButton;

- (IBAction)createGridTapped:(id)sender;

@end

