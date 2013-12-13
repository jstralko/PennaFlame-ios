//
//  PFMathConverterViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFTabView;
@class PFStepper;

@interface PFMathConverterViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UITextField *numeratorTextField;
    IBOutlet UITextField *denominatorTextField;
    IBOutlet UILabel *fractionBarLabel;
    IBOutlet PFStepper *numeratorStepper;
    IBOutlet PFStepper *denominatorStepper;
    PFStepper *decimalStepper;
    IBOutlet UILabel *equalsLabel;
    IBOutlet UITextField *decimalTextField;
    UIScrollView *scrollView;
    UIView *redPadding;
    UIImageView *backgroundImage;
    PFTabView *tabBar;
    UIImageView *logoImageView;
    NSLayoutConstraint *scrollViewBottom;
    NSLayoutConstraint *logoImageViewTop;
}

- (IBAction) onSegmentedControlChanged:(id)sender;
//- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)steppervalueChanged:(UIStepper *)sender;
@end
