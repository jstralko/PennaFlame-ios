//
//  PFViewController.h
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFMetricViewController : UIViewController {
    IBOutlet UIButton *topButton;
    UIStepper *topStepper;
    IBOutlet UIButton *bottomButton;
    UIStepper *bottomStepper;;
    IBOutlet UITextField *topTextField;
    IBOutlet UITextField *bottomTextField;
    UISegmentedControl *segmentedControl;
    UIScrollView *scrollView;
    //NSString *englishUnit;
    //NSString *metricUnit;

}
//@property (assign) NSString *englishUnit;
//@property (assign) NSString *metricUnit;

-(void) buttonClicked:(id)sender;
-(IBAction) onSegmentedControlChanged:(id)sender;

@end
