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
@property (strong, nonatomic) NSNumber *currentTimePeriod;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.dividerLineHeightConstraint.constant = 0.5;
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    self.totalTitleLabel.text = @"Last 7 Days Total";
    self.currentTimePeriod = @7;
    
    __weak ContainerViewController *weakSelf = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NewTotalSpending" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *value = note.userInfo[@"total"];
        self.totalValueLabel.text = [weakSelf.formatter stringFromNumber:value];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    NSNumber *total = [self.allEntriesVC updateValuesWithTimePeriod:self.currentTimePeriod];
    self.totalValueLabel.text = [self.formatter stringFromNumber:total];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.allEntriesVC setEditing:editing animated:animated];
}

- (IBAction)timePeriodSelected:(UISegmentedControl *)sender {
    switch(sender.selectedSegmentIndex) {
        case 0:
            self.currentTimePeriod = @7;
            self.totalTitleLabel.text = @"Last 7 Days Total";
            break;
        case 1:
            self.currentTimePeriod = @30;
            self.totalTitleLabel.text = @"Last 30 Days Total";
            break;
        case 2:
            self.currentTimePeriod = nil;
            self.totalTitleLabel.text = @"All Time Total";
            break;
    }
    NSNumber *total = [self.allEntriesVC updateValuesWithTimePeriod:self.currentTimePeriod];
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
