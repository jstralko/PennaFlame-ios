//
//  PFUnitTableViewController.m
//  com.pennaflame.app
//
//  Created by Gerald Stralko on 10/6/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFUnitTableViewController.h"

@interface PFUnitTableViewController ()

@end

NSArray *currentDataSource;
NSMutableArray *englishUnits;
NSMutableArray *metricUnits;
PFMetricViewController *metricViewController;
NSInteger buttonClicked;
NSInteger defaultSelectionIndex;

@implementation PFUnitTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Units";
    }
    return self;
}

-(id)initWithUnitType:(NSInteger)unitType settingCallback:(PFMetricViewController *)controller fromButton:(NSInteger) button {
    self = [super init];
    if (self) {
        englishUnits = [[NSMutableArray alloc] init];
        [englishUnits addObject:@"Inch"];
        [englishUnits addObject:@"Foot"];
        [englishUnits addObject:@"Yard"];
        [englishUnits addObject:@"Mile"];
        
        metricUnits = [[NSMutableArray alloc] init];
        [metricUnits addObject:@"Millimeter"];
        [metricUnits addObject:@"Centimeter"];
        [metricUnits addObject:@"Meter"];
        [metricUnits addObject:@"Kilometer"];
        
        defaultSelectionIndex = unitType;
        [segmentedControl setSelectedSegmentIndex:defaultSelectionIndex];
        
        if (unitType == 0) {
            currentDataSource = englishUnits;
        } else {
            currentDataSource = metricUnits;
        }
        
        unitTable.dataSource = self;
        unitTable.delegate = self;
        
        [unitTable reloadData];
        
        metricViewController = controller;
        buttonClicked = button;
    }
    return self;
}

- (void) loadView {
    
    [super loadView];
    
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [backgroundImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    backgroundImage.frame = self.view.frame;
    [self.view addSubview:backgroundImage];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [self.view addSubview:redBanner];
    
    if (!segmentedControl) segmentedControl = [[UISegmentedControl alloc] initWithFrame:CGRectZero];
    [segmentedControl insertSegmentWithTitle:@"English" atIndex:0 animated:NO];
    [segmentedControl insertSegmentWithTitle:@"Metric" atIndex:1 animated:NO];
    [segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [segmentedControl setTintColor:[UIColor blackColor]];
    [segmentedControl addTarget:self action:@selector(onSegmentedControlClick:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    if (!unitTable) unitTable = [[UITableView alloc] initWithFrame:CGRectZero];
    [unitTable setTranslatesAutoresizingMaskIntoConstraints:NO];
    unitTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundImage"]];
    [self.view addSubview:unitTable];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view removeConstraints:self.view.constraints];
    
    //start of redbanner
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:65];
    
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeWidth
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeWidth
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:10];
    [self.view addConstraint:myConstraint];
    //end of redbanner
    
     myConstraint =[NSLayoutConstraint
                                       constraintWithItem:segmentedControl
                                       attribute:NSLayoutAttributeTop
                                       relatedBy:NSLayoutRelationEqual
                                       toItem:redBanner
                                       attribute:NSLayoutAttributeBottom
                                       multiplier:1.0
                                       constant:25];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:segmentedControl
                   attribute:NSLayoutAttributeCenterX
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeCenterX
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:unitTable
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:segmentedControl
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:10];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:unitTable
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:unitTable
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:unitTable
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [currentDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [currentDataSource objectAtIndex:[indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *selectedItemName = [currentDataSource objectAtIndex:[indexPath row]];
    [metricViewController setButtonTitle:selectedItemName fromIndex:buttonClicked];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onSegmentedControlClick:(id)sender {
    switch([sender selectedSegmentIndex]) {
        case 0:
            currentDataSource = englishUnits;
            break;
        case 1:
            currentDataSource = metricUnits;
            break;
    }
    
    [unitTable reloadData];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
