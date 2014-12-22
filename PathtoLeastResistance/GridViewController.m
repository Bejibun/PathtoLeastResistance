//
//  GridViewController.m
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/17/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import "GridViewController.h"
#import "MFCustomGridViewCell.h"
#import "MFGridViewIndex.h"
#import "ResultView.h"

#define COLUMN_WIDTH 250

static GridViewController *gInstance = NULL;

@interface GridViewController ()
{
    MFGridView *_gridView;
    MFGridViewIndex *gridViewIndex;
    BOOL firstLoop;
    dispatch_queue_t calculatingQueue;
    NSMutableDictionary *tempDict;
    NSMutableDictionary *lowestDict;
    BOOL removePreviousDict;
    BOOL unStuck;
    NSInteger currentColumn;
    NSTimer *timer;
}

- (void)gridViewCellInstanceCountChanged:(NSNotification *)notification;

@end

@implementation GridViewController
@synthesize resultVC;
@synthesize trk;
@synthesize loadingVC;
@synthesize requestedColumn;
@synthesize requestedRow;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self resetData];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gridViewCellInstanceCountChanged:)
                                                 name:@"GridViewCellInstanceCountChanged"
                                               object:nil];
    
    _gridView = [[MFGridView alloc] init];
    _gridView.frame = CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height);
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    [self.view addSubview:_gridView];
    
    [_gridView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gridViewCellInstanceCountChanged:(NSNotification *)notification
{
    NSNumber *gridViewCellInstanceCount = (NSNumber *)notification.object;
    
    self.title = [NSString stringWithFormat:@"Cell instances number: %@", gridViewCellInstanceCount];
}

#pragma mark - MFGridViewDataSource

- (NSUInteger)gridViewNumberOfRows:(MFGridView *)gridView
{
    return requestedRow;
}

- (NSUInteger)gridViewNumberOfColumns:(MFGridView *)gridView
{
    return requestedColumn;
}

- (CGSize)gridViewCellSize:(MFGridView *)gridView
{
    return CGSizeMake([MFCustomGridViewCell CellSize], [MFCustomGridViewCell CellSize]);
}

- (MFGridViewCell *)gridView:(MFGridView *)gridView cellForIndex:(MFGridViewIndex *)index
{
    MFCustomGridViewCell *cell = (MFCustomGridViewCell *)[gridView dequeueReusableCell];
    
    if (cell == nil) {
        cell = [[MFCustomGridViewCell alloc] init];
    }
    
    return cell;
}

#pragma mark - MFGridViewDelegate

- (void)gridView:(MFGridView *)gridView didSelectCellAtIndex:(MFGridViewIndex *)index
{
    NSLog(@"didSelectCellAtIndex:%@", index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissResultVC
{
    [self resetData];
    [resultVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)resetData
{
    calculatingQueue = dispatch_queue_create("calculatingdata", NULL);
    gridViewIndex = nil;
    trk = [[Tracker alloc]init];
    firstLoop = YES;
    tempDict = nil;
    lowestDict = nil;
    unStuck = NO;
    
    
    
    [Tracker resetSavedData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)randomTapped:(id)sender
{
    _gridView.randomNumber = YES;
    [_gridView reloadData];
    _gridView.randomNumber = NO;
}

- (IBAction)backTapped:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)resultTapped:(id)sender
{
    
    [self startLoading];
    
    
    [self calculatePathResistance];
    
    [self doneLoading];
    
}

- (void)startLoading
{
    loadingVC = [[LoadingViewController alloc]
                 initWithNibName:@"LoadingViewController" bundle:nil];
    [self.view addSubview:loadingVC.view];
    [loadingVC setupUI:@"Calculating"];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.1 target:self selector:@selector(showProgressBar) userInfo:nil repeats:YES];
    
}

-(void)showProgressBar
{
    [loadingVC setupProgress:(float) currentColumn/requestedColumn];;
}

- (void)doneLoading
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), calculatingQueue, ^{
        NSLog(@"Done Loading");
        [timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
        resultVC = [[UIViewController alloc]init];
        resultVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        resultVC.view.backgroundColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissResultVC)];
        
        [resultVC.view addGestureRecognizer:dismissTap];
        
        [loadingVC setupProgress:(float) 1.0f];
            
        [self getLastInformation];
        
        int64_t delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [loadingVC.view removeFromSuperview];
            [self presentViewController:resultVC animated:YES completion:nil];
        });
        
            
        });
    });
    
}


- (void)getLastInformation
{
    ResultView* result = [[ResultView alloc] initWithFrame:CGRectMake((resultVC.view.frame.size.width/2)-COLUMN_WIDTH/2, 60, 310, 100) andColumnsWidths:[[NSArray alloc] initWithObjects:@COLUMN_WIDTH, nil]];
    [Tracker loadTemporary:trk];
    
    [result addRecord:[[NSArray alloc] initWithObjects:@"Output", nil]];
    NSString *comPath = trk.completePath ? @"YES" : @"NO";
    [result addRecord:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",comPath], nil]];
    [result addRecord:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%d",(int)trk.totalResistance], nil]];
    
    if (trk.pathResistance != nil) {
        trk.pathResistance = [self addOnetoEachPath:trk.pathResistance];
    }
    
    [result addRecord:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"%@",trk.pathResistance], nil]];
    
    [resultVC.view addSubview:result];
}

-(NSString *)addOnetoEachPath:(NSString *)string
{
    NSMutableString *curString = [[NSMutableString alloc]initWithString:string];
    for (int i = 0; i < [curString length]; i++) {
        NSString *charString = [curString substringWithRange:NSMakeRange(i, 1)];
        [curString replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%d", (int)[charString integerValue]+1]];
    }
    return curString;
}

-(void)calculatePathResistance
{
    
    dispatch_async(calculatingQueue, ^{
    
    if (gridViewIndex == nil) {
        gridViewIndex = [[MFGridViewIndex alloc]init];
        trk = [[Tracker alloc]init];
        if (firstLoop) {
            //First Element in the row
            gridViewIndex.row = 0;
            gridViewIndex.column = 0;
            [self addFirstInitialValue];
        }
    }
    else
    {
        [self addThreeValuesIntoDictionary];
    }
    });

}

-(void)addFirstInitialValue
{
    
    if (tempDict == nil) {
        tempDict = [[NSMutableDictionary alloc]init];
    }
    
    int curValue = [_gridView getCellValue:gridViewIndex];
    if (curValue <= 50) {

        NSDictionary *dict = [[NSDictionary alloc]initWithObjects:[NSArray arrayWithObjects:@"NO",[NSNumber numberWithInt:curValue], nil] forKeys:[NSArray arrayWithObjects:@"completepath",@"totalresistance", nil]];
        
        [tempDict setObject:dict forKey:[NSString stringWithFormat:@"%d",(int)gridViewIndex.row]];
        
    }

    if (gridViewIndex.row < requestedRow-1) {
        gridViewIndex.row++;
        [self addFirstInitialValue];
    }
    else
    {
        [self calculatePathResistance];
    }
    
}

-(void)addThreeValuesIntoDictionary
{
    
    if ([tempDict count] > 0) {
        NSArray *rowIndicator = [tempDict allKeys];
        
        NSInteger topIndex;
        NSInteger midIndex = 0;
        NSInteger bottomIndex;
        
        //check the column and row indexes
        MFGridViewIndex *temp = [[MFGridViewIndex alloc]init];
        
        for (int i = 0; i < [rowIndicator count]; i++) {
            NSString *existingPath = [[NSString alloc]initWithString:[rowIndicator objectAtIndex:i]];
            NSInteger existingRow = [[existingPath substringWithRange:NSMakeRange(existingPath.length-1, 1)]integerValue];
            temp.column = [existingPath length];
            currentColumn = temp.column;
            
            midIndex = existingRow;
            int currentValue = (int)[[[tempDict objectForKey:existingPath] objectForKey:@"totalresistance"]integerValue];
            
            //get Top Index
            if (existingRow == 0) {
                topIndex = requestedRow-1;
            }
            else
            {
                topIndex = existingRow-1;
            }
            
            if (existingRow == requestedRow-1) {
                bottomIndex = 0;
            }
            else
            {
                bottomIndex = existingRow+1;
            }
        
            for (int x = 0; x < 3; x++) {
                switch(x){
                    //top Index
                    case 0:
                        temp.row = topIndex;
                        removePreviousDict = NO;
                        break;
                    case 1:
                        temp.row = midIndex;
                        break;
                    case 2:
                        temp.row = bottomIndex;
                        break;
                }
                //add the value to Dict
                int nextValue = [_gridView getCellValue:temp];
                
                //check if there is a total value lower or equal to 50
                if (nextValue + currentValue <= 50) {
                    unStuck = YES;
                    [self addtoDict:(nextValue + currentValue) gridViewIndex:temp curPath:existingPath];
                }
                
                //remove existingpath if there is a longer path available
                if (temp.row == bottomIndex && removePreviousDict) {
                    [tempDict removeObjectForKey:existingPath];
                }
            }
        }
        
        //save data if there is in last row and last column
        if (temp.column < requestedColumn-1 && unStuck) {
            unStuck = NO;
            [self addThreeValuesIntoDictionary];
            
        }
        else
        {
            [self saveLowestDict];
        }
        
    }
}

-(void)saveLowestDict
{
    NSMutableArray *allDictArrays = [[NSMutableArray alloc]initWithArray:[tempDict allKeys]];
    if (lowestDict == nil) {
        lowestDict = [[NSMutableDictionary alloc]init];
    }
    
    for (int x = 0; x < [tempDict count]; x++) {
        NSString *string = [[NSString alloc]initWithString:[allDictArrays objectAtIndex:x]];
        
        if (string.length == requestedColumn || !unStuck) {
            if ([lowestDict count] == 0) {
                [lowestDict setDictionary:[tempDict objectForKey:[allDictArrays objectAtIndex:x]]];
                [lowestDict setObject:[allDictArrays objectAtIndex:x] forKey:@"pathresistance"];
            }
            else
            {
                NSMutableDictionary *nextDict = [[NSMutableDictionary alloc]init];
                [nextDict setDictionary:[tempDict objectForKey:[allDictArrays objectAtIndex:x]]];
                [nextDict setObject:[allDictArrays objectAtIndex:x] forKey:@"pathresistance"];
                
                if ([[lowestDict objectForKey:@"totalresistance"]integerValue] > [[nextDict objectForKey:@"totalresistance"]integerValue]) {
                            NSLog(@"totalresist:%@", [lowestDict objectForKey:@"totalresistance"]);
                    lowestDict = nextDict;
                }
            }
        }
    }
    
//    if ([lowestDict count] == 0) {
//        NSInteger curCol = maxCol-1;
//        [self saveLowestDict:curCol];
//    }
//    else
//    {
        //save the lowest data
        if (unStuck) {
            [Tracker saveTemporary:[[lowestDict objectForKey:@"completepath"]boolValue] integer:(int)[[lowestDict objectForKey:@"totalresistance"]integerValue] path:[lowestDict objectForKey:@"pathresistance"]];
        }
        else
        {
            //if stuck find the longer path
            NSInteger maxStringLength = 0;
            for (int x = 0; x < [allDictArrays count]; x++) {
                NSInteger maxString = [[allDictArrays objectAtIndex:x]length];
                
                if (x == 0) {
                    maxStringLength = maxString;
                }
                else
                {
                    if(maxStringLength < maxString)
                    {
                        maxStringLength = maxString;
                    }
                }
            }
            
            //remove all shorter path
            for (int x = 0; x < [allDictArrays count]; x++)
            {
                if ([[allDictArrays objectAtIndex:x]length] < maxStringLength) {
                    [allDictArrays removeObjectAtIndex:x];
                    x--;
                }
            }
            
            //Sort the array
            NSArray *sorted = [allDictArrays sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
            
            NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
            [temp setDictionary:[tempDict objectForKey:[sorted objectAtIndex:0]]];
            [temp setObject:[sorted objectAtIndex:0] forKey:@"pathresistance"];
            
            [Tracker saveTemporary:[[temp objectForKey:@"completepath"]boolValue] integer:(int)[[temp objectForKey:@"totalresistance"]integerValue] path:[temp objectForKey:@"pathresistance"]];
            
        }
//    }
}
     
     

-(void)addtoDict:(int)totRes gridViewIndex:(MFGridViewIndex *)index curPath:(NSString*)curPath
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    removePreviousDict = YES;
    if (index.column == requestedColumn-1) {
        [dict setObject:@"YES" forKey:@"completepath"];
    }
    else
    {
        [dict setObject:@"NO" forKey:@"completepath"];
    }
    
    [dict setObject:[NSNumber numberWithInt:totRes] forKey:@"totalresistance"];
    
    curPath = [curPath stringByAppendingString:[NSString stringWithFormat:@"%d", (int)index.row]];
    [tempDict setObject:dict forKey:[NSString stringWithFormat:@"%@",curPath]];
    
}


@end
