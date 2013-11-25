//
//  PFMathConverterViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFTabView;

@interface PFMathConverterViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UISegmentedControl *segmentedControl;
    IBOutlet UITextField *numeratorTextField;
    IBOutlet UITextField *denominatorTextField;
    IBOutlet UILabel *fractionBarLabel;
    IBOutlet UIStepper *numeratorStepper;
    IBOutlet UIStepper *denominatorStepper;
    UIStepper *decimalStepper;
    IBOutlet UILabel *equalsLabel;
    IBOutlet UITextField *decimalTextField;
//    IBOutlet UIButton *clearButton;
    UIScrollView *scrollView;
    UIView *redPadding;
    UIImageView *backgroundImage;
    PFTabView *tabBar;
    
}

- (IBAction) onSegmentedControlChanged:(id)sender;
//- (IBAction)clearButtonClicked:(id)sender;
- (IBAction)steppervalueChanged:(UIStepper *)sender;
@end
