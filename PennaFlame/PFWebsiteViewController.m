//
//  PFWebsiteViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFWebsiteViewController.h"

@interface PFWebsiteViewController ()

@end

@implementation PFWebsiteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Penna Flame";
        
        NSURL *url = [[NSURL alloc] initWithString:@"http://www.pennaflame.com"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [pennaflameWebView loadRequest:request];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
