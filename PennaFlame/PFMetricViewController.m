//
//  PFViewController.m
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMetricViewController.h"
#import "PFUnitTableViewController.h"

@interface PFMetricViewController ()

@end


@implementation PFMetricViewController

//@synthesize englishUnit, metricUnit;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Metric Converter";
        self.view.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up main view
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [view setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0]];
    self.view = view;
    
    CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollView];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"English", @"Metric", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setCenter:CGPointMake(view.frame.size.width / 2, (segmentedControl.frame.size.height+10)/2)];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:segmentedControl];
    
    frame = CGRectMake(45, 60, 100, 30);
    topTextField = [[UITextField alloc] initWithFrame:frame];
    [topTextField setBorderStyle:UITextBorderStyleBezel];
    [topTextField setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:topTextField];
  
    frame = CGRectMake(160, 62, 125, 30);
    topButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [topButton setFrame:frame];
    [topButton setTitle:@"Inches" forState:UIControlStateNormal];
    // Set the target, action and event for the button
    [topButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [scrollView addSubview:topButton];
  
    frame = CGRectMake(48, 95, 100, 25);
    topStepper = [[UIStepper alloc] initWithFrame:frame];
    [scrollView addSubview:topStepper];
  
    frame = CGRectMake(45, 145, 100, 30);
    bottomTextField = [[UITextField alloc]initWithFrame:frame];
    [bottomTextField setBorderStyle:UITextBorderStyleBezel];
    [bottomTextField setBackgroundColor:[UIColor whiteColor]];
    [scrollView addSubview:bottomTextField];
  
    frame = CGRectMake(160, 147, 125, 30);
    bottomButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton setFrame:frame];
    [bottomButton setTitle:@"Cen" forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bottomButton];
    
    frame = CGRectMake(48, 185, 100, 25);
    bottomStepper = [[UIStepper alloc] initWithFrame:frame];
    [scrollView addSubview:bottomStepper];
    
}

-(IBAction)onSegmentedControlChanged:(id)sender
{
    switch([sender selectedSegmentIndex]) {
        case 0: {
            
        }
            break;
        case 1: {
            
        }
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClicked:(id)sender
{
    if ((sender == bottomButton && [segmentedControl selectedSegmentIndex] == 0)
        || (sender == topButton && [segmentedControl selectedSegmentIndex] == 1)) {
        PFUnitTableViewController *tableViewController = [[PFUnitTableViewController alloc] initWithStyle:UITableViewStylePlain withMetricVieController:self withUnitType:METRIC_UNITS];
        [self.navigationController pushViewController:tableViewController animated:YES];
    } else {
        PFUnitTableViewController *tableViewController = [[PFUnitTableViewController alloc] initWithStyle:UITableViewStylePlain withMetricVieController:self withUnitType:ENGLISH_UNITS];
        [self.navigationController pushViewController:tableViewController animated:YES];
    }
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)dealloc {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}


@end
