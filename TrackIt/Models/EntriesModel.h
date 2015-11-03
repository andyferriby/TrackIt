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

-(NSInteger)numberOfEntries;
-(Entry *)entryAtIndex:(NSInteger)index;

-(void)refreshEntries;
-(void)deleteEntryAtIndex:(NSInteger)index;

@end
