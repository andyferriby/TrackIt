//
//  AddEntryViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

@import UIKit;
#import "Entry.h"

@protocol EntryDelegate <NSObject>

-(void)entryAddedOrChanged;
-(void)entryCanceled;

@end

@interface AddEntryViewController : UIViewController<UIBarPositioningDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Entry *entry;
@property (weak, nonatomic) id<EntryDelegate>delegate;

@end
