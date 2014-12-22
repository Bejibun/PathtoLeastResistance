//
//  Tracker.m
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/18/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import "Tracker.h"

@implementation Tracker
@synthesize completePath, totalResistance, pathResistance;

+ (void) saveTemporary:(BOOL)complete integer:(int)tempInteger path:(NSString *)path
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:complete forKey:@"completepath"];
    [defaults setInteger:tempInteger forKey:@"totalresistance"];
    [defaults setObject:path forKey:@"pathresistance"];
    
    //[[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)loadTemporary:(Tracker *)track
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    track.completePath = [[defaults objectForKey:@"completepath"]integerValue];
    track.totalResistance = [[defaults objectForKey:@"totalresistance"] integerValue];
    track.pathResistance = [defaults objectForKey:@"pathresistance"];

}

+ (NSInteger)loadTotalResistance
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger intTotalResistance = [[defaults objectForKey:@"totalresistance"] integerValue];
    
    return intTotalResistance;
}

+ (void)resetSavedData
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}

@end
