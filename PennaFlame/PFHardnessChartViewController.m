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

NSMutableDictionary *hardnessChartDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Penna Flame";
        self.view.backgroundColor = [UIColor grayColor];

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessChartData" ofType:@"plist"];
        hardnessChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        
        //old way
        //pdfWrapper = [[UIWebView alloc]initWithFrame:self.view.frame];
        //[self.view addSubview:pdfWrapper];
        //NSURL *url = [[NSURL alloc] initWithString:@"http://www.pennaflame.com/HardnessConversionChart.pdf"];
        //NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        //[pdfWrapper loadRequest:request];
    }
    return self;
}


- (void) loadView {
    [super loadView];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    if (!metalPicker) metalPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [metalPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:metalPicker];
    
    if (!rangePicker) rangePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [rangePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:rangePicker];
    
    metalPicker.dataSource = self;
    metalPicker.delegate = self;
    
    rangePicker.dataSource = self;
    rangePicker.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //////////////////////////////////////////////////////////
    // Visual Format Language, I was having trouble getting //
    // the view to center hortizontally with its superview. //
    //////////////////////////////////////////////////////////
    
//    // Create the views and metrics dictionaries
//    NSDictionary *views = NSDictionaryOfVariableBindings(scrollView, foo);
//    // Horizontal layout
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
//    
//    // Vertical layout
//    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]|" options:NSLayoutFormatAlignAllCenterX | NSLayoutFormatAlignAllLeft metrics:nil views:views]];
//    
//    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[metalPicker]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
//    
//    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[metalPicker(100)]-|" options:NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
//    |-(>=20)-[view(==200)]-(>=20)-|
    
    //Manually Build the constraints instead.
    //TODO: revisit the layout issue and become better at VFL.
    
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
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:metalPicker
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:metalPicker
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:metalPicker
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePicker
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:metalPicker
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePicker
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePicker
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView == metalPicker) {
        return hardnessChartDict.count;
    }
    NSInteger index = [metalPicker selectedRowInComponent:0];
    NSString *key = [[hardnessChartDict allKeys] objectAtIndex:index];
    NSArray *array = [hardnessChartDict objectForKey:key];
    return [array count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == metalPicker) {
        NSArray *array = [hardnessChartDict allKeys];
        return [array objectAtIndex:row];
    }
    
    NSInteger index = [metalPicker selectedRowInComponent:0];
    NSString *key = [[hardnessChartDict allKeys] objectAtIndex:index];
    NSArray *array = [hardnessChartDict objectForKey:key];
    return [array objectAtIndex:row];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
