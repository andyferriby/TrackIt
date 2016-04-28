//
//  AddEntryViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

@import UIKit;
#import "TrackIt-Swift.h"

@protocol EntryDelegate <NSObject>

-(void)entryAddedOrChanged;
-(void)entryCanceled;

@end

@interface AddEntryViewController : UITableViewController<UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, TagsCellDelegate, AddTagsControllerDelegate>

@property (strong, nonatomic) Entry *entry;
@property (weak, nonatomic) id<EntryDelegate>delegate;

@end
