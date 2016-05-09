//
//  ContainerViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTools.h"
#import "SelectDatesViewController.h"
#import "AddEntryViewController.h"
#import "TrackIt-Swift.h"
#import "AppDelegate.h"

@interface ContainerViewController : UIViewController<UIPopoverPresentationControllerDelegate, SelectDatesDelegate, EntryDelegate, FilterTitleViewDelegate, TagFilterDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet FilterTitleView *filterTitleView;

@end
