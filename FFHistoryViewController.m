//
//  FFHistoryViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-20.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFHistoryViewController.h"
#import "FFAppDelegate.h"
#import "FFSearchResultViewController.h"
#import "FFHistoryCell.h"
@interface FFHistoryViewController ()
{
    NSMutableArray *keyWordArray;
}

@end

@implementation FFHistoryViewController
@synthesize myTableView,keyWordStringArray;

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
    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    keyWordArray=[[NSMutableArray alloc]init];
    keyWordStringArray=[[NSMutableArray alloc]init];
    
    //Fetch Data from CoreData
    
    FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSLog(@"History MOC:%@",appDelegate.managedObjectContext);
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"History" inManagedObjectContext:appDelegate.managedObjectContext];
    NSFetchRequest *fetchRqst = [[NSFetchRequest alloc]init];
    [fetchRqst setEntity:entity];
    
    keyWordArray=[[appDelegate.managedObjectContext executeFetchRequest:fetchRqst error:nil]mutableCopy];
    
    for (NSManagedObject *obj in keyWordArray) {
        if ([obj valueForKey:@"keyWord"]!=NULL) {
            [keyWordStringArray addObject:[obj valueForKey:@"keyWord"]];
        }
        else [keyWordStringArray addObject:@"NULL"];
    }
    
    NSLog(@"Keyword database count:%lu",(unsigned long)keyWordArray.count);
    NSLog(@"Keyword table count:%lu",(unsigned long)keyWordStringArray.count);
    for(NSManagedObject *obj in keyWordStringArray)
    {
        NSLog(@"%@",obj);
    }
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
    return keyWordStringArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"HCell";
    
    FFHistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell=[[FFHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text=[keyWordStringArray objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (IBAction)deleteButton:(id)sender {
    
    FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity=[NSEntityDescription entityForName:@"History" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    [keyWordStringArray removeAllObjects];
    for (NSManagedObject *obj in keyWordArray) {
        [appDelegate.managedObjectContext deleteObject:obj];
    }
    
    if(![appDelegate.managedObjectContext save:&error])
    {
        NSLog(@"Can't Delete! %@ %@",error,[error localizedDescription]);
    }
    NSLog(@"Keyword database count:%lu",(unsigned long)keyWordArray.count);
    NSLog(@"Keyword table count:%lu",(unsigned long)keyWordStringArray.count);
    [myTableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"searchHistorySegue"]) {
        FFSearchResultViewController *vC=[segue destinationViewController];
        NSIndexPath *index=[myTableView indexPathForSelectedRow];
        vC.keyWord=[keyWordStringArray objectAtIndex:index.row];
    }
}
@end
