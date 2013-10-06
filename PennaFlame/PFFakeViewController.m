//
//  PFFakeViewController.m
//  PennaFlame
//
//  Created by Chris Copac on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFFakeViewController.h"

@interface PFFakeViewController ()

@end

@implementation PFFakeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView {
    [super loadView];
    //[self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    if(!logo) logo = [[UIImageView alloc] init];
    
    [logo setImage:[UIImage imageNamed:@"layer12nomerge.gif"]];
    
    [logo setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:logo];
    
    
    if(!label) label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setText:@"\"Pursuing Excellence\""];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setNumberOfLines:1];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:label];

    if(!websiteButton) websiteButton = [[UIButton alloc] initWithFrame:CGRectZero];
	[websiteButton setTitle:@"Call" forState:UIControlStateNormal];
    [websiteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
	[scrollView addSubview:websiteButton];

}

- (void)viewDidLoad
{
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                                       constraintWithItem:scrollView
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeTop
                                       multiplier:1.0
                                       constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:scrollView
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:scrollView
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    scrollViewBottom =[NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0];
    [self.view addConstraint:scrollViewBottom];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logo
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:20];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logo
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logo
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeHeight
                   multiplier:1.0
                   constant:55.0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:label
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:logo
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:label
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:label
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:-40];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:label
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:nil
                   attribute:NSLayoutAttributeHeight
                   multiplier:1.0
                   constant:50];
    [scrollView addConstraint:myConstraint];

    myConstraint =[NSLayoutConstraint
                   constraintWithItem:websiteButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:label
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:websiteButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:websiteButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:200];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:websiteButton
                   attribute:NSLayoutAttributeCenterY
                   relatedBy:NSLayoutRelationLessThanOrEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterY
                   multiplier:1.0
                   constant:0];
    [myConstraint setPriority:UILayoutPriorityDefaultLow];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:websiteButton
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:label
                   attribute:NSLayoutAttributeHeight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
//
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:passwordField
//                   attribute:NSLayoutAttributeTop
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:emailField
//                   attribute:NSLayoutAttributeBottom
//                   multiplier:1.0
//                   constant:5];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:passwordField
//                   attribute:NSLayoutAttributeCenterX
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:scrollView
//                   attribute:NSLayoutAttributeCenterX
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:passwordField
//                   attribute:NSLayoutAttributeWidth
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:emailField
//                   attribute:NSLayoutAttributeWidth
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:signInButton
//                   attribute:NSLayoutAttributeTop
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:passwordField
//                   attribute:NSLayoutAttributeBottom
//                   multiplier:1.0
//                   constant:5];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:signInButton
//                   attribute:NSLayoutAttributeCenterX
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:scrollView
//                   attribute:NSLayoutAttributeCenterX
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:forgotButton
//                   attribute:NSLayoutAttributeTop
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:signInButton
//                   attribute:NSLayoutAttributeBottom
//                   multiplier:1.0
//                   constant:5];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:forgotButton
//                   attribute:NSLayoutAttributeCenterX
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:scrollView
//                   attribute:NSLayoutAttributeCenterX
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:registering
//                   attribute:NSLayoutAttributeCenterX
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:scrollView
//                   attribute:NSLayoutAttributeCenterX
//                   multiplier:1.0
//                   constant:22];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:registering
//                   attribute:NSLayoutAttributeTop
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:forgotButton
//                   attribute:NSLayoutAttributeBottom
//                   multiplier:1.0
//                   constant:5];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:indicator
//                   attribute:NSLayoutAttributeHeight
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:nil
//                   attribute:NSLayoutAttributeHeight
//                   multiplier:1.0
//                   constant:40];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:indicator
//                   attribute:NSLayoutAttributeWidth
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:indicator
//                   attribute:NSLayoutAttributeHeight
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:indicator
//                   attribute:NSLayoutAttributeRight
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:registering
//                   attribute:NSLayoutAttributeLeft
//                   multiplier:1.0
//                   constant:-4];
//    [scrollView addConstraint:myConstraint];
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:indicator
//                   attribute:NSLayoutAttributeCenterY
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:registering
//                   attribute:NSLayoutAttributeCenterY
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
//    
//    myConstraint =[NSLayoutConstraint
//                   constraintWithItem:registering
//                   attribute:NSLayoutAttributeBottom
//                   relatedBy:NSLayoutRelationEqual
//                   toItem:scrollView
//                   attribute:NSLayoutAttributeBottom
//                   multiplier:1.0
//                   constant:0];
//    [scrollView addConstraint:myConstraint];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
