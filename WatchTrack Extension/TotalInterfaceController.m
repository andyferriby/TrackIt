//
//  InterfaceController.m
//  WatchTrack Extension
//
//  Created by Jason Ji on 11/4/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "TotalInterfaceController.h"
#import "WatchSessionDelegate.h"

@interface TotalInterfaceController()

@property (strong, nonatomic) NSNumberFormatter *formatter;

@end

@implementation TotalInterfaceController


-(NSNumberFormatter *)formatter {
    if(!_formatter) {
        _formatter = [NSNumberFormatter new];
        _formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    }
    return _formatter;
}

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];

    // Configure interface objects here.
    
    NSNumber *totalSpending = [[NSUserDefaults standardUserDefaults] valueForKey:@"TotalSpending"];
    if(totalSpending)
        [self.totalLabel setText:[self.formatter stringFromNumber:totalSpending]];
    else {
        WatchSessionDelegate *watchDelegate = [WatchSessionDelegate new];
        [watchDelegate requestTotalFromiPhoneWithCompletion:^(NSNumber *total, NSError *error) {
            if(error) {
                [self.totalLabel setText:@"Unable to Load"];
                [self.totalLabel setTextColor:[UIColor redColor]];
            }
            else
                [self.totalLabel setText:[self.formatter stringFromNumber:total]];
        }];
    }
        
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NewTotalReceived" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        NSNumber *total = note.userInfo[@"total"];
        [self.totalLabel setText:[self.formatter stringFromNumber:total]];
    }];
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



