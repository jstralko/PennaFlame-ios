//
//  PFAppDelegate.h
//  PennaFlame
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTabView.h"

#define HARDNESS_CASE_DEPTH_TITLE   @"Hardness Case Depth"
#define HARDNESS_CHART_TITLE        @"Hardness Chart"


@interface PFAppDelegate : UIResponder <UIApplicationDelegate, PFTabViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly) NSMutableDictionary *hardnessCaseDepthChartDict;
@property (readonly) NSMutableDictionary *hardnessChartDict;

- (void) showCaseDepthChartController;

@end


