//
//  SelectDatesViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/15/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTools.h"

#define USER_START_DATE @"userStartDate"
#define USER_END_DATE @"userEndDate"

@protocol SelectDatesDelegate <NSObject>

-(void)newDatesSelected;
-(void)dateSelectionCanceled;

@end

@interface SelectDatesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIBarPositioningDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id<SelectDatesDelegate> delegate;
@end
