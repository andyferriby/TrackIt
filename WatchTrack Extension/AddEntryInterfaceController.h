//
//  AddEntryInterfaceController.h
//  TrackIt
//
//  Created by Jason Ji on 11/4/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "WatchSessionDelegate.h"
#import "NewEntryDelegate.h"

@interface AddEntryInterfaceController : WKInterfaceController

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *addEntryGroup;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *dollarPicker;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfacePicker *centsPicker;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *valueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *noteLabel;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *savingGroup;

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *savingTitleLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *savingErrorLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceGroup *savedDetailGroup;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *savedValueLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *savedNoteLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *doneButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *tryAgainButton;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceButton *cancelButton;

@end
