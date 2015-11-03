//
//  Entry.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Entry : NSManagedObject

+(instancetype)entryWithAmount:(NSNumber *)amount note:(nullable NSString *)note date:(NSDate *)date inManagedObjectContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "Entry+CoreDataProperties.h"
