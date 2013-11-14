//
//  PFHardnessCaseDepthViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFChartViewController.h"
#import "PFFullChartViewController.h"

@interface PFChartViewController ()
    
@end

@implementation PFChartViewController

NSMutableDictionary *chartDictionary;
NSLayoutConstraint *webViewHeightConstraint;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDict:(NSMutableDictionary *)chartDict withTitle:(NSString *)title {
    self = [super init];
    if (self) {
        chartDictionary = chartDict;
        self.navigationItem.title = title;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];
    }
    return self;
}

- (void) loadView {
    [super loadView];
    

    NSInteger halfIndex = [chartDictionary allKeys].count/2;
    NSString *half = [[chartDictionary allKeys] objectAtIndex:halfIndex];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    if (!topPicker) topPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [topPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topPicker setHidden:YES];
    [scrollView addSubview:topPicker];
    
    
    if (!rangePicker) rangePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [rangePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rangePicker setHidden:YES];
    [scrollView addSubview:rangePicker];
    
    if (!showTopPickerButton) showTopPickerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [showTopPickerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showTopPickerButton setTitle:half forState:UIControlStateNormal];
    [showTopPickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showTopPickerButton];
    
    if(!showRangePickerButton) showRangePickerButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [showRangePickerButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showRangePickerButton setTitle:@"Select Range" forState:UIControlStateNormal];
    [showRangePickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showRangePickerButton];
    
    if(!generateChart) generateChart = [[UIButton alloc] initWithFrame:CGRectZero];
    [generateChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [generateChart setTitle:@"Show  Chart" forState:UIControlStateNormal];
    [generateChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [generateChart setEnabled:NO];
    generateChart.alpha = .5f;
    [scrollView addSubview:generateChart];
    
    if (!chartWebView) chartWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [chartWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chartWebView setHidden:YES];
    chartWebView.delegate = self;
    [scrollView addSubview:chartWebView];
    
    if(!showFullChart) showFullChart = [[UIButton alloc] initWithFrame:CGRectZero];
    [showFullChart setTitle:@"Show Full Chart" forState:UIControlStateNormal];
    [showFullChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [showFullChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showFullChart];
    
    topPicker.dataSource = self;
    topPicker.delegate = self;
    rangePicker.dataSource = self;
    rangePicker.delegate = self;
    
    [topPicker selectRow:halfIndex inComponent:0 animated:NO];
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
    if (sender == showTopPickerButton) {
        [topPicker setHidden:![topPicker isHidden]];
    } else  if(sender == showRangePickerButton) {
        if ([showRangePickerButton.titleLabel.text isEqualToString:@"Select Range"]) {
            //set a default - pick middle value
            NSInteger metalIndex = [topPicker selectedRowInComponent:0];
            NSString *metal = [[chartDictionary allKeys] objectAtIndex:metalIndex];
            NSArray *array = [chartDictionary objectForKey:metal];
            [showRangePickerButton setTitle:[array objectAtIndex:array.count/2] forState:UIControlStateNormal];
            [rangePicker selectRow:array.count/2 inComponent:0 animated:NO];
            [generateChart setEnabled:YES];
            generateChart.alpha = 1.0f;
        }
        [rangePicker setHidden:![rangePicker isHidden]];
    } else if (sender == showFullChart) {
        NSInteger metalIndex = [topPicker selectedRowInComponent:0];
        NSString *metal = [[chartDictionary allKeys] objectAtIndex:metalIndex];
        
        NSArray *metals = [chartDictionary allKeys];
        NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head></head><body style=\"background-color:#BDBBBB;\">"
                                 "<table width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                                 "<tbody>"
                                 "<tr bgcolor=\"lightgrey\" align=\"center\">" ];
        
        for (NSString *key in metals) {
            //if ([metal isEqualToString:key]) {
            //    [html appendFormat:@"<td bgcolor=\"#FF0000\"><span style=\"font-weight:bold\">%@</span></td>", key];
            //
            //} else {
                [html appendFormat:@"<td bgcolor=\"#FF0000\"><span style=\"font-weight:bold\">%@</span></td>", key];
            //}
        }
        [html appendFormat:@"</tr>"];
        
        int total = [[chartDictionary objectForKey:metal] count];
        for (int i = 0 ; i < total; i++) {
            [html appendFormat:@"<tr bgcolor=\"white\">"];
            for (NSString *key in metals) {
                NSString *range = [[chartDictionary objectForKey:key] objectAtIndex:i];
                [html appendFormat:@"<td><div align=\"center\">%@</div></td>", range];
            }
            [html appendFormat:@"</tr>"];
        }
        [html appendFormat:@"</table></body></html>"];
        
        PFFullChartViewController *fcvc = [[PFFullChartViewController alloc ] initWithString:html];
        [self.navigationController pushViewController:fcvc animated:YES];
        
    } else {
        [topPicker setHidden:YES];
        [rangePicker setHidden:YES];
        
        NSInteger metalIndex = [topPicker selectedRowInComponent:0];
        NSString *metal = [[chartDictionary allKeys] objectAtIndex:metalIndex];
        NSArray *metals = [chartDictionary allKeys];
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
            [html appendFormat:@"<td><div align=\"center\">%@</div></td>", [[chartDictionary objectForKey:key] objectAtIndex:[rangePicker selectedRowInComponent:0]]];
        }
        [html appendFormat:@"</tr></table></body></html>"];
        
        //NSLog(@"%@", html);
        
        [chartWebView loadHTMLString:html baseURL:nil];
        [chartWebView setHidden:NO];
    }
    
    [self drawLayout];
    
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
                   constraintWithItem:showTopPickerButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showTopPickerButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showTopPickerButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    id toItem = nil;
    if (![topPicker isHidden]) {
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:topPicker
                       attribute:NSLayoutAttributeTop
                       relatedBy:NSLayoutRelationGreaterThanOrEqual
                       toItem:showTopPickerButton
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
        
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:topPicker
                       attribute:NSLayoutAttributeCenterX
                       relatedBy:NSLayoutRelationEqual
                       toItem:scrollView
                       attribute:NSLayoutAttributeCenterX
                       multiplier:1.0
                       constant:0];
        [scrollView addConstraint:myConstraint];
        
        myConstraint =[NSLayoutConstraint
                       constraintWithItem:topPicker
                       attribute:NSLayoutAttributeWidth
                       relatedBy:NSLayoutRelationEqual
                       toItem:nil
                       attribute:NSLayoutAttributeNotAnAttribute
                       multiplier:1.0
                       constant:250];
        [scrollView addConstraint:myConstraint];
        
        toItem = topPicker;
    } else {
        toItem = showTopPickerButton;;
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
                   constraintWithItem:chartWebView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:generateChart
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chartWebView
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chartWebView
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    if ([chartWebView isHidden]) {
        webViewHeightConstraint =[NSLayoutConstraint
                                          constraintWithItem:chartWebView
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:nil
                                          attribute:NSLayoutAttributeNotAnAttribute
                                          multiplier:1.0
                                          constant:1];
    }
    
    [scrollView addConstraint:webViewHeightConstraint];
    
    /*
     * These two contraints below makes the
     * scrollview scroll in all directions
     */
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chartWebView
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    

    //
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showFullChart
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:chartWebView
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showFullChart
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showFullChart
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:250];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showFullChart
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
    webViewHeightConstraint.constant = webView.frame.size.height;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    if (pickerView == topPicker) {
        return chartDictionary.count;
    }
    NSInteger index = [topPicker selectedRowInComponent:0];
    NSString *key = [[chartDictionary allKeys] objectAtIndex:index];
    NSArray *array = [chartDictionary objectForKey:key];
    return [array count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    if (pickerView == topPicker) {
        NSArray *array = [chartDictionary allKeys];
        return [array objectAtIndex:row];
    }
    
    NSInteger index = [topPicker selectedRowInComponent:0];
    NSString *key = [[chartDictionary allKeys] objectAtIndex:index];
    NSArray *array = [chartDictionary objectForKey:key];
    return [array objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if (pickerView == topPicker) {
        NSArray *array = [chartDictionary allKeys];
        NSString *title = [array objectAtIndex:row];
        [showTopPickerButton setTitle:title forState:UIControlStateNormal];
        [rangePicker reloadComponent:0];
        NSString *range = [[chartDictionary objectForKey:title] objectAtIndex:[rangePicker selectedRowInComponent:0]];
        [showRangePickerButton setTitle:range forState:UIControlStateNormal];
    } else {
        NSArray *array = [chartDictionary objectForKey:showTopPickerButton.titleLabel.text];
        [showRangePickerButton setTitle:[array objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    [generateChart setEnabled:YES];
    generateChart.alpha = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
