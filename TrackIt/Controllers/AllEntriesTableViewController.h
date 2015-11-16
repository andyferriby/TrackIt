//
//  AllEntriesTableViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

@import UIKit;
#import "EntryCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AddEntryViewController.h"
#import "EntriesModel.h"

@interface AllEntriesTableViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EntryDelegate>

-(NSNumber *)updateValuesWithEntryModelType:(EntryModelType)type;
-(NSNumber *)updateValuesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate;

@end
