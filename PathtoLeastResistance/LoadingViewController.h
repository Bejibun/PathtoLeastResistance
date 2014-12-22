//
//  LoadingViewController.h
//  Info_Gain_Project
//
//  Created by new owner on 12/5/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (strong, nonatomic) IBOutlet UILabel *percentLabel;

-(void)setupUI:(NSString *)label;

-(void)setupProgress:(float)percentage;

@end
