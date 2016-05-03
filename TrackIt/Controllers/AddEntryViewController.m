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
#import "RFKeyboardToolbar+DoneButton.h"

static NSInteger AMOUNT_TEXT_FIELD_CELL_TAG = 99;

@interface AddEntryViewController ()

@property (nonatomic) BOOL datePickerShowing;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) RFKeyboardToolbar *doneBar;
@property (weak, nonatomic) UITextView *onlyTextView;

@end

@implementation AddEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.formatter = [[NSNumberFormatter alloc] init];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    self.formatter.locale = [NSLocale currentLocale];
    self.formatter.lenient = YES;
    
    if(!self.entry)
        self.entry = [Entry entryWithAmount:nil note:nil date:[NSDate date] tags:nil inManagedObjectContext:((AppDelegate *)[UIApplication sharedApplication].delegate).managedObjectContext];
    
    
    RFToolbarButton *minusButton = [RFToolbarButton buttonWithTitle:@"+/-" andEventHandler:^{
        UITextField *textField = (UITextField *)[self.view viewWithTag:AMOUNT_TEXT_FIELD_CELL_TAG];
        NSString *firstChar = [textField.text substringWithRange:NSMakeRange(0, 1)];
        if([firstChar isEqualToString:@"-"])
            textField.text = [textField.text substringFromIndex:1];
        else
            textField.text = [NSString stringWithFormat:@"-%@", textField.text];
    } forControlEvents:UIControlEventTouchUpInside];
    
    self.doneBar = [RFKeyboardToolbar toolbarWithButtons:@[minusButton]];
    __weak AddEntryViewController *weakSelf = self;
    [self.doneBar addDoneButtonWithHandler:^(id sender) {
        [weakSelf.tableView endEditing:YES];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.tableView.estimatedRowHeight = 44.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UINavigationBarDelegate

-(UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

#pragma mark - Keyboard

- (void)keyboardDidShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height), 0.0);
    
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    
    if([self.onlyTextView isFirstResponder]) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

#pragma mark - UIDatePicker

- (IBAction)dateChanged:(id)sender {
    self.entry.date = ((UIDatePicker *)sender).date;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITextFieldDelegate, UITextViewDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(!textField.text || [textField.text isEqualToString:@""])
        textField.text = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString * proposedNewString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    
    if([proposedNewString rangeOfString:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]].location == NSNotFound)
        return NO;
    else return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(self.datePickerShowing) {
        self.datePickerShowing = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if([textField.text isEqualToString:[[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol]]) {
        textField.text = nil;
        self.entry.amount = nil;
    }
    else {
        self.entry.amount = [self.formatter numberFromString:textField.text];
        if(self.entry.amount)
            textField.text = [self.formatter stringFromNumber:self.entry.amount];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView {
    if(self.datePickerShowing) {
        self.datePickerShowing = NO;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    self.entry.note = [textView.text isEqualToString:@""] ? nil : textView.text;
}

#pragma mark - UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return @"Details";
    else if(section == 1)
        return @"Notes";
    else if(section == 2)
        return @"Tags";
    else return nil;
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if(section == 0)
        return @"Enter the date and amount you spent.";
    else if(section == 1)
        return @"Write a quick note to remind yourself what you spent this money on.";
    else if(section == 2)
        return @"Optionally, add tags to sort your entries.";
    else return nil;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0)
        return self.datePickerShowing ? 3 : 2;
    else if(section == 1)
        return 1;
    else if(section == 2)
        return 1;
    else if(section == 3)
        return 2;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self identifierForIndexPath:indexPath];
    if([identifier isEqualToString:@"dateCell"]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dateCell" forIndexPath:indexPath];
        cell.detailTextLabel.text = [self.entry.date formattedDateWithFormat:@"M/dd/YYYY"];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        return cell;
    }
    else if([identifier isEqualToString:@"amountCell"]) {
        AmountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"amountCell" forIndexPath:indexPath];
        cell.textField.delegate = self;
        cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
        cell.textField.inputAccessoryView = self.doneBar;
        cell.textField.textColor = [UIColor colorWithRed:3/255.0 green:166/255.0 blue:120/255.0 alpha:1.0];
        cell.textField.tag = AMOUNT_TEXT_FIELD_CELL_TAG;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textField.text = [self.formatter stringFromNumber:self.entry.amount];
        
        return cell;
        
    }
    else if([identifier isEqualToString:@"noteCell"]) {
        NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell" forIndexPath:indexPath];
        cell.textView.delegate = self;
        cell.textView.inputAccessoryView = self.doneBar;
        cell.textView.text = self.entry.note;
        self.onlyTextView = cell.textView;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if([identifier isEqualToString:@"datePickerCell"]) {
        DatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"datePickerCell" forIndexPath:indexPath];
        cell.datePicker.date = self.entry.date;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if([identifier isEqualToString:@"tagsCell"]) {
        TagsCell *cell = (TagsCell *)[tableView dequeueReusableCellWithIdentifier:@"tagsCell" forIndexPath:indexPath];
        [cell configureWithEntry:self.entry];
        cell.delegate = self;
        
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
    NSString *identifier = [self identifierForIndexPath:indexPath];
    if([identifier isEqualToString:@"dateCell"]) {
        self.datePickerShowing = !self.datePickerShowing;
        if(self.datePickerShowing) {
            [tableView endEditing:YES];
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
        else if(!self.entry.note) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Oops" message:@"You forgot to record a note." preferredStyle:UIAlertControllerStyleAlert];
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
    else if(indexPath.section == 2)
        return @"tagsCell";
    else
        return indexPath.row == 0 ? @"saveCell" : @"cancelCell";
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(scrollView.dragging || scrollView.decelerating)
        [self.tableView endEditing:YES];
}

#pragma mark - TagsCellDelegate

-(void)tagsCellDidTapAddTag:(TagsCell *)cell {
    [self performSegueWithIdentifier:@"addTags" sender:self];
}

-(void)tagsCell:(TagsCell *)cell didTapTagTitle:(NSString *)title {
    
}

-(void)tagsCell:(TagsCell *)cell didTapRemoveButtonForTitle:(NSString *)title {
    NSArray<Tag *> *filteredTags = [self.entry.tags.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name == %@", title]];
    if(filteredTags.count > 0) {
        Tag *tag = filteredTags.firstObject;
        [self.entry removeTagsObject:tag];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - AddTagsControllerDelegate
-(void)didFinishAddingTags:(NSArray<Tag *> *)tags {
    [self.entry addTags:[NSSet setWithArray:tags]];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"addTags"]) {
        UINavigationController *navVC = segue.destinationViewController;
        AddTagsTableViewController *tagsVC = (AddTagsTableViewController *)navVC.topViewController;
        tagsVC.delegate = self;
    }
}

@end
