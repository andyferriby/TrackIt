//
//  AllEntriesViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

@import UIKit;
#import "EntryCell.h"
#import "UIScrollView+EmptyDataSet.h"
#import "AddEntryViewController.h"

@interface AllEntriesViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, EntryDelegate>

@end
