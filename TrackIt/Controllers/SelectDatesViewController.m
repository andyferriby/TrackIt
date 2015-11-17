//
//  SelectDatesViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/15/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#define USER_START_DATE @"userStartDate"
#define USER_END_DATE @"userEndDate"

#import "SelectDatesViewController.h"
#import "DatePickerCell.h"

@interface SelectDatesViewController ()

@property (strong, nonatomic) NSDate *currentStartDate;
@property (strong, nonatomic) NSDate *currentEndDate;
@property (strong, nonatomic) NSIndexPath *datePickerIndexPath;

@end

@implementation SelectDatesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentStartDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_START_DATE];
    self.currentEndDate = [[NSUserDefaults standardUserDefaults] valueForKey:USER_END_DATE];
    if(!self.currentStartDate) {
        NSDate *now = [NSDate date];
        self.currentStartDate = [NSDate dateWithYear:now.year month:now.month day:1];
        [[NSUserDefaults standardUserDefaults] setValue:self.currentStartDate forKey:USER_START_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    if(!self.currentEndDate) {
        self.currentEndDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setValue:self.currentEndDate forKey:USER_END_DATE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? (self.datePickerIndexPath ? 3 : 2) : 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForRowAtIndexPath:indexPath];
    return [identifier isEqualToString:@"datePickerCell"] ? 216 : 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForRowAtIndexPath:indexPath];
    if([identifier isEqualToString:@"startDateCell"] || [identifier isEqualToString:@"endDateCell"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSDate *thisDate = [identifier isEqualToString:@"startDateCell"] ? self.currentStartDate : self.currentEndDate;
        cell.textLabel.text = [identifier isEqualToString:@"startDateCell"] ? @"Start Date" : @"End Date";
        cell.detailTextLabel.text = [thisDate formattedDateWithFormat:@"MM/dd/YYYY hh:mm a"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
    }
    else if([identifier isEqualToString:@"datePickerCell"]) {
        DatePickerCell *cell = (DatePickerCell *)[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saveCell" forIndexPath:indexPath];
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Save";
            cell.textLabel.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0];
        }
        else {
            cell.textLabel.text = @"Cancel";
            cell.textLabel.textColor = [UIColor redColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *identifier = [self identifierForRowAtIndexPath:indexPath];
    if([identifier isEqualToString:@"startDateCell"]) {
        if(!self.datePickerIndexPath) {
            self.datePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tableView insertRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            if(self.datePickerIndexPath.row == 1) {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.datePickerIndexPath = nil;
                [tableView endUpdates];
            }
            else {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.datePickerIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [tableView insertRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
        }
    }
    else if([identifier isEqualToString:@"endDateCell"]) {
        if(!self.datePickerIndexPath) {
            self.datePickerIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tableView insertRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            if(self.datePickerIndexPath.row == 2) {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.datePickerIndexPath = nil;
                [tableView endUpdates];
            }
            else {
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                self.datePickerIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [tableView insertRowsAtIndexPaths:@[self.datePickerIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView endUpdates];
            }
        }
    }
    else if([identifier isEqualToString:@"saveCell"]) {
        [self.delegate newDatesSelected];
    }
    else if([identifier isEqualToString:@"cancelCell"]) {
        [self.delegate dateSelectionCanceled];
    }
}

-(NSString *)identifierForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
                case 0:
                    return @"startDateCell";
                case 1:
                    if(self.datePickerIndexPath && self.datePickerIndexPath.row == 1)
                        return @"datePickerCell";
                    else
                        return @"endDateCell";
                case 2:
                    if(self.datePickerIndexPath && self.datePickerIndexPath.row == 2)
                        return @"datePickerCell";
                    else
                        return @"endDateCell";
            }
        case 1:
            return indexPath.row == 0 ? @"saveCell" : @"cancelCell";
        default:
            return nil;
    }
}

@end
