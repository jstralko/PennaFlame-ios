//
//  PFHardnessChartViewController.m
//  PennaFlame
//
//  Created by Chris Copac on 10/7/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFHardnessChartViewController.h"

@interface PFHardnessChartViewController ()

@end

@implementation PFHardnessChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Penna Flame";
        self.view.backgroundColor = [UIColor grayColor];
        
        pdfWrapper = [[UIWebView alloc]initWithFrame:self.view.frame];
        [self.view addSubview:pdfWrapper];
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://www.pennaflame.com/HardnessConversionChart.pdf"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [pdfWrapper loadRequest:request];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
