//
//  PFFullChartViewController.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFFullChartViewController.h"

@interface PFFullChartViewController ()

@end

@implementation PFFullChartViewController

NSString *chartHtml;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithString:(NSString *)html {
    self = [super init];
    if (self) {
        chartHtml = html;
        self.navigationItem.title = @"Full Chart";
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];
    }
    
    return self;
}

-(void) loadView {
    [super loadView];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [self.view addSubview:redBanner];
    
    if(!chart) chart = [[UIWebView alloc]initWithFrame:CGRectZero];
    [chart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chart loadHTMLString:chartHtml baseURL:nil];
    [self.view addSubview:chart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //start of redbanner
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:65];
    
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [self.view addConstraint:myConstraint];
    //end of redbanner
    
    myConstraint =[NSLayoutConstraint
                                       constraintWithItem:chart
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:redBanner
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                       constant:25];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end