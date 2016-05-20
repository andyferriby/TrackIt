//
//  AllEntriesTableViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

@import UIKit;
#import "TrackIt-Swift.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AddEntryViewController.h"

@interface AllEntriesTableViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EntryDelegate>

@property (strong, nonatomic) EntriesModel *model;
-(NSNumber *)updateValuesWithFilters:(NSArray <id<Filterable>> *)filters;
-(TagFilter *)currentTagFilter;

@end
