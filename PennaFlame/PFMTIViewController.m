//
//  PFMTIViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMTIViewController.h"

@interface PFMTIViewController ()

@end

@implementation PFMTIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"MTI Statement";
        self.view.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:mtiWebView];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"mti_statement" withExtension:@"html"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [mtiWebView loadRequest:request];
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
