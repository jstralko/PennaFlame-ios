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

@interface PFUnitTableViewController : UITableViewController

-(id) initWithStyle:(UITableViewStyle)style withMetricVieController:(PFMetricViewController *)controller withUnitType:(NSInteger)type;
@end
