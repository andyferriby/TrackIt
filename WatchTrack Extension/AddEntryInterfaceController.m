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
    NSLog(@"Value: %d", value);
    value = value + 1;
    self.currentValue = @( self.currentValue.doubleValue - self.currentValue.integerValue + value );
    [self.valueLabel setText:[self.formatter stringFromNumber:self.currentValue]];
}
- (IBAction)centsValueChanged:(NSInteger)value {
    NSLog(@"Value: %d", value);
    self.currentValue = @( self.currentValue.integerValue + (double)(value/100.0) );
    [self.valueLabel setText:[self.formatter stringFromNumber:self.currentValue]];
}

- (IBAction)noteTapped {
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.jyjapps.trackit"];
    NSLog(@"%@", defaults.dictionaryRepresentation);
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
            NSLog(@"%@", results[0]);
            [self.noteLabel setText:[NSString stringWithFormat:@"\"%@\"", results[0]]];
            self.currentNote = results[0];
        }
    }];
}

- (IBAction)saveTapped {
    WatchSessionDelegate *watchDelegate = [WatchSessionDelegate new];
    [watchDelegate sendNewEntryToiPhone:self.currentValue note:self.currentNote completion:^(NSNumber *newTotal) {
        NSLog(@"New total: %@", newTotal);
        // Temp
        [self.delegate newEntryAdded:newTotal];
    } failure:^(NSError *error) {
        //TODO:
        // if failed, show a modal that says it failed or something
    }];
}

@end



