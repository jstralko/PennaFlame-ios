//
//  PFViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFTabView.h"

@interface PFMetricViewController : UIViewController {
    IBOutlet UIButton *topButton;
    UIStepper *topStepper;
    IBOutlet UIButton *bottomButton;
    UIStepper *bottomStepper;;
    IBOutlet UITextField *topTextField;
    IBOutlet UITextField *bottomTextField;
    UIScrollView *scrollView;
    UIView *redBanner;
    UIImageView *logoImageView;
    PFTabView *tabBar;
    UIImageView *backgroundImage;
}

- (void) buttonClicked:(id)sender;
- (void) setButtonTitle:(NSString *)title fromIndex:(NSInteger) index;

@end
