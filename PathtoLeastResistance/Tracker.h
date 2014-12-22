//
//  Tracker.h
//  PathtoLeastResistance
//
//  Created by Frans Raharja Kurniawan on 12/18/14.
//  Copyright (c) 2014 Frans Kurniawan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tracker : NSObject

@property (assign, nonatomic) BOOL completePath;

@property (assign, nonatomic) NSInteger totalResistance;

@property (strong, nonatomic) NSString *pathResistance;

+ (void) saveTemporary:(BOOL)complete integer:(int)tempInteger path:(NSString *)path;

+ (void)loadTemporary:(Tracker*)track;

+ (NSInteger)loadTotalResistance;

+ (void)resetSavedData;

@end
