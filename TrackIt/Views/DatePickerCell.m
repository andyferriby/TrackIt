//
//  DatePickerCell.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "DatePickerCell.h"

@implementation DatePickerCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.datePicker.maximumDate = [NSDate date];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
