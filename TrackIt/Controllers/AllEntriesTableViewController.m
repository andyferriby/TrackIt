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
#import "TrackIt-Swift.h"

@interface AllEntriesTableViewController ()

@property (strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) EmptyDataSetDataSource *emptyDataSetDataSource;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end

@implementation AllEntriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    DateFilter *thisMonthFilter = [[DateFilter alloc] initWithType:DateFilterTypeThisMonth];
    self.model = [[EntriesModel alloc] initWithFilters:@[thisMonthFilter] coreDataManager:[CoreDataStackManager sharedInstance]];
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.tableView.estimatedRowHeight = 96;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.emptyDataSetDataSource = [[EmptyDataSetDataSource alloc] initWithTitle:@"No Spending Recorded"
                                                             dataSetDescription:@"I guess you haven't spent any money recently! When you do, tap the + button below to record it."
                                                                 verticalOffset:-44.0f];
    self.tableView.emptyDataSetSource = self.emptyDataSetDataSource;
    self.tableView.tableFooterView = [UIView new];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreenFromBackground) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreenFromBackground) name:@"NewEntryFromWatch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScreenFromBackground) name:@"TagWasDeleted" object:nil];
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
    Entry *entry = [self.model entryAt:indexPath.row];
    
    [cell configureWithEntry:entry numberFormatter:self.numberFormatter];
    cell.selectionStyle = self.editing ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model deleteEntryAt:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadEmptyDataSet];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalSpending" object:self userInfo:@{@"total" : [self.model totalSpending]}];
        
        [self.appDelegate sendNewTotalToWatch];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(!self.editing)
        return;
    
    AddEntryViewController *editVC = [self.storyboard instantiateViewControllerWithIdentifier:@"addEditEntryVC"];
    editVC.delegate = self;
    editVC.title = @"Edit Entry";
    editVC.entry = [self.model entryAt:indexPath.row];
    [self presentViewController:editVC animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    // Needed to prevent setEditing:animated: from being called during swipe-to-delete
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
    
    [self.appDelegate sendNewTotalToWatch];
}

#pragma mark - Updates

-(void)updateScreenFromBackground {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.model refreshEntries];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView reloadEmptyDataSet];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTotalSpending" object:self userInfo:@{@"total" : [self.model totalSpending]}];
        
        [self.appDelegate sendNewTotalToWatch];
    });
}

-(NSNumber *)updateValuesWithFilters:(NSArray <id<Filterable>> *)filters {
    [self.model refreshWithFilters:filters];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadEmptyDataSet];
    return [self.model totalSpending];
}

-(TagFilter *)currentTagFilter {
    return [self.model currentTagFilter];
}

@end
