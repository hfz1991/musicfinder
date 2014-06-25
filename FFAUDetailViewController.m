//
//  FFAUDetailViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-1.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFAUDetailViewController.h"
#import "FFAppDelegate.h"

@interface FFAUDetailViewController ()

@end

@implementation FFAUDetailViewController
@synthesize myCover,imageURL,albumName,albumsLabel,artistLabel,artistName;

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
    albumsLabel.text=albumName;
    artistLabel.text=artistName;
    NSData *imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:imageURL]];
    myCover.image=[[UIImage alloc]initWithData:imageData];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addFavorite:(id)sender {
    FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //Entity
    NSEntityDescription *entity=[NSEntityDescription insertNewObjectForEntityForName:@"Albums" inManagedObjectContext:appDelegate.managedObjectContext];
    
    [entity setValue:albumName forKey:@"name"];
    [entity setValue:artistName forKey:@"artist"];
    [entity setValue:imageURL forKey:@"imageURL"];
    
    NSError *error;
    BOOL isSaved = [appDelegate.managedObjectContext save:&error];
    if (isSaved==1) {
        NSLog(@"Saved Status: %d",isSaved);
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:nil message:@"Saved Successful!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}
@end
