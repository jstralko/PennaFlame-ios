//
//  PFFullChartViewController.m
//  PennaFlame
//
//  Created by Gerald Stralko on 10/19/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFFullChartViewController.h"

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
    self = [super init];
    if (self) {
        chartDictionary = chartDict;
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
    //chart.delegate = self;
    [self.view addSubview:header_internalChart];
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
                   constant:15];
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
                   constant:20];
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
    
    myConstraint =[NSLayoutConstraint
                   constraintWithItem:chart
                   attribute:NSLayoutAttributeBottom
                   relatedBy:NSLayoutRelationEqual
                   toItem:self.view
                   attribute:NSLayoutAttributeBottom
                   multiplier:1.0
                   constant:0];
    [self.view addConstraint:myConstraint];
    
    
}

- (NSString *)generateHeaderChartFromDictionary {
    NSArray *keys = [chartDictionary allKeys];
    NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head>"
                             "</head>"
                             "<body style=\"bbackground-color: transparent;\">"
                             "<table id=\"myTable\" width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                             "<thead>"
                             "<tr bgcolor=\"lightgrey\" align=\"center\">"];
    
    for (NSString *key in keys) {
        [html appendFormat:@"<th bgcolor=\"#FF0000\"><span style=\"font-weight:bold;font-size:0.50em\">%@</span></th>", key];
    }
    [html appendFormat:@"</tr></thread>"];
    [html appendFormat:@"<tbody>"];
    [html appendFormat:@"</tbody></table></body></html>"];
    
    return html;
}

-(NSString *) generateChartFromDictionary {
    NSArray *keys = [chartDictionary allKeys];
    NSMutableString *html = [NSMutableString stringWithFormat:@"<html><head>"
                             "</head>"
                             "<body style=\"bbackground-color: transparent;\">"
                             "<table id=\"myTable\" width=\"90%%\" border=\"1\" align=\"center\" cellpadding=\"3\" cellspacing=\"0\" bordercolor=\"#CCCCC\">"
                             "<thead id=\"myTableHeader\" style=\"height:1px\">"
                             "<tr bgcolor=\"lightgrey\" align=\"center\">"];
    
    for (NSString *key in keys) {
        [html appendFormat:@"<th bgcolor=\"#FF0000\"><span style=\"font-weight:bold;font-size:0.50em\">%@</span></th>", key];
    }
    [html appendFormat:@"</tr></thread>"];
    [html appendFormat:@"<tbody>"];
    NSUInteger total = [[chartDictionary objectForKey:[keys objectAtIndex:0]] count];
    
    for (int i = 0 ; i < total; i++) {
        [html appendFormat:@"<tr bgcolor=\"white\">"];
        for (NSString *key in keys) {
            NSString *range = [[chartDictionary objectForKey:key] objectAtIndex:i];
            [html appendFormat:@"<td><div align=\"center\">%@</div></td>", range];
        }
        [html appendFormat:@"</tr>"];
    }
    [html appendFormat:@"</tbody></table></body></html>"];
    return html;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webviewDidFinished");
    
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
