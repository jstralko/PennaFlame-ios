//
//  PFMathConverterViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMathConverterViewController.h"
#import "PFAppDelegate.h"
#import "PFTabView.h"
#import "PFStepper.h"

@interface PFMathConverterViewController ()

-(void)updateDecimal;
+ (int)gcdForNumber1:(int) m andNumber2:(int)n;
+ (int)tenRaisedTopower:(int)decimalLength;
- (void)floatToFraction:(float)decimalNumber;
- (void)syncSteppers;
- (void)drawFractionLayout;
- (void)drawDecimalLayout;
- (void) dismissKeyboard:(id)sender;


@end

int tabBarHeight;
#define SCROLL_VIEW_BOTTOM_CONSTANT (-1*tabBarHeight) + 5

@implementation PFMathConverterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Converter";
        /*
         * You can use an appearance proxy to set particular appearance properties for all instances of a view in your application.
         * For example, if you want all sliders in your app to have a particular minimum track tint color, you can specify this
         * with a single message to the slider’s appearance proxy.
         */
//        UIStepper *proxy = [UIStepper appearance];
//        UIImage *minusImage = [[UIImage imageNamed:@"MinusImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIImage *minusDownStateImage = [[UIImage imageNamed:@"MinusDownStateImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIImage *plusImage = [[UIImage imageNamed:@"PlusImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        UIImage *plusDownStateImage = [[UIImage imageNamed:@"PlusDownStateImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        
//        [[UIStepper appearance] setDecrementImage:minusImage forState:UIControlStateNormal];
//        [[UIStepper appearance] setDecrementImage:minusDownStateImage forState:UIControlStateHighlighted];
//        [[UIStepper appearance] setIncrementImage:plusImage forState:UIControlStateNormal];
//        [[UIStepper appearance] setIncrementImage:plusDownStateImage forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)loadView
{
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
    
    redPadding = [[UIView alloc] initWithFrame:CGRectZero];
    [redPadding setTranslatesAutoresizingMaskIntoConstraints:NO];
    redPadding.backgroundColor = [UIColor redColor];
    [scrollView addSubview:redPadding];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Fraction", @"Decimal", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setFrame:CGRectZero];
    [segmentedControl setTintColor:[UIColor blackColor]];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:segmentedControl];
    
    numeratorTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [numeratorTextField setBorderStyle:UITextBorderStyleBezel];
    [numeratorTextField setBackgroundColor:[UIColor whiteColor]];
    [numeratorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    numeratorTextField.textAlignment = NSTextAlignmentCenter;
    [numeratorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [numeratorTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[numeratorTextField becomeFirstResponder];
    [scrollView addSubview:numeratorTextField];

    fractionBarLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    fractionBarLabel.text = @"/";
    [fractionBarLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:fractionBarLabel];

    denominatorTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [denominatorTextField setBorderStyle:UITextBorderStyleBezel];
    [denominatorTextField setBackgroundColor:[UIColor whiteColor]];
    [denominatorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    denominatorTextField.textAlignment = NSTextAlignmentCenter;
    [denominatorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [denominatorTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:denominatorTextField];
    
    numeratorStepper = [[PFStepper alloc] initWithFrame:CGRectZero];
    [numeratorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    numeratorStepper.maximumValue = 100000;
    [numeratorStepper setTintColor:[UIColor blackColor]];
    [numeratorStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:numeratorStepper];

    denominatorStepper = [[PFStepper alloc] initWithFrame:CGRectZero];
    [denominatorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    denominatorStepper.maximumValue = 100000;
    [denominatorStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [denominatorStepper setTintColor:[UIColor blackColor]];
    [scrollView addSubview:denominatorStepper];
    
    decimalTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [decimalTextField setBorderStyle:UITextBorderStyleBezel];
    [decimalTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [decimalTextField setBackgroundColor:[UIColor whiteColor]];
    decimalTextField.textAlignment = NSTextAlignmentCenter;
    [decimalTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [decimalTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:decimalTextField];

    decimalStepper = [[PFStepper alloc] initWithFrame:CGRectZero];
    decimalStepper.minimumValue = 0.00f;
    decimalStepper.stepValue = 0.0001f;
    [decimalStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    [decimalStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [decimalStepper setTintColor:[UIColor blackColor]];
    [scrollView addSubview:decimalStepper];
    
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
                                                         tabBarHeight) withIndex:1];
    [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
    tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
    [self.view addSubview:tabBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self drawFractionLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
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
        if ([numeratorTextField isFirstResponder]) {
            focusTextField = numeratorTextField;
        } else if ([decimalTextField isFirstResponder]) {
            focusTextField = decimalTextField;
        } else {
            focusTextField = denominatorTextField;
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
    [scrollView setContentOffset:CGPointZero];
    
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
    self.navigationItem.rightBarButtonItem = nil;
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
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    float bottomOfPage = self.view.frame.size.height - tabBarHeight;
    UIView *view = [segmentedControl selectedSegmentIndex] == 0 ? decimalStepper : numeratorStepper;
    float bottomOfImageView = view.frame.origin.y + view.frame.size.height + logoImageView.frame.size.height + 10;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)onSegmentedControlChanged:(id)sender
{
    
   switch([sender selectedSegmentIndex]) {
        case 0: {
            [self drawFractionLayout];
        }
            break;
        case 1: {
            [self drawDecimalLayout];
        }
           break;
    }
}

- (IBAction)steppervalueChanged:(UIStepper *)sender {
    double value = [sender value];
    int intValue = (int)value;
    if (sender == numeratorStepper) {
        [numeratorTextField setText:[NSString stringWithFormat:@"%d", intValue]];
        [self updateDecimal];
    } else if (sender == denominatorStepper)  {
        [denominatorTextField setText:[NSString stringWithFormat:@"%d", intValue]];
        [self updateDecimal];
    } else {
        [decimalTextField setText:[NSString stringWithFormat:@"%4.4f", value]];
        [self floatToFraction:value];
        return;
    }
    
    [self syncSteppers];
    
}

- (void) updateDecimal {
    int numInt = [numeratorTextField.text intValue];
    int demInt = [denominatorTextField.text intValue];
    
    if (demInt != 0) {
        [decimalTextField setText:[NSString stringWithFormat:@"%4.4f", numInt/(demInt*1.0)]];
    } else {
        [decimalTextField setText:@""];
    }
}

- (void) syncSteppers {
    numeratorStepper.value = [numeratorTextField.text floatValue];
    denominatorStepper.value = [denominatorTextField.text floatValue];
    decimalStepper.value = [decimalTextField.text floatValue];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (numeratorTextField == theTextField) {
        [self updateDecimal];
    } else if (denominatorTextField == theTextField) {
        [self updateDecimal];
    } else {
        float decimal = [decimalTextField.text floatValue];
        if (decimal > 0.0f) {
            [self floatToFraction:[decimalTextField.text floatValue]];
        }
    }
    
    [self syncSteppers];
}

+ (int)gcdForNumber1:(int) m andNumber2:(int) n
{
    while( m!= n) // execute loop until m == n
    {
        if( m > n)
            m= m - n; // large - small , store the results in large variable<br>
        else
            n= n - m;
    }
    return ( m); // m or n is GCD
}


+ (int)tenRaisedTopower:(int)decimalLength {
    int answer = 10;
    while (decimalLength!= 1) {
        answer *= 10;
        decimalLength -- ;
    }
    return answer;
}

- (void)floatToFraction:(float)decimalNumber
{
    NSString *decimalString = [NSString stringWithFormat:@"%f", decimalNumber];
    NSArray *components = [decimalString componentsSeparatedByString:@"."];
    NSUInteger decimalLength = [[components objectAtIndex:1] length];
    int n = [PFMathConverterViewController tenRaisedTopower:decimalLength];
    int m = [[components objectAtIndex:1] intValue];
    if (m != 0) {
        int gcd = [PFMathConverterViewController gcdForNumber1:m andNumber2:n];
        int numer = m/gcd;
        int deno = n/gcd;
        int fractionnumer = ([[components objectAtIndex:0] intValue] * deno) + numer;
        numeratorTextField.text = [NSString stringWithFormat:@"%d", fractionnumer];
        denominatorTextField.text = [NSString stringWithFormat:@"%d", deno];
        numeratorStepper.value = fractionnumer;
        denominatorStepper.value = deno;
    } else {
        numeratorTextField.text = [components objectAtIndex:0];
        denominatorTextField.text = [NSString stringWithFormat:@"%d", 1];
        numeratorStepper.value = (int)decimalNumber;
        denominatorStepper.value = 1;
    }
}

- (void) drawFractionLayout {
    [self.view removeConstraints:self.view.constraints];
    [scrollView removeConstraints:scrollView.constraints];
    // Do any additional setup after loading the view from its nib.
    NSLayoutConstraint *myConstraint =  [NSLayoutConstraint
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
                   constant:(-1*tabBarHeight)+5];
    [self.view addConstraint:myConstraint];
    
    //
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:redPadding
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:15];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:175];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:segmentedControl
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:segmentedControl
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:fractionBarLabel
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:-20];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:segmentedControl
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:fractionBarLabel
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:20];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:numeratorTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:numeratorTextField
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:denominatorTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:denominatorTextField
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:numeratorStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:15];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:decimalTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    //
    float constant = 0.0f;
    if (logoImageViewTop != nil) {
        constant = logoImageViewTop.constant;
    }
    logoImageViewTop =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:decimalStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:constant];
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

- (void) drawDecimalLayout {
    [self.view removeConstraints:self.view.constraints];
    [scrollView removeConstraints:scrollView.constraints];
    
    // Do any additional setup after loading the view from its nib.
    NSLayoutConstraint *myConstraint =  [NSLayoutConstraint
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
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redPadding
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:redPadding
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:15];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:175];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:segmentedControl
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalTextField
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:decimalTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:decimalStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:25];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:fractionBarLabel
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:decimalStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:23];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorTextField
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:fractionBarLabel
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:-20];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:decimalStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:23];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorTextField
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:fractionBarLabel
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:20];
    [scrollView addConstraint:myConstraint];
    
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:numeratorTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:numeratorStepper
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:numeratorTextField
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:denominatorTextField
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:100];
    [scrollView addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:denominatorStepper
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:denominatorTextField
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:3];
    [scrollView addConstraint:myConstraint];
    
    //
    float constant = logoImageViewTop.constant;
    logoImageViewTop =[NSLayoutConstraint
                   constraintWithItem:logoImageView
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationGreaterThanOrEqual
                   toItem:denominatorStepper
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:constant];
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


@end
