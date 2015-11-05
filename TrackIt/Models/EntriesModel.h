//
//  EntriesModel.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "Entry.h"
@import CoreData;

@interface EntriesModel : NSObject

-(instancetype)initWithTimePeriod:(NSNumber *)numberOfDays;

-(NSInteger)numberOfEntries;
-(Entry *)entryAtIndex:(NSInteger)index;
-(NSNumber *)totalSpending;

-(void)refreshEntries;
-(void)refreshWithNewTimePeriod:(NSNumber *)numberOfDays;
-(void)deleteEntryAtIndex:(NSInteger)index;

@end
