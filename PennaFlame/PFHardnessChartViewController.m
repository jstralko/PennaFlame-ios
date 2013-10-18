//
//  PFHardnessChartViewController.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/7/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFHardnessChartViewController.h"

@interface PFHardnessChartViewController ()

- (void) buttonClicked:(id)sender;
- (void) drawLayout;

@end

@implementation PFHardnessChartViewController

NSMutableDictionary *hardnessChartDict;
NSLayoutConstraint *hardnessWebViewHeightConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Hardness Chart";
        self.view.backgroundColor = [UIColor grayColor];

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
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessChartData" ofType:@"plist"];
    hardnessChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSInteger halfIndex = [hardnessChartDict allKeys].count/2;
    NSString *half = [[hardnessChartDict allKeys] objectAtIndex:halfIndex];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    if (!metalPicker) metalPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [metalPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [metalPicker setHidden:YES];
    [scrollView addSubview:metalPicker];
    
    
    if (!rangePicker) rangePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [rangePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rangePicker setHidden:YES];
    [scrollView addSubview:rangePicker];
    
    if (!showMetalPickerButton) showMetalPickerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [showMetalPickerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showMetalPickerButton setTitle:half forState:UIControlStateNormal];
    [showMetalPickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showMetalPickerButton];
    
    if(!showRangePickerButton) showRangePickerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [showRangePickerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showRangePickerButton setTitle:@"Select Range" forState:UIControlStateNormal];
    [showRangePickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showRangePickerButton];
    
    if(!generateChart) generateChart = [[UIButton alloc] initWithFrame:CGRectZero];
    [generateChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [generateChart setTitle:@"Show  Chart" forState:UIControlStateNormal];
    [generateChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:generateChart];
    
    if (!hardnessChartWebView) hardnessChartWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [hardnessChartWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [hardnessChartWebView setHidden:YES];
    hardnessChartWebView.delegate = self;
    [scrollView addSubview:hardnessChartWebView];
    
    metalPicker.dataSource = self;
    metalPicker.delegate = self;
    rangePicker.dataSource = self;
    rangePicker.delegate = self;
    
    [metalPicker selectRow:halfIndex inComponent:0 animated:NO];
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
    
    [self drawLayout];
}

- (void) buttonClicked:(id)sender {
    if (sender == showMetalPickerButton) {
        [metalPicker setHidden:![metalPicker isHidden]];
        [self drawLayout];
    } else  if(sender == showRangePickerButton) {
        if ([showRangePickerButton.titleLabel.text isEqualToString:@"Select Range"]) {
            //set a default - pick middle value
            NSInteger metalIndex = [metalPicker selectedRowInComponent:0];
            NSString *metal = [[hardnessChartDict allKeys] objectAtIndex:metalIndex];
            NSArray *array = [hardnessChartDict objectForKey:metal];
            [showRangePickerButton setTitle:[array objectAtIndex:array.count/2] forState:UIControlStateNormal];
            [rangePicker selectRow:array.count/2 inComponent:0 animated:NO];
        }
        [rangePicker setHidden:![rangePicker isHidden]];
        [self drawLayout];
    } else {
        NSInteger metalIndex = [metalPicker selectedRowInComponent:0];
        NSString *metal = [[hardnessChartDict allKeys] objectAtIndex:metalIndex];
        NSArray *metals = [hardnessChartDict allKeys];
        //NSString *range = [[hardnessChartDict objectForKey:metal] objectAtIndex:[rangePicker selectedRowInComponent:0]];
        
        /*
         <html>
         <head>
         </head>
         <body style="background-color:#BDBBBB;">
         <table width="90%" border="1" align="center" cellpadding="3" cellspacing="0" bordercolor="#CCCCCC">
         <tbody><tr bgcolor="lightgrey" align="center">
         <td bgcolor="#FF0000"><span style="font-weight:bold">MATERIAL (ASM)</span></td>
         <td bgcolor="#FF0000"><span style="font-weight:bold">HARDNESS (Rc)</span></td>
         <td bgcolor="#FF0000"><span style="font-weight:bold">Case Depth Inches</span></td>
         </tr>
         <tr bgcolor="white">
         <td><div align="center" class="style25">1045</div></td>
         <td><div align="center" class="style25">50/60</div></td>
         <td><div align="center" class="style25">1/8</div></td>
         </tr>
         */
        NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head></head><body style=\"background-color:#BDBBBB;\">"
                          "<table width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                          "<tbody>"
                          "<tr bgcolor=\"lightgrey\" align=\"center\">" ];
        
        for (NSString *key in metals) {
            if ([metal isEqualToString:key]) {
              [html appendFormat:@"<td bgcolor=\"#FF0000\"><span style=\"font-weight:bold\">%@</span></td>", key];
                
            } else {
                [html appendFormat:@"<td bgcolor=\"#FF0000\"><span style=\"font-weight:bold\">%@</span></td>", key];
            }
        }
        [html appendFormat:@"</tr><tr bgcolor=\"white\">"];
        for (NSString *key in metals) {
            [html appendFormat:@"<td><div align=\"center\">%@</div></td>", [[hardnessChartDict objectForKey:key] objectAtIndex:[rangePicker selectedRowInComponent:0]]];
        }
        [html appendFormat:@"</tr></table></body></html>"];
        
        //NSLog(@"%@", html);
        
        [hardnessChartWebView loadHTMLString:html baseURL:nil];
        [hardnessChartWebView setHidden:NO];
    }
    
}

- (void) drawLayout {
    
    [self.view removeConstraints:self.view.constraints];
    [scrollView removeConstraints:scrollView.constraints];
    
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
                   constraintWithItem:showMetalPickerButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showMetalPickerButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showMetalPickerButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    id toItem = nil;
    if (![metalPicker isHidden]) {
    
        myConstraint =[NSLayoutConstraint
                   constraintWithItem:metalPicker
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:showMetalPickerButton
                   attribute:NSLayoutAttributeBottom
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
        
        toItem = metalPicker;
    } else {
        toItem = showMetalPickerButton;;
    }

    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showRangePickerButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:toItem
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showRangePickerButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showRangePickerButton
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
                       toItem:showRangePickerButton
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0];
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
    
    id generateChartToItem = nil;
    if ([rangePicker isHidden]) {
        generateChartToItem = showRangePickerButton;
    } else {
        generateChartToItem = rangePicker;
    }
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:generateChart
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:generateChartToItem
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:generateChart
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:generateChart
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    //
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:generateChart
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    if ([hardnessChartWebView isHidden]) {
        hardnessWebViewHeightConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:1];
    }
    
    [scrollView addConstraint:hardnessWebViewHeightConstraint];
    
    /*
     * These two contraints below makes the
     * scrollview scroll in all directions
     */
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:hardnessChartWebView
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView sizeToFit];
    hardnessWebViewHeightConstraint.constant = webView.frame.size.height;
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

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if (pickerView == metalPicker) {
        NSArray *array = [hardnessChartDict allKeys];
        NSString *title = [array objectAtIndex:row];
        [showMetalPickerButton setTitle:title forState:UIControlStateNormal];
        [rangePicker reloadComponent:0];
    } else {
        NSArray *array = [hardnessChartDict objectForKey:showMetalPickerButton.titleLabel.text];
        [showRangePickerButton setTitle:[array objectAtIndex:row] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
