//
//  ContainerViewController.h
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContainerViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalValueLabel;

@end
