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
#import "DateTools.h"

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dividerLineHeightConstraint;
@property (strong, nonatomic) AllEntriesTableViewController *allEntriesVC;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) EntryModelType currentModelType;

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
        weakSelf.totalValueLabel.text = [weakSelf.formatter stringFromNumber:value];
        weakSelf.totalValueLabel.textColor = value.doubleValue >= 0 ? [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0] : [UIColor orangeColor];
    }];
    
    NSDate *currentStartDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE];
    NSDate *currentEndDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE];
    if(!currentStartDate) {
        NSDate *now = [NSDate date];
        currentStartDate = [NSDate dateWithYear:now.year month:now.month day:1];
        [[NSUserDefaults standardUserDefaults] setValue:currentStartDate forKey:USER_START_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(!currentEndDate) {
        NSDate *now = [NSDate date];
        currentEndDate = [NSDate dateWithYear:now.year month:now.month day:now.day];
        [[NSUserDefaults standardUserDefaults] setValue:currentEndDate forKey:USER_END_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self.dateButton setTitle:[NSString stringWithFormat:@"%@ to %@", [currentStartDate formattedDateWithStyle:NSDateFormatterMediumStyle], [currentEndDate formattedDateWithStyle:NSDateFormatterMediumStyle]] forState:UIControlStateNormal];
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
            total = [self.allEntriesVC updateValuesWithStartDate:[[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE] endDate:[[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE]];
            break;
    }
    self.totalValueLabel.text = [self.formatter stringFromNumber:total];
    self.totalValueLabel.textColor = total.doubleValue >= 0 ? [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0] : [UIColor orangeColor];
    
    NSDate *currentStartDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE];
    NSDate *currentEndDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE];
    [self.dateButton setTitle:[NSString stringWithFormat:@"%@ to %@", [currentStartDate formattedDateWithStyle:NSDateFormatterMediumStyle], [currentEndDate formattedDateWithStyle:NSDateFormatterMediumStyle]] forState:UIControlStateNormal];
}

#pragma mark - SelectDatesDelegate

-(void)newDatesSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateTotalDisplay];
}

-(void)dateSelectionCanceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"embedAllEntriesController"]) {
        self.allEntriesVC = segue.destinationViewController;
    }
    else if([segue.identifier isEqualToString:@"addEntrySegue"]) {
        UINavigationController *nav = segue.destinationViewController;
        AddEntryViewController *vc = (AddEntryViewController *)nav.topViewController;
        vc.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"selectDatesSegue"]) {
        SelectDatesViewController *vc = segue.destinationViewController;
        vc.delegate = self;
    }
}

#pragma mark - EntryDelegate
// This is delegate because 3D touch may be invoked from cold app start, and self.allEntriesVC wouldn't exist yet
-(void)entryAddedOrChanged {
    [self.allEntriesVC entryAddedOrChanged];
}

-(void)entryCanceled {
    [self.allEntriesVC entryCanceled];
}

@end
