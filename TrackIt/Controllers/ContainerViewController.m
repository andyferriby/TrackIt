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

const CGFloat defaultFilterTitleViewHeight = 30.0f;

@interface ContainerViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDividerLineHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterTitleViewHeightConstraint;
@property (strong, nonatomic) AllEntriesTableViewController *allEntriesVC;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;

@property (nonatomic) DateFilterType currentModelType;

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
    self.bottomDividerLineHeightConstraint.constant = 0.5;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.currentModelType = DateFilterTypeThisMonth;
    
    self.totalTitleLabel.text = [NSString stringWithFormat:@"%@ Total", [self.dateFormatter stringFromDate:[NSDate date]]];
    
    __weak ContainerViewController *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NewTotalSpending" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *value = note.userInfo[@"total"];
        weakSelf.totalValueLabel.text = [weakSelf.formatter stringFromNumber:value];
        weakSelf.totalValueLabel.textColor = value.doubleValue >= 0 ? [ColorManager moneyColor] : [UIColor orangeColor];
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
    
    self.filterTitleView.delegate = self;
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
            self.currentModelType = DateFilterTypeThisMonth;
            self.dateButton.hidden = YES;
            self.totalTitleLabel.hidden = NO;
            self.totalTitleLabel.text = [NSString stringWithFormat:@"%@ Total", [self.dateFormatter stringFromDate:[NSDate date]]];
            break;
        }
        case 1:
            self.currentModelType = DateFilterTypeAllTime;
            self.dateButton.hidden = YES;
            self.totalTitleLabel.hidden = NO;
            self.totalTitleLabel.text = @"All Time Total";
            break;
        case 2:
            self.currentModelType = DateFilterTypeDateRange;
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
        case DateFilterTypeLast7Days:
            break;
        case DateFilterTypeThisMonth: {
            DateFilter *filter = [[DateFilter alloc] initWithType:DateFilterTypeThisMonth];
            total = [self.allEntriesVC updateValuesWithFilters:@[filter]];
            break;
        }
        case DateFilterTypeAllTime: {
            DateFilter *filter = [[DateFilter alloc] initWithType:DateFilterTypeAllTime];
            total = [self.allEntriesVC updateValuesWithFilters:@[filter]];
            break;
        }
        case DateFilterTypeDateRange: {
            DateFilter *filter = [[DateFilter alloc] initWithType:DateFilterTypeDateRange startDate:[[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE] endDate:[[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE]];
            total = [self.allEntriesVC updateValuesWithFilters:@[filter]];
            break;
        }
    }
    self.totalValueLabel.text = [self.formatter stringFromNumber:total];
    self.totalValueLabel.textColor = total.doubleValue >= 0 ? [ColorManager moneyColor] : [UIColor orangeColor];
    
    NSDate *currentStartDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE];
    NSDate *currentEndDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE];
    [self.dateButton setTitle:[NSString stringWithFormat:@"%@ to %@", [currentStartDate formattedDateWithStyle:NSDateFormatterMediumStyle], [currentEndDate formattedDateWithStyle:NSDateFormatterMediumStyle]] forState:UIControlStateNormal];
}

-(void)showFilterTitleView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.filterTitleView.alpha = 1.0;
        self.filterTitleViewHeightConstraint.constant = defaultFilterTitleViewHeight;
        [self.view layoutIfNeeded];
    } completion:nil];
}

-(void)hideFilterTitleView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.filterTitleView.alpha = 0;
        self.filterTitleViewHeightConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - SelectDatesDelegate

-(void)newDatesSelected {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self updateTotalDisplay];
}

-(void)dateSelectionCanceled {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - FilterTitleViewDelegate

-(void)closeViewTapped {
    [self hideFilterTitleView];
    TagFilter *noTagFilter = [[TagFilter alloc] initWithTags:@[]];
    [self.allEntriesVC updateValuesWithFilters:@[noTagFilter]];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"embedAllEntriesController"]) {
        self.allEntriesVC = segue.destinationViewController;
    }
    else if([segue.identifier isEqualToString:@"addEntrySegue"]) {
        AddEntryViewController *vc = segue.destinationViewController;
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
