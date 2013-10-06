//
//  PFMasterViewController.m
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFMasterViewController.h"
#import "PFMetricViewController.h"
#import "PFContactInfoViewController.h"
#import "PFMathConverterViewController.h"
#import "PFHardnessCaseDepthViewController.h"
#import "PFMTIViewController.h"

#import "PFFakeViewController.h"

@interface PFMasterViewController () {
}
@end

@implementation PFMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //self.clearsSelectionOnViewWillAppear = NO;
        //self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.navigationItem.title = @"Penna Flame";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.item) {
        case 0:
            cell.textLabel.text = @"English/Metric Converter";
            break;
        case 1:
            cell.textLabel.text = @"Fraction/Decimal Converter";
            break;
        case 2:
            cell.textLabel.text = @"Hardness Case Depth";
            break;
        case 3:
            cell.textLabel.text = @"MTI Statement";
            break;
        case 4:
            cell.textLabel.text = @"Hardness Chart";
            break;
        case 5:
            cell.textLabel.text = @"Contact Us";
            break;
        default:
            cell.textLabel.text = @"UNKNOWN";
            break;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        //NSDate *object = _objects[indexPath.row];
        //self.detailViewController.detailItem = object;
    } else {
        
        switch (indexPath.row) {
            case 0: {
                PFMetricViewController *pfvc = [[PFMetricViewController alloc]init];
                [self.navigationController pushViewController:pfvc animated:YES];
            }
                break;
            case 1: {
                PFMathConverterViewController *pfmc = [[PFMathConverterViewController alloc]init];
                [self.navigationController pushViewController:pfmc animated:YES];
            }
                break;
            case 2: {
                PFHardnessCaseDepthViewController *pfhcdc = [[PFHardnessCaseDepthViewController alloc]init];
                [self.navigationController pushViewController:pfhcdc animated:YES];
            }
                break;
            case 3: {
                PFMTIViewController *pfmvc = [[PFMTIViewController alloc] init];
                [self.navigationController pushViewController:pfmvc animated:YES];
            }
                break;
            case 4: {
                PFFakeViewController *fake = [[PFFakeViewController alloc] init];
                [self.navigationController pushViewController:fake animated:YES];
            }
                break;
            case 5: {
                PFContactInfoViewController *pfci = [[PFContactInfoViewController alloc]init];
                [self.navigationController pushViewController:pfci animated:YES];
            }
                break;
            default:
                break;
        }
        
    }
}

@end
