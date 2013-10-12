//
//  PFUnitTableViewController.h
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFMetricViewController.h"

#define ENGLISH_UNITS   0
#define METRIC_UNITS    1

#define TOP_BUTTON_FROM_CONTROLLER      0
#define BOTTOM_BUTTON_FROM_CONTROLLER   1

@interface PFUnitTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UITableView *unitTable;
}

-(id)initWithUnitType:(NSInteger)unitType settingCallback:(PFMetricViewController *)controller fromButton:(NSInteger) button;

- (IBAction)onSegmentedControlClick:(id)sender;

@end
