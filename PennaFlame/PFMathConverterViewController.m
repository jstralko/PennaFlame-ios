//
//  PFMathConverterViewController.m
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMathConverterViewController.h"

@interface PFMathConverterViewController ()

-(void)updateDecimal;
+ (int)gcdForNumber1:(int) m andNumber2:(int)n;
+ (int)tenRaisedTopower:(int)decimalLength;
- (void)floatToFraction:(float)decimalNumber;
- (void)syncSteppers;


@end

@implementation PFMathConverterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"Converter";
        self.view.backgroundColor = [UIColor grayColor];
        
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
    
    CGRect frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height+75);
    scrollView = [[UIScrollView alloc] initWithFrame:frame];
    [self.view addSubview:scrollView];
    
    NSArray *itemArray = [NSArray arrayWithObjects: @"Fraction", @"Decimal", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl setCenter:CGPointMake(view.frame.size.width / 2, (segmentedControl.frame.size.height+10)/2)];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:segmentedControl];
    
//CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
    frame = CGRectMake(45, 60, 100, 30);
    numeratorTextField = [[UITextField alloc] initWithFrame:frame];
    [numeratorTextField setBorderStyle:UITextBorderStyleBezel];
    [numeratorTextField setBackgroundColor:[UIColor whiteColor]];
    [numeratorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    numeratorTextField.textAlignment = NSTextAlignmentCenter;
    [numeratorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    //[numeratorTextField becomeFirstResponder];
    [scrollView addSubview:numeratorTextField];
    
    frame = CGRectMake(160, 60, 10, 30);
    fractionBarLabel = [[UILabel alloc]initWithFrame:frame];
    fractionBarLabel.text = @"/";
    fractionBarLabel.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:fractionBarLabel];
    
    frame = CGRectMake(180, 60, 100, 30);
    denominatorTextField = [[UITextField alloc] initWithFrame:frame];
    [denominatorTextField setBorderStyle:UITextBorderStyleBezel];
    [denominatorTextField setBackgroundColor:[UIColor whiteColor]];
    [denominatorTextField setKeyboardType:UIKeyboardTypeNumberPad];
    denominatorTextField.textAlignment = NSTextAlignmentCenter;
    [denominatorTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:denominatorTextField];
    
    
    frame = CGRectMake(48, 100, 100, 25);
    numeratorStepper = [[UIStepper alloc] initWithFrame:frame];
    [numeratorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    numeratorStepper.maximumValue = 100000;
    [scrollView addSubview:numeratorStepper];
    
    frame = CGRectMake(183, 100, 100, 25);
    denominatorStepper = [[UIStepper alloc] initWithFrame:frame];
    [denominatorStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    denominatorStepper.maximumValue = 100000;
    [scrollView addSubview:denominatorStepper];
    
    //frame = CGRectMake(155, 110, 10, 25);
    //equalsLabel = [[UILabel alloc] initWithFrame:frame];
    //equalsLabel.text = @"=";
    //equalsLabel.backgroundColor = [UIColor grayColor];
    //[scrollView addSubview:equalsLabel];
    
    frame = CGRectMake(110, 145, 100, 30);
    decimalTextField = [[UITextField alloc] initWithFrame:frame];
    [decimalTextField setBorderStyle:UITextBorderStyleBezel];
    [decimalTextField setKeyboardType:UIKeyboardTypeDecimalPad];
    [decimalTextField setBackgroundColor:[UIColor whiteColor]];
    decimalTextField.textAlignment = NSTextAlignmentCenter;
    [decimalTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [scrollView addSubview:decimalTextField];
    
    frame = CGRectMake(115, 185, 100, 25);
    decimalStepper = [[UIStepper alloc] initWithFrame:frame];
    decimalStepper.minimumValue = 0.00f;
    decimalStepper.stepValue = 0.0001f;
    [decimalStepper addTarget:self action:@selector(steppervalueChanged:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:decimalStepper];
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

-(IBAction)onSegmentedControlChanged:(id)sender
{
    switch([sender selectedSegmentIndex]) {
        case 0: {
            CGRect frame = CGRectMake(45, 60, 100, 30);
            [numeratorTextField setFrame:frame];
            
            frame = CGRectMake(160, 60, 10, 30);
            [fractionBarLabel setFrame:frame];
            
            frame = CGRectMake(180, 60, 100, 30);
            [denominatorTextField setFrame:frame];
            
            frame = CGRectMake(48, 100, 100, 25);
            [numeratorStepper setFrame:frame];
            
            frame = CGRectMake(183, 100, 100, 25);
            [denominatorStepper setFrame:frame];
            
            frame = CGRectMake(155, 110, 10, 25);
            [equalsLabel setFrame:frame];
            
            frame = CGRectMake(110, 145, 100, 30);
            [decimalTextField setFrame:frame];
            
            frame = CGRectMake(115, 185, 100, 25);
            [decimalStepper setFrame:frame];
            
        }
            break;
        case 1: {
            CGRect frame = CGRectMake(110, 60, 100, 30);
            [decimalTextField setFrame:frame];
            
            frame = CGRectMake(115, 95, 100, 25);
            [decimalStepper setFrame:frame];
            
            frame = CGRectMake(155, 120, 10, 25);
            [equalsLabel setFrame:frame];
            
            //CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
            frame = CGRectMake(45, 145, 100, 30);
            [numeratorTextField setFrame:frame];
            
            frame = CGRectMake(180, 145, 100, 30);
            [denominatorTextField setFrame:frame];
            
            frame = CGRectMake(160, 145, 10, 25);
            [fractionBarLabel setFrame:frame];
            
            frame = CGRectMake(48, 180, 100, 25);
            [numeratorStepper setFrame:frame];
            
            frame = CGRectMake(183, 180, 100, 25);
            [denominatorStepper setFrame:frame];
            
            
        }
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


@end
