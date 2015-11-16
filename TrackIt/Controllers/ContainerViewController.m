//
//  ContainerViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "ContainerViewController.h"
#import "AddEntryViewController.h"
#import "AllEntriesTableViewController.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLineHeightConstraint;
@property (strong, nonatomic) AllEntriesTableViewController *allEntriesVC;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) EntryModelType currentModelType;
@property (strong, nonatomic) NSDate *currentStartDate;
@property (strong, nonatomic) NSDate *currentEndDate;

@end

@implementation ContainerViewController

-(NSDateFormatter *)dateFormatter {
    if(!_dateFormatter) {
        _dateFormatter = [NSDateFormatter new];
        _dateFormatter.dateFormat = @"MMMM";
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.dividerLineHeightConstraint.constant = 0.5;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.currentModelType = EntryModelTypeThisMonth;
    
    self.totalTitleLabel.text = [NSString stringWithFormat:@"%@ Total", [self.dateFormatter stringFromDate:[NSDate date]]];
    
    __weak ContainerViewController *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NewTotalSpending" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *value = note.userInfo[@"total"];
        self.totalValueLabel.text = [weakSelf.formatter stringFromNumber:value];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [self updateTotalDisplay];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.allEntriesVC setEditing:editing animated:animated];
}

- (IBAction)timePeriodSelected:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex) {
        case 0: {
            self.currentModelType = EntryModelTypeThisMonth;
            self.dateButton.hidden = YES;
            self.totalTitleLabel.hidden = NO;
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%@ Total", [self.dateFormatter stringFromDate:[NSDate date]]];
            break;
        }
        case 1:
            self.currentModelType = EntryModelTypeAllTime;
            self.dateButton.hidden = YES;
            self.totalTitleLabel.hidden = NO;
            self.totalTitleLabel.text = @"All Time Total";
            break;
        case 2:
            self.currentModelType = EntryModelTypeDateRange;
            // set current start/end dates if not set
            // DEBUG: 10/1/15 to 10/15/2015
            self.currentStartDate = [NSDate dateWithYear:2015 month:10 day:1];
            self.currentEndDate = [NSDate dateWithYear:2015 month:10 day:15];
            self.dateButton.hidden = NO;
            self.totalTitleLabel.hidden = YES;
            break;
    }
    [self updateTotalDisplay];
}

-(void)updateTotalDisplay {
    NSNumber *total;
    switch(self.currentModelType) {
        case EntryModelTypeLast7Days:
            break;
        case EntryModelTypeThisMonth:
            total = [self.allEntriesVC updateValuesWithEntryModelType:EntryModelTypeThisMonth];
            break;
        case EntryModelTypeAllTime:
            total = [self.allEntriesVC updateValuesWithEntryModelType:EntryModelTypeAllTime];
            break;
        case EntryModelTypeDateRange:
            total = [self.allEntriesVC updateValuesWithStartDate:self.currentStartDate endDate:self.currentEndDate];
            break;
    }
    self.totalValueLabel.text = [self.formatter stringFromNumber:total];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"embedAllEntriesController"]) {
        self.allEntriesVC = segue.destinationViewController;
    }
    if([segue.identifier isEqualToString:@"addEntrySegue"]) {
        AddEntryViewController *vc = segue.destinationViewController;
        vc.delegate = self.allEntriesVC;
    }
}

@end
