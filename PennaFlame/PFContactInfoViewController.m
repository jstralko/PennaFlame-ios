//
//  PFContactInfoViewController.m
//  com.pennaflame.app
//
//  Created by Chris Copac on 10/5/13.
//  Copyright (c) 2013 Gerald Stralko. All rights reserved.
//

#import "PFContactInfoViewController.h"
#import "PFWebsiteViewController.h"

@interface PFContactInfoViewController ()

@end

@implementation PFContactInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Contact Info";
        self.view.backgroundColor = [UIColor grayColor];
        UIView *view = self.view;
        
    }
    return self;
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

-(IBAction)callButtonClicked:(id)sender {
    NSString *phoneNumber = @"telprompt://724-452-8750";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

-(IBAction)websiteButtonClicked:(id)sender {
    PFWebsiteViewController *website = [[PFWebsiteViewController alloc] init];
    [self.navigationController pushViewController:website animated:YES];
}

-(IBAction)emailButtonClicked:(id)sender {

    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;

        [mail setToRecipients:[NSArray arrayWithObject:@"brucec@pennaflame.com"]];
        [mail setSubject:@"<Set Subject Here>"];

        [self presentViewController:mail animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
