//
//  PFContactInfoViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFContactInfoViewController.h"
#import "PFWebsiteViewController.h"

@interface PFContactInfoViewController ()

@end

@implementation PFContactInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Contact Info";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];
        
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
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redBanner];
    
//    if(!logo)logo = [[UIImageView alloc] initWithFrame:CGRectZero];
//    [logo setImage:[UIImage imageNamed:@"layer12nomerge.gif"]];
//    [logo setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [scrollView addSubview:logo];
    
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
                           constant:0];
        [self.view addConstraint:myConstraint];
    
    //start of redbanner
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    //end of redbanner
    
//        
//        myConstraint =[NSLayoutConstraint
//                       constraintWithItem:logo
//                       attribute:NSLayoutAttributeTop
//                       relatedBy:NSLayoutRelationGreaterThanOrEqual
//                       toItem:redBanner
//                       attribute:NSLayoutAttributeBottom
//                       multiplier:1.0
//                       constant:5];
//        [scrollView addConstraint:myConstraint];
//        
//        
//        myConstraint =[NSLayoutConstraint
//                       constraintWithItem:logo
//                       attribute:NSLayoutAttributeCenterX
//                       relatedBy:NSLayoutRelationEqual
//                       toItem:scrollView
//                       attribute:NSLayoutAttributeCenterX
//                       multiplier:1.0
//                       constant:0];
//        [scrollView addConstraint:myConstraint];
//        
//        
//        myConstraint =[NSLayoutConstraint
//                       constraintWithItem:logo
//                       attribute:NSLayoutAttributeHeight
//                       relatedBy:NSLayoutRelationEqual
//                       toItem:nil
//                       attribute:NSLayoutAttributeNotAnAttribute
//                       multiplier:1.0
//                       constant:55];
//        [scrollView addConstraint:myConstraint];
//        
//        myConstraint =[NSLayoutConstraint
//                       constraintWithItem:logo
//                       attribute:NSLayoutAttributeWidth
//                       relatedBy:NSLayoutRelationEqual
//                       toItem:nil
//                       attribute:NSLayoutAttributeNotAnAttribute
//                       multiplier:1.0
//                       constant:scrollView.frame.size.width - 10];
//        [scrollView addConstraint:myConstraint];
    
        
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
    
    
        /*
         WOW Apple, that is all i'm going to say....
         
         This code below is the "magic" to get
         scrolling working when the device is rotated.
         */
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:extra
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                       toItem:scrollView
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
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
