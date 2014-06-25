//
//  FFFavoriteViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-2.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFFavoriteViewController.h"
#import "FFFavoriteCell.h"
#import "FFAppDelegate.h"
#import "FFAUDetailViewController.h"
@interface FFFavoriteViewController ()
{
    UIRefreshControl *refreshControl;
    NSMutableArray *albumsArray;
    NSMutableArray *artistArray;
    NSMutableArray *imageUrlArray;
    int editFlag;
    
    NSMutableArray *array;
}
@end

@implementation FFFavoriteViewController
@synthesize myTableView;

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
    
    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    albumsArray=[[NSMutableArray alloc]init];
    artistArray=[[NSMutableArray alloc]init];
    imageUrlArray=[[NSMutableArray alloc]init];
    editFlag=0;
    
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(didDragRefreshController) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshControl];
    
    //Fetch Data
    FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Albums" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *fetchRqst = [[NSFetchRequest alloc]init];
    [fetchRqst setEntity:entity];
    
    array=[[appDelegate.managedObjectContext executeFetchRequest:fetchRqst error:nil]mutableCopy];
    
    
    for (NSManagedObject *obj in array) {
        if ([obj valueForKey:@"name"]!=NULL) {
            [albumsArray addObject:[obj valueForKey:@"name"]];
        }
        else [albumsArray addObject:@"NULL"];
        
        if ([obj valueForKey:@"artist"]!=NULL) {
            [artistArray addObject:[obj valueForKey:@"artist"]];
        }
        else [artistArray addObject:@"NULL"];
        
        if ([obj valueForKey:@"imageURL"]!=NULL) {
            [imageUrlArray addObject:[obj valueForKey:@"imageURL"]];
        }
        else [imageUrlArray addObject:@"NULL"];
        
        
        NSLog(@"NAME:%@\n",[obj valueForKey:@"name"]);
        NSLog(@"ARTIST:%@\n",[obj valueForKey:@"artist"]);
        NSLog(@"URL:%@\n",[obj valueForKey:@"imageURL"]);
        NSLog(@"array count:%lu",(unsigned long)array.count);
        
    }
    
}

-(void)didDragRefreshController
{
    
    [myTableView reloadData];
    
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [albumsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"FCell";
    
    

    FFFavoriteCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell=[[FFFavoriteCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[imageUrlArray objectAtIndex:indexPath.row]]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            cell.myCover.image=[[UIImage alloc]initWithData:imageData];
        });
    });
    cell.myAlbumsLabel.text=[albumsArray objectAtIndex:indexPath.row];
    cell.myArtistLabel.text=[artistArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (IBAction)editButton:(id)sender {
    if(editFlag==0)
    {
        editFlag=1;
        self.navigationItem.rightBarButtonItem.title=NSLocalizedString(@"Done", @"Done");
        [self.myTableView setEditing:YES animated:YES];
    }else
    {
        editFlag=0;
        self.navigationItem.rightBarButtonItem.title=NSLocalizedString(@"Edit", @"Edit");
        [self.myTableView setEditing:NO animated:YES];
    }

}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"Albums" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
//    NSArray *item=[appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    

    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [albumsArray removeObjectAtIndex:indexPath.row];
        [artistArray removeObjectAtIndex:indexPath.row];
        [imageUrlArray removeObjectAtIndex:indexPath.row];
        [myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSManagedObjectContext *context=appDelegate.managedObjectContext;
        [context deleteObject:[array objectAtIndex:indexPath.row]];
        if(![context save:&error])
        {
            NSLog(@"Can't Delete! %@ %@",error,[error localizedDescription]);
        }
//      [appDelegate.managedObjectContext deleteObject:eventToDelete];
        NSLog(@"After delete array count:%lu",(unsigned long)[array count]);

    }
    [myTableView reloadData];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FDSegue"]) {
        NSIndexPath *index=[myTableView indexPathForSelectedRow];
        FFAUDetailViewController *vc=[segue destinationViewController];
        vc.albumName=[albumsArray objectAtIndex:index.row];
        vc.artistName=[artistArray objectAtIndex:index.row];
        vc.imageURL=[imageUrlArray objectAtIndex:index.row];
    }
}

@end
