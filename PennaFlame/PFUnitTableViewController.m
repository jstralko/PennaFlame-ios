//
//  PFUnitTableViewController.m
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/6/13.
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
        self.view.backgroundColor = [UIColor lightGrayColor];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
