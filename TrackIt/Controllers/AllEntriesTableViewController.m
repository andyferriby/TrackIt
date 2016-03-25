//
//  AllEntriesTableViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AllEntriesTableViewController.h"
#import "NSDate+DateTools.h"
#import "AppDelegate.h"

@interface AllEntriesTableViewController ()

@property (strong, nonatomic) EntriesModel *model;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

@end

@implementation AllEntriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[EntriesModel alloc] initWithModelType:EntryModelTypeThisMonth];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.tableView.estimatedRowHeight = 96;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreenFromBackground) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

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
    cell.amountLabel.textColor = entry.amount.doubleValue > 0 ? [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0] : [UIColor orangeColor];
    cell.dateLabel.text = [entry.date formattedDateWithFormat:@"MM/dd/YYYY hh:mm a"];
    cell.noteLabel.text = entry.note;
    
    cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = self.editing ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model deleteEntryAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadEmptyDataSet];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalSpending" object:self userInfo:@{@"total" : [self.model totalSpending]}];
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate sendNewTotalToWatch];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.editing)
        return;
        
    AddEntryViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addEditEntryVC"];
    editVC.delegate = self;
    editVC.title = @"Edit Entry";
    editVC.entry = [self.model entryAtIndex:indexPath.row];
    [self presentViewController:editVC animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Needed to prevent setEditing:animated: from being called during swipe-to-delete
}

#pragma mark - DZNEmptyDataSet

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"No Spending Recorded";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:20.0f],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:1/255.0 green:152/255.0 blue:117/255.0 alpha:1.0]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"I guess you haven't spent any money recently! When you do, tap the + button below to record it.";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName: paragraph};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -1*self.navigationController.navigationBar.frame.size.height;
}

#pragma mark - EntryDelegate

-(void)entryCanceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)entryAddedOrChanged {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.model refreshEntries];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalSpending" object:self userInfo:@{@"total" : [self.model totalSpending]}];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate sendNewTotalToWatch];
}

#pragma mark - Totals

-(void)updateScreenFromBackground {
    [self.model refreshEntries];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalSpending" object:self userInfo:@{@"total" : [self.model totalSpending]}];
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate sendNewTotalToWatch];
}

-(NSNumber *)updateValuesWithEntryModelType:(EntryModelType)type {
    [self.model refreshEntriesWithModelType:type];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
    return [self.model totalSpending];
}

-(NSNumber *)updateValuesWithStartDate:(NSDate *)startDate endDate:(NSDate *)endDate {
    [self.model refreshWithNewStartDate:startDate endDate:endDate];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
    return [self.model totalSpending];
}

@end
