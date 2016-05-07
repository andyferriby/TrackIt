//
//  AddEntryInterfaceController.m
//  TrackIt
//
//  Created by Jason Ji on 11/4/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "AddEntryInterfaceController.h"

@interface AddEntryInterfaceController ()

@property (strong, nonatomic) NSNumber *currentValue;
@property (strong, nonatomic) NSString *currentNote;
@property (strong, nonatomic) NSNumberFormatter *formatter;
@property (strong, nonatomic) NSNumber *theNewTotal;

@property (weak, nonatomic) id<EntryDelegate>delegate;

@end

@implementation AddEntryInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    self.delegate = context;
    
    self.formatter = [NSNumberFormatter new];
    self.formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    NSMutableArray *dollarItems = [NSMutableArray new];
    for(NSInteger i = 0; i < 100; i++) {
        WKPickerItem *item = [[WKPickerItem alloc] init];
        item.title = @(i+1).stringValue;
        item.caption = @"Dollars";
        [dollarItems addObject:item];
    }
    [self.dollarPicker setItems:dollarItems];
    
    NSMutableArray *centItems = [NSMutableArray new];
    for(NSInteger i = 0; i < 100; i++) {
        WKPickerItem *item = [[WKPickerItem alloc] init];
        if(i < 10)
            item.title = [NSString stringWithFormat:@"0%@", @(i)];
        else
            item.title = @(i).stringValue;
        item.caption = @"Cents";
        [centItems addObject:item];
    }
    [self.centsPicker setItems:centItems];
    
    self.currentValue = @1;
    self.currentNote = @"Posted from Apple Watch";
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

#pragma mark - IBAction

- (IBAction)dollarsValueChanged:(NSInteger)value {
    value = value + 1;
    self.currentValue = @( self.currentValue.doubleValue - self.currentValue.integerValue + value );
    [self.valueLabel setText:[self.formatter stringFromNumber:self.currentValue]];
}
- (IBAction)centsValueChanged:(NSInteger)value {
    self.currentValue = @( self.currentValue.integerValue + (double)(value/100.0) );
    [self.valueLabel setText:[self.formatter stringFromNumber:self.currentValue]];
}

- (IBAction)noteTapped {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.jyjapps.trackit"];

    NSString *first = [defaults objectForKey:@"quickNote"];
    NSString *second = [defaults objectForKey:@"quickNote2"];
    NSString *third = [defaults objectForKey:@"quickNote3"];
    NSString *fourth = [defaults objectForKey:@"quickNote4"];
    NSString *fifth = [defaults objectForKey:@"quickNote5"];
    
    NSMutableArray *options = [NSMutableArray new];
    if(first)
        [options addObject:first];
    if(second)
        [options addObject:second];
    if(third)
        [options addObject:third];
    if(fourth)
        [options addObject:fourth];
    if(fifth)
        [options addObject:fifth];
    
    [self presentTextInputControllerWithSuggestions:options allowedInputMode:WKTextInputModePlain completion:^(NSArray * _Nullable results) {
        if(results && results[0]) {
            [self.noteLabel setText:[NSString stringWithFormat:@"\"%@\"", results[0]]];
            self.currentNote = results[0];
        }
    }];
}

-(id)contextForSegueWithIdentifier:(NSString *)segueIdentifier {
    if([segueIdentifier isEqualToString:@"savingSegue"]) {
        return @{@"value" : self.currentValue, @"note" : self.currentNote, @"delegate" : self.delegate};
    }
    return nil;
}

- (IBAction)saveTapped {
    [self.addEntryGroup setHidden:YES];
    [self.savingGroup setHidden:NO];
    
    WatchSessionDelegate *watchDelegate = [WatchSessionDelegate new];
    [watchDelegate sendNewEntryToiPhone:self.currentValue note:self.currentNote completion:^(NSNumber *newTotal) {
        [self setTitle:@" "];
        self.theNewTotal = newTotal;
        [self.savingTitleLabel setText:@"Success"];
        [self.savedDetailGroup setHidden:NO];
        [self.savedValueLabel setText:[self.formatter stringFromNumber:self.currentValue]];
        [self.savedNoteLabel setText:[NSString stringWithFormat:@"\"%@\"", self.currentNote]];
        [self.doneButton setHidden:NO];
        
    } failure:^(NSError *error) {
        // if failed, show a modal that says it failed or something
        [self.savedDetailGroup setHidden:YES];
        [self.savingErrorLabel setHidden:NO];
        [self.savingTitleLabel setText:@"Save Failed"];
        [self.savingErrorLabel setText:error.localizedDescription];
        [self.savingTitleLabel setTextColor:[UIColor redColor]];
        [self.doneButton setHidden:YES];
        [self.tryAgainButton setHidden:NO];
        [self.cancelButton setHidden:NO];
    }];
}

- (IBAction)doneTapped {
    [self.delegate newEntryAdded:self.theNewTotal];
}
- (IBAction)tryAgainTapped {
    [self.savedDetailGroup setHidden:YES];
    [self.savingErrorLabel setHidden:YES];
    [self.doneButton setHidden:YES];
    [self.tryAgainButton setHidden:YES];
    [self.cancelButton setHidden:YES];
    [self saveTapped];
}
- (IBAction)cancelTapped {
    [self.delegate newEntryCanceled];
}

@end



