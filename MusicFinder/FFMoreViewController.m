//
//  FFMoreViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-9-1.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFMoreViewController.h"

@interface FFMoreViewController ()

@end

@implementation FFMoreViewController
@synthesize introLabel,contactLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    introLabel.numberOfLines=0;
	//[introLabel sizeToFit];
    introLabel.text=@"-Find out the latest top 10 Albums any time, any where!\n\n-Add your favorite album\n\n-Search the song";
    contactLabel.numberOfLines=0;
    contactLabel.text=@"Thank you for your supporting to this App!It will keep update \nand waiting for your sincerely advise.\n\nMy Email:\nfunzho@hotmail.com";
}
 

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)contactButton:(id)sender {
    //set My Email Address
    NSArray *myEmailAddress = [NSArray arrayWithObject:@"funzho@hotmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    //set auto-fill the email address
    [mc setToRecipients:myEmailAddress];
    // Show Email onto the Screen
    [self presentViewController:mc animated:YES completion:NULL];
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled: NSLog(@"Email Status:Cancelled.");
            break;
        case MFMailComposeResultSaved: NSLog(@"Email Status:Saved");
            break;
        case MFMailComposeResultSent: NSLog(@"Email:Sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Error:Email sent failure! %@", [error localizedDescription]); break;
        default: break;
    }
    // Close the Email Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
    
    
@end
