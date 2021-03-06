//
//  PFViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMetricViewController.h"
#import "PFUnitTableViewController.h"
#import "PFAppDelegate.h"
#import "PFTabView.h"
#import "PFStepper.h"
#import "PFButton.h"

@interface PFMetricViewController ()

- (void)onStepChanged:(id)sender;
- (void)textFieldDidChange:(id)sender;
- (BOOL)isSameUnitClass:(NSString *)convertee withUnit:(NSString *)converter;
- (BOOL)isEnglishUnitClass:(NSString *)unit;
- (BOOL)isMetricUnitClass:(NSString *)unit;
- (float)convertUnit:(NSString *)convertee withConverter:(NSString *)converter withValue:(float)value;
- (void) dismissKeyboard:(id)sender;

@end

#define METRIC_TO_ENGLISH   @"English"
#define ENGLISH_TO_METRIC   @"Metric"
#define MAX_NUMBER          1000000


int tabBarHeight;
#define SCROLL_VIEW_BOTTOM_CONSTANT (-1*tabBarHeight)

@implementation PFMetricViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Metric Converter";
        unitConvertDict = [[NSMutableDictionary alloc]init];
        //english
        [unitConvertDict setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Inch"]];
        [unitConvertDict setObject:[NSNumber numberWithInt:12] forKey:[NSString stringWithFormat:@"Foot"]];
        [unitConvertDict setObject:[NSNumber numberWithInt:36] forKey:[NSString stringWithFormat:@"Yard"]];
        [unitConvertDict setObject:[NSNumber numberWithInt:63360] forKey:[NSString stringWithFormat:@"Mile"]];
        
        [unitConvertDict setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Centimeter"]];
        [unitConvertDict setObject:[NSNumber numberWithFloat:10] forKey:[NSString stringWithFormat:@"Millimeter"]];
        [unitConvertDict setObject:[NSNumber numberWithFloat:0.01] forKey:[NSString stringWithFormat:@"Meter"]];
        [unitConvertDict setObject:[NSNumber numberWithFloat:0.00001] forKey:[NSString stringWithFormat:@"Kilometer"]];
        
        
        metricUnitConvertDict = [[NSMutableDictionary alloc]init];
        //metric
        [metricUnitConvertDict setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Centimeter"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:0.1] forKey:[NSString stringWithFormat:@"Millimeter"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:100] forKey:[NSString stringWithFormat:@"Meter"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:100000] forKey:[NSString stringWithFormat:@"Kilometer"]];
        
        //english
        [metricUnitConvertDict setObject:[NSNumber numberWithInt:1] forKey:[NSString stringWithFormat:@"Inch"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:12] forKey:[NSString stringWithFormat:@"Foot"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:36] forKey:[NSString stringWithFormat:@"Yard"]];
        [metricUnitConvertDict setObject:[NSNumber numberWithFloat:63360] forKey:[NSString stringWithFormat:@"Mile"]];
        
        englishMetricConvertDict = [[NSMutableDictionary alloc] init];
        [englishMetricConvertDict setObject:[NSNumber numberWithFloat:2.54] forKey:METRIC_TO_ENGLISH];
        [englishMetricConvertDict setObject:[NSNumber numberWithFloat:0.3937] forKey:ENGLISH_TO_METRIC];
    }
    return self;
}

-(void)loadView {
    // Set up main view
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [backgroundImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:backgroundImage];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redBanner];    
    
    topTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [topTextField setBorderStyle:UITextBorderStyleBezel];
    [topTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    topTextField.textAlignment = NSTextAlignmentCenter;
    [topTextField setBackgroundColor:[UIColor whiteColor]];
    [topTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:topTextField];
    
    topButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [topButton setTitle:@"Inch" forState:UIControlStateNormal];
    [topButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:topButton];

    topStepper = [[PFStepper alloc] initWithFrame:CGRectZero];
    [topStepper addTarget:self action:@selector(onStepChanged:) forControlEvents:UIControlEventValueChanged];
    [topStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [topStepper setTintColor:[UIColor blackColor]];
    topStepper.maximumValue = MAX_NUMBER;
    [scrollView addSubview:topStepper];

    bottomTextField = [[UITextField alloc]initWithFrame:CGRectZero];
    bottomTextField.textAlignment = NSTextAlignmentCenter;
    [bottomTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [bottomTextField setBorderStyle:UITextBorderStyleBezel];
    [bottomTextField setBackgroundColor:[UIColor whiteColor]];
    [bottomTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:bottomTextField];

    bottomButton = [PFButton buttonWithType:UIButtonTypeRoundedRect];
    [bottomButton setTitle:@"Centimeter" forState:UIControlStateNormal];
    [bottomButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bottomButton];

    bottomStepper = [[PFStepper alloc] initWithFrame:CGRectZero];
    [bottomStepper addTarget:self action:@selector(onStepChanged:) forControlEvents:UIControlEventValueChanged];
    [bottomStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [bottomStepper setTintColor:[UIColor blackColor]];
    bottomStepper.maximumValue = MAX_NUMBER;
    [scrollView addSubview:bottomStepper];
    
    UIImage *logoImage = [UIImage imageNamed:@"PFILogo"];
    logoImageView = [[UIImageView alloc] initWithImage:logoImage];
    [logoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:logoImageView];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        tabBarHeight = 100;
    } else {
        tabBarHeight = 65;
    }
    tabBar = [[PFTabView alloc] initWithFrame:CGRectMake(0,
                                                     self.view.bounds.size.height - tabBarHeight,
                                                     self.view.bounds.size.width,
                                                    tabBarHeight) withIndex:0];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
    //magic to get it to scroll when the keyboard is show
    scrollViewBottom =[NSLayoutConstraint
                       constraintWithItem:scrollView
                       attribute:NSLayoutAttributeBottom
                       relatedBy:NSLayoutRelationEqual
                       toItem:self.view
                       attribute:NSLayoutAttributeBottom
                       multiplier:1.0
                       constant:SCROLL_VIEW_BOTTOM_CONSTANT];
    
    [self.view addConstraint:scrollViewBottom];
    
    //
    myConstraint =[NSLayoutConstraint
                                       constraintWithItem:backgroundImage
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:self.view
                                       attribute:NSLayoutAttributeTop
                                       multiplier:1.0
                                       constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:backgroundImage
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
                    constraintWithItem:topTextField
                    attribute:NSLayoutAttributeTop
                    relatedBy:NSLayoutRelationEqual
                    toItem:redBanner
                    attribute:NSLayoutAttributeBottom
                    multiplier:1.0
                     constant:25];
                   
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topTextField
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:-60];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:redBanner
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:20];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:60];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topButton
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:35];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:topTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:topStepper
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:-57];
    [scrollView addConstraint:myConstraint];

    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:topStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:35];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomTextField
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:-57];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomButton
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:topTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:35 + topStepper.frame.size.height];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomButton
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomButton
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:60];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomButton
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:35];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:bottomTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:bottomStepper
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:-57];
    [scrollView addConstraint:myConstraint];
    
    //
    logoImageViewTop =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:bottomStepper
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //TODO: why do I need to call this for the logo to animate nicely when animated is NO
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
    
    //gradient magic
    [topButton addGradientLayer];
    [bottomButton addGradientLayer];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
 
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    float bottomOfImageView = bottomStepper.frame.origin.y + bottomStepper.frame.size.height + logoImageView.frame.size.height + 10;
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

// The callback for frame-changing of keyboard
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSValue *kbFrame = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [kbFrame CGRectValue];
    
    BOOL isPortrait = UIDeviceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
    CGFloat height = isPortrait ? keyboardFrame.size.height : keyboardFrame.size.width;
    scrollViewBottom.constant = (-1*height);
    
    if(UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        UITextField *focusTextField;
        if ([topTextField isFirstResponder]) {
            focusTextField = topTextField;
        } else {
            focusTextField = bottomTextField;
        }
        
        CGPoint bottomOffset = CGPointMake(0, focusTextField.frame.origin.y + focusTextField.frame.size.height + 5 - scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset];
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                              action:@selector(dismissKeyboard:)];
}

- (void) dismissKeyboard:(id)sender {
    [self.view endEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    scrollViewBottom.constant = SCROLL_VIEW_BOTTOM_CONSTANT;
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    self.navigationItem.rightBarButtonItem = nil;
}

/*
 * This probably should be cleanup in the future.
 * Its working now, but seem alittle sloppy, but I was getting pissed 
 * and was spending too much time on it.  Need to revisit when I'm 
 * calmer.
 */
- (float) convertUnit:(NSString *)convertee withConverter:(NSString *)converter withValue:(float)value {
    float converteeBase;
    float converterBase;
    float convertedValue;
    
    if (![self isSameUnitClass:convertee withUnit:converter]) {
        converterBase = [[unitConvertDict objectForKey:converter] floatValue];
        
        if ([self isMetricUnitClass:convertee]) {
            converteeBase = [[metricUnitConvertDict objectForKey:convertee] floatValue];
        } else {
            converteeBase = [[unitConvertDict objectForKey:convertee] floatValue];
        }
        
        float conversionRate;
        if ([self isEnglishUnitClass:converter]) {
            conversionRate = [[englishMetricConvertDict objectForKey:ENGLISH_TO_METRIC] floatValue];
        } else {
            conversionRate = [[englishMetricConvertDict objectForKey:METRIC_TO_ENGLISH] floatValue];
        }

        float baseValue;
        if ([self isMetricUnitClass:converter]) {
            baseValue = converteeBase * value * converterBase;
        } else {
            baseValue = converteeBase * value / converterBase;
        }
        convertedValue = (baseValue * conversionRate);
    } else {
        converterBase = [[metricUnitConvertDict objectForKey:converter] floatValue];
        converteeBase = [[metricUnitConvertDict objectForKey:convertee]floatValue];
        convertedValue = (converteeBase * value) / converterBase;
    }
    return convertedValue;
}

-(void) textFieldDidChange:(id)sender {
    if (topTextField == sender) {
        topStepper.value = [topTextField.text floatValue];
        NSString *convertee = topButton.titleLabel.text;
        NSString *converter = bottomButton.titleLabel.text;
        
        float value = [self convertUnit:convertee withConverter:converter withValue:topStepper.value];
        
        bottomTextField.text = [NSString stringWithFormat:@"%4.2f", value];
        bottomStepper.value = value;
        
    } else {
        bottomStepper.value = [bottomTextField.text floatValue];
        
        NSString *convertee = bottomButton.titleLabel.text;
        NSString *converter = topButton.titleLabel.text;
        
        float value = [self convertUnit:convertee withConverter:converter withValue:bottomStepper.value];
        
        topTextField.text = [NSString stringWithFormat:@"%4.2f", value];
        topStepper.value = value;
        
    }
}

-(void)onStepChanged:(id)sender {
    if (sender == topStepper) {
        topTextField.text = [NSString stringWithFormat:@"%4.2f", topStepper.value];
        
    
        NSString *convertee = topButton.titleLabel.text;
        NSString *converter = bottomButton.titleLabel.text;
        
        float value = [self convertUnit:convertee withConverter:converter withValue:topStepper.value];
        
        bottomTextField.text = [NSString stringWithFormat:@"%4.2f", value];
        bottomStepper.value = value;
        
        
    } else {
        bottomTextField.text = [NSString stringWithFormat:@"%4.2f", bottomStepper.value];
        
        NSString *convertee = bottomButton.titleLabel.text;
        NSString *converter = topButton.titleLabel.text;
        
        float value = [self convertUnit:convertee withConverter:converter withValue:bottomStepper.value];
        
        topTextField.text = [NSString stringWithFormat:@"%4.2f", value];
        topStepper.value = value;
    }
}

- (BOOL) isEnglishUnitClass:(NSString *)unit {
    if ([unit isEqualToString:@"Inch"] ||
        [unit isEqualToString:@"Foot"] ||
        [unit isEqualToString:@"Yard"] ||
        [unit isEqualToString:@"Mile"]) {
        return YES;
    }
    return NO;
}

- (BOOL) isMetricUnitClass:(NSString *)unit {
    if ([unit isEqualToString:@"Millimeter"] ||
        [unit isEqualToString:@"Centimeter"] ||
        [unit isEqualToString:@"Meter"] ||
        [unit isEqualToString:@"Kilometer"]) {
            return YES;
    }
    return NO;
}

/*
   Is it english to english conversion
   or English to metric that is the question.
 */
- (BOOL) isSameUnitClass:(NSString *)convertee withUnit:(NSString *)converter {
    
    BOOL isEnglish = NO;
    if ([self isEnglishUnitClass:convertee]) {
        isEnglish = YES;
    }
    
    if ([self isEnglishUnitClass:converter]) {
        if (isEnglish) {
            return YES;
        }
        return NO;
    }
    
    return !isEnglish ? YES : NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)buttonClicked:(id)sender
{
    NSInteger fromButton;
    PFUnitTableViewController *tableViewController;
    NSInteger unitType;
    if ([self isEnglishUnitClass:((UIButton *)sender).titleLabel.text]) {
        unitType = 0;
    } else {
        unitType = 1;
    }
    
    if (sender == topButton) {
        fromButton = 0;
    } else {
        fromButton = 1;
    }
    
    tableViewController = [[PFUnitTableViewController alloc] initWithUnitType:unitType settingCallback:self fromButton:fromButton];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (void) setButtonTitle:(NSString *)title fromIndex:(NSInteger) index {
    
    float value = 0.0f;
    topStepper.value = [topTextField.text floatValue];
    //NSString *converter = bottomButton.titleLabel.text;
    switch (index) {
        case 0: {
            [topButton setTitle:title forState:UIControlStateNormal];
            value = [self convertUnit:title withConverter:bottomButton.titleLabel.text withValue:topStepper.value];
            break;
        }
        case 1: {
            [bottomButton setTitle:title forState:UIControlStateNormal];
            value = [self convertUnit:topButton.titleLabel.text withConverter:title withValue:topStepper.value];
            break;
        }
    }

    bottomTextField.text = [NSString stringWithFormat:@"%4.2f", value];
    bottomStepper.value = value;
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
