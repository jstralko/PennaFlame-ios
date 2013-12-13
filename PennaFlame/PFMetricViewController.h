//
//  PFViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFTabView;
@class PFStepper;

@interface PFMetricViewController : UIViewController {
    IBOutlet UIButton *topButton;
    PFStepper *topStepper;
    IBOutlet UIButton *bottomButton;
    PFStepper *bottomStepper;;
    IBOutlet UITextField *topTextField;
    IBOutlet UITextField *bottomTextField;
    UIScrollView *scrollView;
    UIView *redBanner;
    UIImageView *logoImageView;
    PFTabView *tabBar;
    UIImageView *backgroundImage;
    NSLayoutConstraint *scrollViewBottom;
    NSLayoutConstraint *logoImageViewTop;
    NSMutableDictionary *unitConvertDict;
    NSMutableDictionary *metricUnitConvertDict;
    NSMutableDictionary *englishMetricConvertDict;
}

- (void) buttonClicked:(id)sender;
- (void) setButtonTitle:(NSString *)title fromIndex:(NSInteger) index;

@end
