//
//  LoadingViewController.m
//  Info_Gain_Project
//
//  Created by new owner on 12/5/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import "LoadingViewController.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController
@synthesize loadingLabel, indicatorView,percentLabel,progressView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupUI:(NSString *)label
{
    [indicatorView startAnimating];
    loadingLabel.text = label;
}

-(void)setupProgress:(float)percentage
{
    progressView.progress = percentage;
    
    percentLabel.text = [NSString stringWithFormat:@"%.f %%", (float)percentage *100];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
