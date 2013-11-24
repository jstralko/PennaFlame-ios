//
//  PFMTIViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMTIViewController.h"
#import "PFAppDelegate.h"

@interface PFMTIViewController ()

@end

@implementation PFMTIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        int height;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            height = 100;
        } else {
            height = 65;
        }
        
        self.navigationItem.title = @"MTI Statement";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        mtiWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height - height)];
        [mtiWebView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|
            UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|
            UIViewAutoresizingFlexibleHeight];
        [self.view addSubview:mtiWebView];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"mti_statement" withExtension:@"html"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [mtiWebView loadRequest:request];
        
        tabBar = [[PFTabView alloc] initWithFrame:CGRectMake(0,
                                                             self.view.bounds.size.height - height,
                                                             self.view.bounds.size.width,
                                                             height) withIndex:4];
        [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
        [self.view addSubview:tabBar];
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
