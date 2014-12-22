//
//  ViewController.m
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/17/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize doneButton;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    _rowField.keyboardType = UIKeyboardTypeNumberPad;
    _columnField.keyboardType = UIKeyboardTypeNumberPad;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(textField.keyboardType == UIKeyboardTypeNumberPad)
    {
        UIToolbar *toolBar1 = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        
        
        UIBarButtonItem *doItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonClicked)];
        [toolBar1 setItems:@[doItem]]; textField.inputAccessoryView = toolBar1;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}

- (void)doneButtonClicked {
    //Write your code whatever you want to do on done button tap
    for (UITextField *txtfld in self.view.subviews) {
        [txtfld resignFirstResponder];
    }
}

- (BOOL)validateRowColumn
{
    if (!(_rowField.text.integerValue >= 1 && _rowField.text.integerValue <= 10)) {
        [self invalidRowAlert];
        
        if(_rowField.text.integerValue < 1)
        {
            _rowField.text = @"1";
        }
        else if (_rowField.text.integerValue > 10)
        {
            _rowField.text = @"10";
        }
        
        return 0;
    }
    
    if (!(_columnField.text.integerValue >= 5 && _columnField.text.integerValue <= 100)) {
        [self invalidColumnAlert];
        
        if(_columnField.text.integerValue < 5)
        {
            _columnField.text = @"5";
        }
        else if (_columnField.text.integerValue > 100)
        {
            _columnField.text = @"100";
        }
        
        return 0;
    }
    
    return 1;
}

- (void)invalidRowAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Row" message:@"Minimum row is 1 and maximum row is 10" delegate:self cancelButtonTitle:@"Fix" otherButtonTitles:nil];
    [alert show];
}

-(void)invalidColumnAlert
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Column" message:@"Minimum column is 5 and maximum row is 100" delegate:self cancelButtonTitle:@"Fix" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)createGridTapped:(id)sender {
    
    if ([self validateRowColumn]) {
        GridViewController *gridVC = [[GridViewController alloc]initWithNibName:@"GridViewController" bundle:nil];
        
        gridVC.requestedRow = _rowField.text.integerValue;
        gridVC.requestedColumn = _columnField.text.integerValue;
        
        [self.navigationController
         pushViewController:gridVC animated:YES];
    }

}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}



@end
