//
//  EntriesModel.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "EntriesModel.h"
#import "AppDelegate.h"
#import "NSDate+DateTools.h"

@interface EntriesModel()

@property (nonatomic) EntryModelType type;
@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) DTTimePeriod *datePeriod;

@end

@implementation EntriesModel

-(instancetype)initWithModelType:(EntryModelType)type {
    self = [super init];
    if(self) {
        _type = type;
    }
    return self;
}

-(instancetype)initWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self = [super init];
    if(self) {
        _type = EntryModelTypeDateRange;
        _datePeriod = [[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
    }
    return self;
}

-(NSArray *)entries {
    if(!_entries)
        [self refreshEntries];
    return _entries;
}

-(NSInteger)numberOfEntries {
    return self.entries.count;
}

-(Entry *)entryAtIndex:(NSInteger)index {
    return self.entries[index];
}

-(NSNumber *)totalSpending {
    return [self.entries valueForKeyPath:@"@sum.amount"];
}

-(void)refreshEntries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    switch(self.type) {
        case EntryModelTypeLast7Days: {
            NSDate *lowerBoundary = [[NSDate date] dateBySubtractingDays:7];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date > %@", lowerBoundary];
            break;
        }
        case EntryModelTypeThisMonth: {
            NSDate *now = [NSDate date];
            NSDate *lowerBoundary = [NSDate dateWithYear:now.year month:now.month day:1];
            fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date > %@", lowerBoundary];
            break;
        }
        case EntryModelTypeAllTime: {
            break;
        }
        case EntryModelTypeDateRange: {
            fetchRequest.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[NSPredicate predicateWithFormat:@"date > %@", self.datePeriod.StartDate], [NSPredicate predicateWithFormat:@"date < %@", self.datePeriod.EndDate]]];
            break;
        }
    }

    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSError *error;
    self.entries = [context executeFetchRequest:fetchRequest error:&error];
    self.entries = [self.entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(void)refreshEntriesWithModelType:(EntryModelType)type {
    self.type = type;
    self.datePeriod = nil;
    NSAssert(type != EntryModelTypeDateRange, @"Cannot set model type date range without providing start and end dates");
    [self refreshEntries];
}

-(void)refreshWithNewStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    self.type = EntryModelTypeDateRange;
    // Expect the date range to INCLUDE the end date, so add 1 to it
    endDate = [endDate dateByAddingDays:1];
    self.datePeriod = [[DTTimePeriod alloc] initWithStartDate:startDate endDate:endDate];
    [self refreshEntries];
}

-(void)deleteEntryAtIndex:(NSInteger)index {
    Entry *entry = self.entries[index];
    NSError *error;
    
    [((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext deleteObject:entry];
    [((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext save:&error];
    
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
    [self refreshEntries];
}

@end
