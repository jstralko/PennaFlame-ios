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
#import "PFChartViewController.h"
#import "PFMTIViewController.h"
#import "PFHomeCollectionViewCell.h"
#import "PFAppDelegate.h"

#define HOME_CELL                       @"HOME_CELL"
#define SUPPLEMENTARY_VIEW_CELL         @"SUPPLEMENTARY_VIEW_CELL"
#define SUPPLEMENTARY_FOOTER_VIEW_CELL  @"SUPPLEMENTARY_FOOTER_VIEW_CELL"

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
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //iPad
        layout.itemSize = CGSizeMake(200, 200);
        layout.sectionInset = UIEdgeInsetsMake(75, 20, 10, 20);
        layout.minimumInteritemSpacing = 25.0f;  //spacing between cells
        layout.minimumLineSpacing = 25.0f;       //space between cells vertical
        layout.footerReferenceSize = CGSizeMake(0, 150);
        
    } else {
        //iPhone
        layout.itemSize = CGSizeMake(125, 100);
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
        layout.minimumInteritemSpacing = 20.0f;  //spacing between cells
        layout.minimumLineSpacing = 20.0f;       //space between cells vertical
        layout.footerReferenceSize = CGSizeMake(0, 75);
    }
    layout.headerReferenceSize = CGSizeMake(0, 10);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.backgroundColor = nil;
    [self.collectionView registerClass:[PFHomeCollectionViewCell class] forCellWithReuseIdentifier:HOME_CELL];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SUPPLEMENTARY_VIEW_CELL];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SUPPLEMENTARY_FOOTER_VIEW_CELL];
    self.collectionView .dataSource = self;
    self.collectionView .delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    backgroundImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [backgroundImage setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth];
    self.collectionView.backgroundView = backgroundImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionView Datasource

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    //datasetCell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"HomeButtonImage"]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *cell = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SUPPLEMENTARY_VIEW_CELL forIndexPath:indexPath];
        headerView.backgroundColor = [UIColor redColor];
        cell = headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:SUPPLEMENTARY_FOOTER_VIEW_CELL forIndexPath:indexPath];
        
        [[footerView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        UIImage *image = [UIImage imageNamed:@"PFILogo"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:footerView.bounds];
        [imageView setImage:image];
        [footerView addSubview:imageView];
        cell = footerView;
    }
    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    /* resize the image at the footer */
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor redColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFHomeCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:HOME_CELL forIndexPath:indexPath];
    
    switch (indexPath.item) {
        case 0: {
            cell.title.text = @"English / Metric Converter";
            UIImage *img = [UIImage imageNamed:@"EnglishMetric"];
            [cell setImageViewFrame:img];
        }
            break;
        case 1: {
            cell.title.text = @"Fraction / Decimal Converter";
            UIImage *img = [UIImage imageNamed:@"FractionDecimal"];
            [cell setImageViewFrame:img];
        }
            break;
        case 2: {
            cell.title.text = @"Hardness Case Depth";
            UIImage *img = [UIImage imageNamed:@"CaseDepthButton"];
            [cell setImageViewFrame:img];		
        }
            break;
        case 3: {
            cell.title.text = @"Hardness Chart";
            UIImage *img = [UIImage imageNamed:@"HardnessChartButton"];
            [cell setImageViewFrame:img];
        }
            break;
        case 4: {
            cell.title.text = @"MTI Statement of Liability";
            UIImage *img = [UIImage imageNamed:@"MTIStatementButton"];
            [cell setImageViewFrame:img];
        }
            break;
        case 5: {
            cell.title.text = @"Contact Us";
            UIImage *img = [UIImage imageNamed:@"ContactButton"];
            [cell setImageViewFrame:img];
        }
            break;
        default:
            break;
    }
    return cell;
}

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
            PFAppDelegate *appDelegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
            PFChartViewController *pfhcdc = [[PFChartViewController alloc]initWithDict:appDelegate.hardnessCaseDepthChartDict withTitle:HARDNESS_CASE_DEPTH_TITLE];
            [self.navigationController pushViewController:pfhcdc animated:YES];
        }
            break;
        case 3: {
            PFAppDelegate *appDelegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
            PFChartViewController *pfhcvc = [[PFChartViewController alloc]initWithDict:appDelegate.hardnessChartDict withTitle:HARDNESS_CHART_TITLE];
            [self.navigationController pushViewController:pfhcvc animated:YES];
        }
            break;
        case 4: {
            PFMTIViewController *pfmvc = [[PFMTIViewController alloc] init];
            [self.navigationController pushViewController:pfmvc animated:YES];

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
