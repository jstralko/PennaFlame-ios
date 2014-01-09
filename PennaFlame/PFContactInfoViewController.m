//
//  PFContactInfoViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFContactInfoViewController.h"
#import "PFWebsiteViewController.h"
#import "PFAppDelegate.h"
#import "PFTabView.h"

@interface PFContactInfoViewController ()

@end

int tabBarHeight;

@implementation PFContactInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Contact Info";
        
    }
    return self;
}

- (void) loadView {
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [backgroundImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:backgroundImage];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redBanner];
    
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
	[websiteButton setTitle:@"Website" forState:UIControlStateNormal];
    [websiteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [websiteButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [websiteButton addTarget:self action:@selector(websiteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:websiteButton];
    
    if(!callButton) callButton = [[UIButton alloc] initWithFrame:CGRectZero];
	[callButton setTitle:@"Call" forState:UIControlStateNormal];
    [callButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [callButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:callButton];
    
    if(!emailButton) emailButton = [[UIButton alloc] initWithFrame:CGRectZero];
	[emailButton setTitle:@"Email" forState:UIControlStateNormal];
    [emailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [emailButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [emailButton addTarget:self action:@selector(emailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:emailButton];
    
    if(!extra) extra = [[UILabel alloc] initWithFrame:CGRectZero];
    extra.textAlignment = NSTextAlignmentCenter;
    extra.lineBreakMode = NSLineBreakByWordWrapping;
    extra.numberOfLines = 0;
    extra.text = @"Penna Flame Industries\r1856 State Route 588\rZelienople, PA 16063-3902";
    [extra setBackgroundColor:[UIColor clearColor]];
    [extra setTextColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
    [extra setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:extra];
    
    UIImage *logoImage = [UIImage imageNamed:@"PFILogo"];
    logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:logoImageView];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        tabBarHeight = 100;
    } else {
        tabBarHeight = 65;
    }
    tabBar = [[PFTabView alloc] initWithFrame:CGRectMake(0,
                                                         self.view.bounds.size.height - tabBarHeight,
                                                         self.view.bounds.size.width,
                                                         tabBarHeight) withIndex:5];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //scrolling constrains
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
        
        myConstraint =[NSLayoutConstraint
                           constraintWithItem:scrollView
                           attribute:NSLayoutAttributeBottom
                           relatedBy:NSLayoutRelationEqual
                           toItem:self.view
                           attribute:NSLayoutAttributeBottom
                           multiplier:1.0
                           constant:(-1*tabBarHeight)];
        [self.view addConstraint:myConstraint];
    
    //
    myConstraint =[NSLayoutConstraint
                                       constraintWithItem:backgroundImage
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeTop
                                       multiplier:1.0
                                       constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:(-1*tabBarHeight)];
    [self.view addConstraint:myConstraint];
    
    //start of redbanner
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    //end of redbanner
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:label
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:redBanner
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:20];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:label
                       attribute:NSLayoutAttributeCenterX
                       relatedBy:NSLayoutRelationEqual
                       toItem:scrollView
                       attribute:NSLayoutAttributeCenterX
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:websiteButton
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:label
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:15];
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
                       constraintWithItem:callButton
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:websiteButton
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:15];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:callButton
                       attribute:NSLayoutAttributeCenterX
                       relatedBy:NSLayoutRelationEqual
                       toItem:scrollView
                       attribute:NSLayoutAttributeCenterX
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:emailButton
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationEqual
                       toItem:callButton
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:15];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:emailButton
                       attribute:NSLayoutAttributeCenterX
                       relatedBy:NSLayoutRelationEqual
                       toItem:scrollView
                       attribute:NSLayoutAttributeCenterX
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:extra
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:emailButton
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:15];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:extra
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    //
    logoImageViewTop =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:extra
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:logoImageViewTop];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    int height;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        height = 125;
    } else {
        height = 75;
    }
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:height];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    float bottomOfImageView = logoImageView.frame.origin.y + logoImageView.frame.size.height + 10;
    if (bottomOfImageView < bottomOfPage) {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = bottomOfPage - bottomOfImageView;
                             [self.view layoutIfNeeded];
                         }];
    } else {
        logoImageViewTop.constant = 10;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    float bottomOfImageView = extra.frame.origin.y + extra.frame.size.height + logoImageView.frame.size.height + 10;
    if (bottomOfImageView < bottomOfPage) {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = bottomOfPage - bottomOfImageView;
                             [self.view layoutIfNeeded];
                         }];
    } else {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = 10;
                             [self.view layoutIfNeeded];
                         }];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)callButtonClicked:(id)sender {
    NSString *phoneNumber = @"telprompt://724-452-8750";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(IBAction)websiteButtonClicked:(id)sender {
    PFWebsiteViewController *website = [[PFWebsiteViewController alloc] init];
    [self.navigationController pushViewController:website animated:YES];
}

-(IBAction)emailButtonClicked:(id)sender {

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;

        [mail setToRecipients:[NSArray arrayWithObject:@"brucec@pennaflame.com"]];
        [mail setSubject:@"<Set Subject Here>"];

        [self presentViewController:mail animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
