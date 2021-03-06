//
//  PFHardnessCaseDepthViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFChartViewController.h"
#import "PFFullChartViewController.h"
#import "PFAppDelegate.h"
#import "PFTabView.h"
#import "PFButton.h"

@interface PFChartViewController ()
    
@end

@implementation PFChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithDict:(NSMutableDictionary *)chartDict withTitle:(NSString *)title {
    return [self initWithDict:chartDict sortedKeys:[chartDict allKeys] withTitle:title];
}

-(id)initWithDict:(NSMutableDictionary *)chartDict sortedKeys:(NSArray *)keys withTitle:(NSString *)title {
    self = [super init];
    if (self) {
        chartDictionary = chartDict;
        sortedKeys = keys;
        self.navigationItem.title = title;
    }
    return self;
}

- (void) loadView {
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    NSInteger halfIndex = [chartDictionary allKeys].count/2;
    NSString *half = [[chartDictionary allKeys] objectAtIndex:halfIndex];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [backgroundImage setFrame:self.view.bounds];
    [backgroundImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:backgroundImage];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redBanner];
    
    if (!topPicker) topPicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [topPicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topPicker setHidden:YES];
    [scrollView addSubview:topPicker];
    
    
    if (!rangePicker) rangePicker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    [rangePicker setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rangePicker setHidden:YES];
    [scrollView addSubview:rangePicker];
    
    showTopPickerButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [showTopPickerButton setTitle:half forState:UIControlStateNormal];
    [showTopPickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showTopPickerButton];
    
    showRangePickerButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [showRangePickerButton setTitle:@"Select Range" forState:UIControlStateNormal];
    [showRangePickerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showRangePickerButton];
    
    rangePickerDoneButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [rangePickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [rangePickerDoneButton setHidden:YES];
    [rangePickerDoneButton addTarget:self action:@selector(rangePickerDone:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:rangePickerDoneButton];
    
    topPickerDoneButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [topPickerDoneButton setTitle:@"Done" forState:UIControlStateNormal];
    [topPickerDoneButton setHidden:YES];
    [topPickerDoneButton addTarget:self action:@selector(topPickerDone:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:topPickerDoneButton];
    
    generateChart = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [generateChart setTitle:@"Show  Chart" forState:UIControlStateNormal];
    [generateChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [generateChart setEnabled:NO];
    generateChart.alpha = .5f;
    [scrollView addSubview:generateChart];
    
    if (!chartWebView) chartWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [chartWebView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chartWebView setHidden:YES];
    chartWebView.delegate = self;
    [chartWebView setBackgroundColor:[UIColor clearColor]];
    [chartWebView setOpaque:NO];
    chartWebView.scrollView.scrollEnabled = NO;
    chartWebView.scrollView.bounces = NO;
    [scrollView addSubview:chartWebView];
    
    showFullChart = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [showFullChart setTitle:@"Show Full Chart" forState:UIControlStateNormal];
    [showFullChart addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showFullChart];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redBanner];
    
    UIImage *logoImage = [UIImage imageNamed:@"PFILogo"];
    logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:logoImageView];
    
    topPicker.dataSource = self;
    topPicker.delegate = self;
    rangePicker.dataSource = self;
    rangePicker.delegate = self;
    
    [topPicker selectRow:halfIndex inComponent:0 animated:NO];
    
    int index;
    if ([self.navigationItem.title isEqualToString:HARDNESS_CASE_DEPTH_TITLE]) {
        index = 2;
    } else {
        index = 3;
    }
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        tabBarHeight = 100;
    } else {
        tabBarHeight = 65;
    }
    tabBar = [[PFTabView alloc] initWithFrame:CGRectMake(0,
                                                         self.view.bounds.size.height - tabBarHeight,
                                                         self.view.bounds.size.width,
                                                         tabBarHeight) withIndex:index];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
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

- (void) topPickerDone:(id)sender {
    [topPicker setHidden:YES];
    [topPickerDoneButton setHidden:YES];
    [self drawLayout];
}

- (void) rangePickerDone:(id)sender {
    [rangePicker setHidden:YES];
    [rangePickerDoneButton setHidden:YES];
    [self drawLayout];
}

- (void) buttonClicked:(id)sender {
    if (sender == showTopPickerButton) {
        [topPicker setHidden:![topPicker isHidden]];
        [topPickerDoneButton setHidden:[topPicker isHidden]];
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
        [rangePickerDoneButton setHidden:[rangePicker isHidden]];
    } else if (sender == showFullChart) {
        PFFullChartViewController *fcvc = [[PFFullChartViewController alloc ] initWithDict:chartDictionary
                                                                            withSortedKeys:sortedKeys withTile:self.navigationItem.title];
        [self.navigationController pushViewController:fcvc animated:YES];
        
    } else {
        [topPicker setHidden:YES];
        [rangePicker setHidden:YES];
        [topPickerDoneButton setHidden:YES];
        [rangePickerDoneButton setHidden:YES];
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
        NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head></head>"
                                 "<body style=\"background-color: transparent;\">"
                                 "<table width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                                 "<tbody>"
                                 "<tr bgcolor=\"lightgrey\" align=\"center\">" ];
        
        NSString *fontSize;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            //iPad
            fontSize = @"1.0em";
        } else {
            fontSize = @"0.50em";
        }
        
        for (NSString *key in sortedKeys) {
            [html appendFormat:@"<td bgcolor=\"#FF0000\"><span style=\"font-weight:bold;font-size:%@\">%@</span></td>", fontSize, key];
        }
        [html appendFormat:@"</tr><tr bgcolor=\"white\">"];
        for (NSString *key in sortedKeys) {
            [html appendFormat:@"<td><div align=\"center\">%@</div></td>", [[chartDictionary objectForKey:key] objectAtIndex:[rangePicker selectedRowInComponent:0]]];
        }
        [html appendFormat:@"</tr></table></body></html>"];
        
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
                   constant:(-1*tabBarHeight)];
    [self.view addConstraint:myConstraint];
    
    //start of redbanner
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    //end of redbanner
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:showTopPickerButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:redBanner
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
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
                   constant:175];
    [scrollView addConstraint:myConstraint];
    
    //topPickerDoneButton
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topPickerDoneButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:redBanner
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topPickerDoneButton
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:-5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topPickerDoneButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:50];
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
                   constant:175];
    [scrollView addConstraint:myConstraint];
    
    
    //rangePickerDoneButton
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePickerDoneButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:toItem
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePickerDoneButton
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:-5];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:rangePickerDoneButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:50];
    [scrollView addConstraint:myConstraint];
    //
    
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
                   constant:5];
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
                   constant:175];
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
                   constant:5];
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
                   constant:175];
    [scrollView addConstraint:myConstraint];
    
    //
    logoImageViewTop =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:showFullChart
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:logoImageViewTop];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    int height;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        height = 125;
    } else {
        height = 75;
    }
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:height];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:logoImageView
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
    //CGPoint bottomOffset = CGPointMake(0, webView.frame.origin.y + webView.frame.size.height + 5 - scrollView.bounds.size.height);
    [scrollView setContentOffset:CGPointMake(0, 0)];
    
//    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
//    float bottomOfImageView = chartWebView.frame.origin.y + chartWebView.frame.size.height + logoImageView.frame.size.height+20;
//    if (bottomOfImageView < bottomOfPage) {
//        [UIView animateWithDuration:.25
//                         animations:^{
//                             logoImageViewTop.constant = bottomOfPage - bottomOfImageView;
//                             [self.view layoutIfNeeded];
//                         }];
//    } else {
//        [UIView animateWithDuration:.25
//                         animations:^{
//                             logoImageViewTop.constant = 20;
//                             [self.view layoutIfNeeded];
//                         }];
//    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view layoutIfNeeded];
    
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    float bottomOfImageView = logoImageView.frame.origin.y + logoImageView.frame.size.height;
    if (bottomOfImageView < bottomOfPage) {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = bottomOfPage - bottomOfImageView;
                             [self.view layoutIfNeeded];
                         }];
    }
    
    [showTopPickerButton addGradientLayer];
    [topPickerDoneButton addGradientLayer];
    [showRangePickerButton addGradientLayer];
    [rangePickerDoneButton addGradientLayer];
    [generateChart addGradientLayer];
    [showFullChart addGradientLayer];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    float bottomOfImageView = chartWebView.frame.origin.y + chartWebView.frame.size.height + logoImageView.frame.size.height+20;
    if (bottomOfImageView < bottomOfPage) {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = bottomOfPage - bottomOfImageView;
                             [self.view layoutIfNeeded];
                         }];
    } else {
        [UIView animateWithDuration:.75
                         animations:^{
                             logoImageViewTop.constant = 10;
                             [self.view layoutIfNeeded];
                         }];
    }
    
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
        return [sortedKeys objectAtIndex:row];
    }
    
    NSInteger index = [topPicker selectedRowInComponent:0];
    NSString *key = [sortedKeys objectAtIndex:index];
    NSArray *array = [chartDictionary objectForKey:key];
    return [array objectAtIndex:row];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component{
    if (pickerView == topPicker) {
        NSString *title = [sortedKeys objectAtIndex:row];
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
