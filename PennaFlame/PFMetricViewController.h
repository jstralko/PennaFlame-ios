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
    UIScrollView *scrollView;

}

-(void) buttonClicked:(id)sender;

@end