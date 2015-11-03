//
//  AllEntriesViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AllEntriesViewController.h"
#import "EntriesModel.h"

@interface AllEntriesViewController ()

@property (strong, nonatomic) EntriesModel *model;

@end

@implementation AllEntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [EntriesModel new];
}

#pragma mark - Action

- (IBAction)addTapped:(id)sender {
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfEntries];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EntryCell *cell = (EntryCell *)[tableView dequeueReusableCellWithIdentifier:@"entryCell"];
    
    Entry *entry = [self.model entryAtIndex:indexPath.row];
    cell.amountLabel.text = entry.amount.stringValue;

    cell.noteLabel.text = entry.note;
    
    return cell;
}

@end
