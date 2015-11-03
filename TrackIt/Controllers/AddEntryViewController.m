//
//  AddEntryViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AddEntryViewController.h"
#import "AmountCell.h"
#import "NoteCell.h"
#import "DatePickerCell.h"
#import "UIColor+FlatUI.h"
#import "AppDelegate.h"
#import "NSDate+DateTools.h"

@interface AddEntryViewController ()

@property (nonatomic) BOOL datePickerShowing;
@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation AddEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    if(!self.entry)
        self.entry = [Entry entryWithAmount:nil note:nil date:[NSDate date] inManagedObjectContext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext];
}

#pragma mark - UIDatePicker

- (IBAction)dateChanged:(id)sender {
    self.entry.date = ((UIDatePicker *)sender).date;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UIBarPositioningDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - UITextFieldDelegate, UITextViewDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(!textField.text || [textField.text isEqualToString:@""])
        textField.text = @"$";
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.entry.amount = [self.formatter numberFromString:textField.text];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.entry.note = textView.text;
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Details";
    else if(section == 1)
        return @"Notes";
    else return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0)
        return @"Enter the date and amount you spent.";
    else if(section == 1)
        return @"Write a quick note to remind yourself what you spent this money on.";
    else return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForIndexPath:indexPath];
    if([identifier isEqualToString:@"datePickerCell"])
        return 216.0;
    else if([identifier isEqualToString:@"noteCell"])
        return 100.0;
    else return 44.0;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return self.datePickerShowing ? 3 : 2;
    else if(section == 2)
        return 2;
    else return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForIndexPath:indexPath];
    if([identifier isEqualToString:@"dateCell"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
        cell.detailTextLabel.text = [self.entry.date formattedDateWithFormat:@"MM/dd/YYYY hh:mm a"];
        
        return cell;
    }
    else if([identifier isEqualToString:@"amountCell"]) {
        AmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"amountCell" forIndexPath:indexPath];
        cell.textField.delegate = self;
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        
        return cell;
        
    }
    else if([identifier isEqualToString:@"noteCell"]) {
        NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        
        return cell;
    }
    else if([identifier isEqualToString:@"datePickerCell"]) {
        DatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell" forIndexPath:indexPath];
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"saveCell" forIndexPath:indexPath];
        if(indexPath.row == 0) {
            cell.textLabel.text = @"Save";
            cell.textLabel.textColor = [UIColor emeraldFlatColor];
        }
        else {
            cell.textLabel.text = @"Cancel";
            cell.textLabel.textColor = [UIColor redColor];
        }
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForIndexPath:indexPath];
    if([identifier isEqualToString:@"dateCell"]) {
        self.datePickerShowing = !self.datePickerShowing;
        if(self.datePickerShowing) {
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    else if([identifier isEqualToString:@"saveCell"]) {
        [self.tableView endEditing:YES];
        if(!self.entry.amount) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You forgot to enter an amount." preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSError *error;
            [((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext save:&error];
            if(error)
                NSLog(@"%@", error.localizedDescription);
            [self.delegate entryAddedOrChanged];
        }
    }
    else if([identifier isEqualToString:@"cancelCell"]){
        [((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext rollback];
        [self.delegate entryCanceled];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString *)identifierForIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0) {
        if(self.datePickerShowing) {
            if(indexPath.row == 0)
                return @"dateCell";
            else if(indexPath.row == 1)
                return @"datePickerCell";
            else
                return @"amountCell";
        }
        else {
            return indexPath.row == 0 ? @"dateCell" : @"amountCell";
        }
    }
    else if(indexPath.section == 1)
        return @"noteCell";
    else
        return indexPath.row == 0 ? @"saveCell" : @"cancelCell";
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

@end
