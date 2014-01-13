//
//  PFContactInfoViewController.h
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class PFTabView;
@class PFButton;

@interface PFContactInfoViewController: UIViewController <MFMailComposeViewControllerDelegate> {
    
    UILabel *label;
    PFButton  *emailButton;
    PFButton *callButton;
    PFButton *websiteButton;
    UIScrollView *scrollView;
    UILabel *extra;
    UIView *redBanner;
    UIImageView *backgroundImage;
    PFTabView *tabBar;
    UIImageView *logoImageView;
    NSLayoutConstraint *logoImageViewTop;
}

-(IBAction) emailButtonClicked:(id) sender;
-(IBAction) callButtonClicked:(id) sender;
-(IBAction) websiteButtonClicked:(id)sender;
@end
