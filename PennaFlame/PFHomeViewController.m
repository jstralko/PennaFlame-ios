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

#define HOME_CELL               @"HOME_CELL"
#define SUPPLEMENTARY_VIEW_CELL @"SUPPLEMENTARY_VIEW_CELL"

@interface PFHomeViewController ()

@end

@implementation PFHomeViewController

NSMutableDictionary *hardnessCaseDepthChartDict;
NSMutableDictionary *hardnessChartDict;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationItem.title = @"Penna Flame";
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessCaseDepth" ofType:@"plist"];
        hardnessCaseDepthChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
        
        plistPath = [[NSBundle mainBundle] pathForResource:@"HardnessChartData" ofType:@"plist"];
        hardnessChartDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return self;
}

- (void) loadView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //iPad
        layout.itemSize = CGSizeMake(200, 200);
        layout.sectionInset = UIEdgeInsetsMake(150, 20, 10, 20);
        layout.minimumInteritemSpacing = 25.0f;  //spacing between cells
        layout.minimumLineSpacing = 25.0f;       //space between cells vertical
        
    } else {
        //iPhone
        layout.itemSize = CGSizeMake(125, 100);
        layout.sectionInset = UIEdgeInsetsMake(20, 20, 10, 20);
        layout.minimumInteritemSpacing = 20.0f;  //spacing between cells
        layout.minimumLineSpacing = 20.0f;       //space between cells vertical
    }
    
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

//TODO: add header or footer
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

- (void)collectionView:(UICollectionView *)colView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = nil;
}


- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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
            PFChartViewController *pfhcdc = [[PFChartViewController alloc]initWithDict:hardnessCaseDepthChartDict withTitle:@"Hardness Case Depth"];
            [self.navigationController pushViewController:pfhcdc animated:YES];
        }
            break;
        case 3: {
            PFMTIViewController *pfmvc = [[PFMTIViewController alloc] init];
            [self.navigationController pushViewController:pfmvc animated:YES];
        }
            break;
        case 4: {
            PFChartViewController *pfhcvc = [[PFChartViewController alloc]initWithDict:hardnessChartDict withTitle:@"Hardness Chart"];
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
