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
    }
    
    return self;
}

-(void) loadView {
    [super loadView];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [background setFrame:self.view.bounds];
    [background setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:background];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [background addSubview:redBanner];
    
    if(!chart) chart = [[UIWebView alloc]initWithFrame:CGRectZero];
    [chart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chart loadHTMLString:chartHtml baseURL:nil];
    [background addSubview:chart];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];
    [background removeConstraints:background.constraints];
    
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
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
                   toItem:background
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
    [background addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:background
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [background addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:background
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [background addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:background
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
    [background addConstraint:myConstraint];
    //end of redbanner
    
    myConstraint =[NSLayoutConstraint
                                       constraintWithItem:chart
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:redBanner
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                       constant:25];
    [background addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:background
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [background addConstraint:myConstraint];
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
                   toItem:background
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [background addConstraint:myConstraint];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
