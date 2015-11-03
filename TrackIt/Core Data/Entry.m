//
//  Entry.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "Entry.h"

@implementation Entry

+(instancetype)entryWithAmount:(NSNumber *)amount note:(NSString *)note date:(NSDate *)date inManagedObjectContext:(nonnull NSManagedObjectContext *)context {
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    entry.amount = amount;
    entry.note = note;
    entry.date = date;
    return entry;
}

@end
