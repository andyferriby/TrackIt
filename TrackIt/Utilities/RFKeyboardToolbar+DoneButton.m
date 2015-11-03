//
//  RFKeyboardToolbar+DoneButton.m
//  Food Planner
//
//  Created by Jason Ji on 8/22/15.
//  Copyright (c) 2015 Jason Ji. All rights reserved.
//

#import "RFKeyboardToolbar+DoneButton.h"

@implementation RFKeyboardToolbar (DoneButton)

-(void)addDoneButtonWithHandler:(void (^)(id sender))handler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button sizeToFit];
    [self addSubview:button];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:centerY];
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[button]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(button)];
    [self addConstraints:constraints];
    
    [self layoutIfNeeded];
    
    [button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
}

@end
