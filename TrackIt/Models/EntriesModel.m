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

@property (nonatomic) NSNumber *timePeriod;
@property (strong, nonatomic) NSArray *entries;

@end

@implementation EntriesModel

-(instancetype)initWithTimePeriod:(NSNumber *)numberOfDays {
    self = [super init];
    if(self) {
        _timePeriod = numberOfDays;
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
    if(self.timePeriod) {
        NSDate *lowerBoundary = [[NSDate date] dateBySubtractingDays:self.timePeriod.integerValue];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"date > %@", lowerBoundary];
    }
    
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSError *error;
    self.entries = [context executeFetchRequest:fetchRequest error:&error];
    self.entries = [self.entries sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]]];
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(void)refreshWithNewTimePeriod:(NSNumber *)numberOfDays {
    self.timePeriod = numberOfDays;
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
