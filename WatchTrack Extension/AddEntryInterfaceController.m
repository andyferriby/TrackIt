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
@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation AddEntryInterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    // Configure interface objects here.
    
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
}

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

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

@end



