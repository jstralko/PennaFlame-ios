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

@implementation PFUnitTableViewController

-(id) init {
    self = [super init];
    if (self) {
        englishUnits = [[NSMutableArray alloc] init];
        [englishUnits addObject:@"Inches"];
        [englishUnits addObject:@"Feet"];
        [englishUnits addObject:@"Yards"];
        [englishUnits addObject:@"Furlongs"];
        [englishUnits addObject:@"Miles"];
        
        currentDataSource = englishUnits;
        [segmentedControl setSelected:YES];
  
        metricUnits = [[NSMutableArray alloc] init];
        [metricUnits addObject:@"Millimeters"];
        [metricUnits addObject:@"Centimeters"];
        [metricUnits addObject:@"Decimeters"];
        [metricUnits addObject:@"Meters"];
        [metricUnits addObject:@"Kilometer"];
        

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    unitTable.dataSource = self;
    unitTable.delegate = self;
    
    [unitTable reloadData];

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
    // Signal the main registration controller with the selection
    NSString *selectedItemName = [currentDataSource objectAtIndex:[indexPath row]];
    
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
