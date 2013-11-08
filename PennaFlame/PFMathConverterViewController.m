//
//  PFMathConverterViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMathConverterViewController.h"

@interface PFMathConverterViewController ()

-(void)updateDecimal;
+ (int)gcdForNumber1:(int) m andNumber2:(int)n;
+ (int)tenRaisedTopower:(int)decimalLength;
- (void)floatToFraction:(float)decimalNumber;
- (void)syncSteppers;
- (void)drawFractionLayout;
- (void)drawDecimalLayout;


@end

@implementation PFMathConverterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Converter";
        self.view.backgroundColor = [UIColor lightGrayColor];
        
    }
    return self;
}

- (void)loadView
{
    // Set up main view
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [view setBackgroundColor:[UIColor colorWithRed:0.92 green:0.92 blue:0.92 alpha:1.0]];
    self.view = view;
    
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView setBounces:YES];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
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
    
//CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
    //frame = CGRectMake(45, 60, 100, 30);
    numeratorTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [numeratorTextField setBorderStyle:UITextBorderStyleBezel];
    [numeratorTextField setBackgroundColor:[UIColor whiteColor]];
    [numeratorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    numeratorTextField.textAlignment = NSTextAlignmentCenter;
    [numeratorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [numeratorTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    //[numeratorTextField becomeFirstResponder];
    [scrollView addSubview:numeratorTextField];

    //frame = CGRectMake(160, 60, 10, 30);
    fractionBarLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    fractionBarLabel.text = @"/";
    fractionBarLabel.backgroundColor = [UIColor lightGrayColor];
    [fractionBarLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:fractionBarLabel];

//    frame = CGRectMake(180, 60, 100, 30);
    denominatorTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [denominatorTextField setBorderStyle:UITextBorderStyleBezel];
    [denominatorTextField setBackgroundColor:[UIColor whiteColor]];
    [denominatorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    denominatorTextField.textAlignment = NSTextAlignmentCenter;
    [denominatorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [denominatorTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:denominatorTextField];
    
//    frame = CGRectMake(48, 100, 100, 25);
    numeratorStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [numeratorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    numeratorStepper.maximumValue = 100000;
    [numeratorStepper setTintColor:[UIColor blackColor]];
    [numeratorStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:numeratorStepper];

    //frame = CGRectMake(183, 100, 100, 25);
    denominatorStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    [denominatorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    denominatorStepper.maximumValue = 100000;
    [denominatorStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [denominatorStepper setTintColor:[UIColor blackColor]];
    [scrollView addSubview:denominatorStepper];
    
//    frame = CGRectMake(110, 145, 100, 30);
    decimalTextField = [[UITextField alloc] initWithFrame:CGRectZero];
    [decimalTextField setBorderStyle:UITextBorderStyleBezel];
    [decimalTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [decimalTextField setBackgroundColor:[UIColor whiteColor]];
    decimalTextField.textAlignment = NSTextAlignmentCenter;
    [decimalTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [decimalTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
    [scrollView addSubview:decimalTextField];
//
//    frame = CGRectMake(115, 185, 100, 25);
    decimalStepper = [[UIStepper alloc] initWithFrame:CGRectZero];
    decimalStepper.minimumValue = 0.00f;
    decimalStepper.stepValue = 0.0001f;
    [decimalStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    [decimalStepper setTranslatesAutoresizingMaskIntoConstraints:NO];
    [decimalStepper setTintColor:[UIColor blackColor]];
    [scrollView addSubview:decimalStepper];
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
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height - height);
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    NSTimeInterval animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view layoutIfNeeded];
    }];
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
        if (denominatorTextField.text.length == 0) {
            numeratorTextField.text = [NSString stringWithFormat:@"%d", 1];
        }
        [self updateDecimal];
    } else if (sender == denominatorStepper)  {
        [denominatorTextField setText:[NSString stringWithFormat:@"%d", intValue]];
        if (numeratorTextField.text.length == 0) {
            numeratorTextField.text = [NSString stringWithFormat:@"%d", 1];
        }
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
    }
}

- (void) syncSteppers {
    numeratorStepper.value = [numeratorTextField.text floatValue];
    denominatorStepper.value = [denominatorTextField.text floatValue];
    decimalStepper.value = [decimalTextField.text floatValue];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (numeratorTextField == theTextField) {
        if (denominatorTextField.text.length == 0) {
            denominatorTextField.text = [NSString stringWithFormat:@"%d", 1];
        }
        [self updateDecimal];
    } else if (denominatorTextField == theTextField) {
        if ([denominatorTextField.text intValue] >= 0) {
            if (numeratorTextField.text.length == 0) {
                numeratorTextField.text = [NSString stringWithFormat:@"%d", 1];
            }
            [self updateDecimal];
        }
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
    int decimalLength = [[components objectAtIndex:1] length];
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
                   toItem:segmentedControl
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
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:decimalStepper
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
    NSLayoutConstraint *myConstraint = [NSLayoutConstraint
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
                   constraintWithItem:decimalStepper
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:scrollView
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
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
}


@end
