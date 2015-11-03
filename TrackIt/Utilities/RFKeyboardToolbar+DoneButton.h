//
//  RFKeyboardToolbar+DoneButton.h
//  Food Planner
//
//  Created by Jason Ji on 8/22/15.
//  Copyright (c) 2015 Jason Ji. All rights reserved.
//

#import "RFKeyboardToolbar.h"
#import "UIControl+Blocks.h"

@interface RFKeyboardToolbar (DoneButton)

-(void)addDoneButtonWithHandler:(void (^)(id sender))handler;

@end
