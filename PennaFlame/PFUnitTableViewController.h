//
//  PFUnitTableViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFMetricViewController;

#define ENGLISH_UNITS   0
#define METRIC_UNITS    1

#define TOP_BUTTON_FROM_CONTROLLER      0
#define BOTTOM_BUTTON_FROM_CONTROLLER   1

@interface PFUnitTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UITableView *unitTable;
    UIView *redBanner;
    UIImageView *backgroundImage;
    NSArray *currentDataSource;
    NSMutableArray *englishUnits;
    NSMutableArray *metricUnits;
    PFMetricViewController *metricViewController;
    NSInteger buttonClicked;
    NSInteger defaultSelectionIndex;
}

-(id)initWithUnitType:(NSInteger)unitType settingCallback:(PFMetricViewController *)controller fromButton:(NSInteger) button;

- (IBAction)onSegmentedControlClick:(id)sender;

@end
