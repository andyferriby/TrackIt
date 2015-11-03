//
//  AllEntriesViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AllEntriesViewController.h"
#import "EntriesModel.h"
#import "NSDate+DateTools.h"
#import "AppDelegate.h"

@interface AllEntriesViewController ()

@property (strong, nonatomic) EntriesModel *model;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation AllEntriesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [EntriesModel new];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.tableView.estimatedRowHeight = 96;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
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
    cell.amountLabel.text = [self.numberFormatter stringFromNumber:entry.amount];
    cell.dateLabel.text = [[NSDate date] formattedDateWithFormat:@"MM/dd/YYYY hh:mm a"];
    cell.noteLabel.text = entry.note;
    
    return cell;
}

#pragma mark - DZNEmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Spending Recorded";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0f],
                                 NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"I guess you haven't spent any money yet! When you do, tap the + button below to record it.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - EntryDelegate

-(void)entryCanceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)entryAddedOrChanged {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.model refreshEntries];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addEntrySegue"]) {
        AddEntryViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

@end
