//
//  EntriesModel.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "Entry.h"
@import CoreData;
#import "DateTools.h"

typedef NS_ENUM(NSInteger, EntryModelType) {
    EntryModelTypeLast7Days,
    EntryModelTypeThisMonth,
    EntryModelTypeAllTime,
    EntryModelTypeDateRange
};

@interface EntriesModel : NSObject

-(instancetype)initWithModelType:(EntryModelType)type;
-(instancetype)initWithModelType:(EntryModelType)type startDate:(NSDate *)startDate endDate:(NSDate *)endDate;

-(NSInteger)numberOfEntries;
-(Entry *)entryAtIndex:(NSInteger)index;
-(NSNumber *)totalSpending;

-(void)refreshEntries;
-(void)refreshEntriesWithModelType:(EntryModelType)type;
-(void)refreshWithNewStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;
-(void)deleteEntryAtIndex:(NSInteger)index;

@end
