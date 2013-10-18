//
//  PFHomeViewController.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/17/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFHomeViewController.h"
#import "PFMetricViewController.h"
#import "PFContactInfoViewController.h"
#import "PFMathConverterViewController.h"
#import "PFHardnessCaseDepthViewController.h"
#import "PFMTIViewController.h"
#import "PFHardnessChartViewController.h"

#define HOME_CELL               @"HOME_CELL"
#define SUPPLEMENTARY_VIEW_CELL @"SUPPLEMENTARY_VIEW_CELL"

@interface PFHomeViewController ()

@end

@implementation PFHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.title = @"Penna Flame";
    }
    return self;
}

- (void) loadView {
   UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(125, 100);
    layout.sectionInset = UIEdgeInsetsMake(50, 10, 10, 10);
    layout.minimumInteritemSpacing = 10.0f;  //spacing between cells
    layout.minimumLineSpacing = 15.0f;       //space between cells vertical
    
    
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:HOME_CELL];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SUPPLEMENTARY_VIEW_CELL];
    self.collectionView .dataSource = self;
    self.collectionView .delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *cell = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SUPPLEMENTARY_VIEW_CELL forIndexPath:indexPath];
        UIImage *headerImage = [UIImage imageNamed:@"layer11.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
        [headerView addSubview:imageView];
        cell = headerView;
    }
    
    return cell;
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// 1
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 6;
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:HOME_CELL forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:cell.bounds];
    
    switch (indexPath.item) {
        case 0:
            label.text = @"English/Metric Converter";
            break;
        case 1:
            label.text = @"Fraction/Decimal Converter";
            break;
        case 2:
            label.text = @"Hardness Case Depth";
            break;
        case 3:
            label.text = @"MTI Statement";
            break;
        case 4:
            label.text = @"Hardness Chart";
            break;
        case 5:
            label.text = @"Contact Us";
            break;
        default:
            label.text = @"UNKNOWN";
            break;
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    label.minimumScaleFactor = .2f;
    label.numberOfLines = 2;
    label.adjustsFontSizeToFitWidth = YES;
    [cell.contentView addSubview:label];
    return cell;
}
// 4
/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
            PFHardnessChartViewController *pfhcvc = [[PFHardnessChartViewController alloc] init];
            [self.navigationController pushViewController:pfhcvc animated:YES];
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

@end
