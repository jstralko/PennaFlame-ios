//
//  PFHardnessCaseDepthViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFHardnessCaseDepthViewController.h"

@interface PFHardnessCaseDepthViewController ()
    
@end

@implementation PFHardnessCaseDepthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Hardness Case Depth";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"hardness_table" withExtension:@"html"];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [hardnessWebView loadRequest:request];
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
