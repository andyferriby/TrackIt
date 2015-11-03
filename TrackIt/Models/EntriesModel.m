//
//  EntriesModel.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "EntriesModel.h"
#import "AppDelegate.h"

@interface EntriesModel()

@property (strong, nonatomic) NSArray *entries;

@end

@implementation EntriesModel

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

-(void)refreshEntries {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Entry"];
    NSManagedObjectContext *context = ((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext;
    NSError *error;
    self.entries = [context executeFetchRequest:fetchRequest error:&error];
    if(error) {
        NSLog(@"%@", error.localizedDescription);
    }
}

@end
