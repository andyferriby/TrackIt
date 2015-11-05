//
//  ContainerViewController.m
//  TrackIt
//
//  Created by Jason Ji on 11/2/15.
//  Copyright © 2015 Jason Ji. All rights reserved.
//

#import "ContainerViewController.h"
#import "AddEntryViewController.h"
#import "AllEntriesTableViewController.h"

@interface ContainerViewController ()

@property (strong, nonatomic) AllEntriesTableViewController *allEntriesVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.allEntriesVC setEditing:editing animated:animated];
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"embedAllEntriesController"]) {
        self.allEntriesVC = segue.destinationViewController;
    }
    if([segue.identifier isEqualToString:@"addEntrySegue"]) {
        AddEntryViewController *vc = segue.destinationViewController;
        vc.delegate = self.allEntriesVC;
    }
}

@end
