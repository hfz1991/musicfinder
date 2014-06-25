//
//  FFSearchViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-2.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFSearchViewController.h"
#import "FFSearchResultViewController.h"

@interface FFSearchViewController ()
{
    NSString *keyWord;
}
@end

@implementation FFSearchViewController
@synthesize myTextField;

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButton:(id)sender {
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchSegue"]) {
        FFSearchResultViewController *vc=[segue destinationViewController];
        vc.keyWord=myTextField.text;
    }
}

@end
