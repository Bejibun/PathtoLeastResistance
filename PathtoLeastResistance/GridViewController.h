//
//  GridViewController.h
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/17/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFGridView.h"
#import "Tracker.h"
#import "LoadingViewController.h"

@interface GridViewController : UIViewController<MFGridViewDataSource, MFGridViewDelegate>

@property (strong, nonatomic) UIViewController *resultVC;

@property (assign, nonatomic) NSInteger requestedRow;

@property (assign, nonatomic) NSInteger requestedColumn;

@property (strong, nonatomic) Tracker *trk;

@property (strong, nonatomic) LoadingViewController* loadingVC;

- (IBAction)randomTapped:(id)sender;
- (IBAction)backTapped:(id)sender;
- (IBAction)resultTapped:(id)sender;

@end
