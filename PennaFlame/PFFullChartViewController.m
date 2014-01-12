//
//  PFFullChartViewController.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFFullChartViewController.h"
#import "PFAppDelegate.h"
#import "PFTabView.h"

static NSString *disclaimerString = @"Note: This chart is a general guide. Hardness and case depth's may vary depending on the flame hardening technique used and actual chemistry of the material.";

@interface PFFullChartViewController ()

- (NSString *) generateChartFromDictionary;

- (NSString *)generateHeaderChartFromDictionary;

@end

@implementation PFFullChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id) initWithDict:(NSDictionary *)chartDict {
    return [self initWithDict:chartDict withTile:@"Full Chart"];
}

-(id) initWithDict:(NSDictionary *)chartDict withTile:(NSString *)title {
    return [self initWithDict:chartDict withSortedKeys:[chartDict allKeys] withTile:title];
}

-(id) initWithDict:(NSDictionary *)chartDict withSortedKeys:(NSArray *)keys withTile:(NSString *)title {
    self = [super init];
    if (self) {
        chartDictionary = chartDict;
        sortedKeys = keys;
        self.navigationItem.title = title;
    }
    
    return self;
}

-(void) loadView {
    [super loadView];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BackgroundImage"]];
    [background setFrame:self.view.bounds];
    [background setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:background];
    
    redBanner = [[UIView alloc] initWithFrame:CGRectZero];
    [redBanner setTranslatesAutoresizingMaskIntoConstraints:NO];
    redBanner.backgroundColor = [UIColor redColor];
    [self.view addSubview:redBanner];
    
    NSString *html = [self generateChartFromDictionary];
    if(!chart) chart = [[UIWebView alloc]initWithFrame:CGRectZero];
    [chart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [chart loadHTMLString:html baseURL:nil];
    [chart setBackgroundColor:[UIColor clearColor]];
    [chart setOpaque:NO];
    chart.scrollView.bounces = NO;
    chart.delegate = self;
    [self.view addSubview:chart];
    
    NSString *headerWV = [self generateHeaderChartFromDictionary];
    if(!header_internalChart) header_internalChart = [[UIWebView alloc]initWithFrame:CGRectZero];
    [header_internalChart setTranslatesAutoresizingMaskIntoConstraints:NO];
    [header_internalChart loadHTMLString:headerWV baseURL:nil];
    [header_internalChart setBackgroundColor:[UIColor clearColor]];
    [header_internalChart setOpaque:NO];
    header_internalChart.scrollView.scrollEnabled = NO;
    header_internalChart.scrollView.bounces = NO;
    [self.view addSubview:header_internalChart];
    
    disclaimer = [[UILabel alloc] initWithFrame:CGRectZero];
    [disclaimer setTranslatesAutoresizingMaskIntoConstraints:NO];
    [disclaimer setLineBreakMode:NSLineBreakByWordWrapping];
    disclaimer.numberOfLines = 4;
    disclaimer.textAlignment = NSTextAlignmentCenter;
    disclaimer.adjustsFontSizeToFitWidth = YES;
    disclaimer.font = [UIFont italicSystemFontOfSize:12];
    disclaimer.minimumScaleFactor = 0.5f;
    [disclaimer setText:disclaimerString];
    [self.view addSubview:disclaimer];
    
    if ([self.navigationItem.title isEqualToString:HARDNESS_CASE_DEPTH_TITLE]) {
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            tabBarHeight = 100;
        } else {
            tabBarHeight = 65;
        }
        tabBar = [[PFTabView alloc] initWithFrame:CGRectMake(0,
                                                         self.view.bounds.size.height - tabBarHeight,
                                                         self.view.bounds.size.width,
                                                         tabBarHeight) withIndex:2];
        [tabBar setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth];
        tabBar.delegate = (PFAppDelegate *)[UIApplication sharedApplication].delegate;
        [self.view addSubview:tabBar];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view removeConstraints:self.view.constraints];
    
    NSLayoutConstraint *myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:background
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    //start of redbanner
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:redBanner
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeTop
                   multiplier:1.0
                   constant:0];
    
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
    
    //header
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:header_internalChart
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:redBanner
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:5];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:header_internalChart
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:header_internalChart
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:header_internalChart
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:60];
    [self.view addConstraint:myConstraint];
    //end of header
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:redBanner
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:10];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    //disclaimer
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:disclaimer
                   attribute:NSLayoutAttributeTop
                   relatedBy:NSLayoutRelationEqual
                   toItem:chart
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:disclaimer
                   attribute:NSLayoutAttributeLeft
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeLeft
                   multiplier:1.0
                   constant:15];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:disclaimer
                   attribute:NSLayoutAttributeRight
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeRight
                   multiplier:1.0
                   constant:-15];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:disclaimer
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:disclaimer
                   attribute:NSLayoutAttributeHeight
                   relatedBy:NSLayoutRelationEqual
                   toItem:nil
                   attribute:NSLayoutAttributeNotAnAttribute
                   multiplier:1.0
                   constant:65];
    [self.view addConstraint:myConstraint];
    
    
}

- (NSString *)generateHeaderChartFromDictionary {
    NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head>"
                             "</head>"
                             "<body style=\"bbackground-color: transparent;\">"
                             "<table id=\"myTable\" width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                             "<thead>"
                             "<tr bgcolor=\"lightgrey\" align=\"center\">"];
    
    NSString *fontSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //iPad
        fontSize = @"1.0em";
    } else {
        fontSize = @"0.50em";
    }
    
    for (NSString *key in sortedKeys) {
        [html appendFormat:@"<th bgcolor=\"#FF0000\"><span style=\"font-weight:bold;font-size:%@\">%@</span></th>", fontSize, key];
    }
    [html appendFormat:@"</tr></thread>"];
    [html appendFormat:@"<tbody>"];
    [html appendFormat:@"</tbody></table></body></html>"];
    
    return html;
}

-(NSString *) generateChartFromDictionary {
    NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head>"
                             "</head>"
                             "<body style=\"bbackground-color: transparent;\">"
                             "<table id=\"myTable\" width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                             "<thead id=\"myTableHeader\">"
                             "<tr bgcolor=\"transparent\" align=\"center\">"];
    
    for (NSString *key in sortedKeys) {
        [html appendFormat:@"<th bgcolor=\"transparent\"><span style=\"opacity:0;font-weight:bold;font-size:0.50em\">%@</span></th>", key];
    }
    [html appendFormat:@"</tr></thread>"];
    [html appendFormat:@"<tbody>"];
    NSUInteger total = [[chartDictionary objectForKey:[sortedKeys objectAtIndex:0]] count];
    
    for (int i = 0 ; i < total; i++) {
        [html appendFormat:@"<tr bgcolor=\"white\">"];
        for (NSString *key in sortedKeys) {
            NSString *range = [[chartDictionary objectForKey:key] objectAtIndex:i];
            [html appendFormat:@"<td><div align=\"center\">%@</div></td>", range];
        }
        [html appendFormat:@"</tr>"];
    }
    [html appendFormat:@"</tbody></table>"];
    [html appendFormat:@"<span style=\"margin-left:5%%;margin-right:5%%;font-size:0.8em;font-style:italic;\">%@</span>", disclaimerString];
    [html appendFormat:@"</body></html>"];
    
    return html;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{    
    //load the jquery framework
    NSString *jqueryCore = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jquery-1.10.2.min.js"]];
    
    NSData *jquery = [NSData dataWithContentsOfFile:jqueryCore];
    NSString *jqueryString = [[NSMutableString alloc] initWithData:jquery encoding:NSUTF8StringEncoding];
    [chart stringByEvaluatingJavaScriptFromString:jqueryString];
    
    NSLog(@"jquery loaded");
    
    NSString *jqueryFixedHeaderTablePlugin = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"jquery.fixedheadertable.min.js"]];
    NSData *jqueryFixedHeaderTablePluginData = [NSData dataWithContentsOfFile:jqueryFixedHeaderTablePlugin];
    NSString *jqueryFixedHeaderTablePluginString = [[NSMutableString alloc] initWithData:jqueryFixedHeaderTablePluginData encoding:NSUTF8StringEncoding];
    [chart stringByEvaluatingJavaScriptFromString:jqueryFixedHeaderTablePluginString];
    
    NSLog(@"jquery.fixedheadertable plugin loaded");
    
    //debugging
    NSString *filePath = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] resourcePath]
        stringByAppendingPathComponent:@"foo.js"]];
    NSData *fooData = [NSData dataWithContentsOfFile:filePath];
    NSString *fooString = [[NSMutableString alloc] initWithData:fooData encoding:NSUTF8StringEncoding];
    [chart stringByEvaluatingJavaScriptFromString:fooString];
    
    NSLog(@"foo loaded");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
