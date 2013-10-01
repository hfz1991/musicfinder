//
//  FFViewController.m
//  jsonTute
//
//  Created by Fangzhou He on 13-8-30.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFViewController.h"
#import "FFCell.h"
@interface FFViewController ()
{
    NSMutableData *onlineJsonData;
    NSURLConnection *connection;
    NSMutableArray *resultArray;
    UIRefreshControl *refreshControl;
    NSMutableArray *indexArray;
    NSMutableArray *artistArray;
    NSMutableArray *imageUrlArray;
}

@end

@implementation FFViewController
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
	//Initial Table View
    myTableView.dataSource=self;
    myTableView.delegate=self;
    resultArray = [[NSMutableArray alloc]init];
    indexArray=[[NSMutableArray alloc]init];
    artistArray=[[NSMutableArray alloc]init];
    imageUrlArray=[[NSMutableArray alloc]init];
    
    //Initial Refresh Controller
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(didDragRefreshController)
             forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshControl];
    
}

-(void)didDragRefreshController
{

    [resultArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/au/rss/topalbums/limit=10/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        if(onlineJsonData==NULL) onlineJsonData = [[NSMutableData alloc]init];
        else [self.myTableView reloadData];
    }
    [refreshControl endRefreshing];
    
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [onlineJsonData setLength:0];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [onlineJsonData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error:(AU)Failed with connection error.");
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:onlineJsonData options:0 error:nil];
    NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
    NSArray *arrayOfEntry = [feed objectForKey:@"entry"];
    int indexInRank=0;
    for (NSDictionary *diction in arrayOfEntry) {
        NSDictionary *name = [diction objectForKey:@"im:name"];
        NSString *label=[name objectForKey:@"label"];
        NSString *rank=[NSString stringWithFormat:@"%i",indexInRank+1];
        
        NSDictionary *artist = [diction objectForKey:@"im:artist"];
        NSString *artistString=[artist objectForKey:@"label"];
        
        NSArray *image = [diction objectForKey:@"im:image"];
        NSDictionary *imageDiction = [image objectAtIndex:2];
        NSString *imageURL = [imageDiction objectForKey:@"label"];
        
        indexInRank++;
        [indexArray addObject:rank];
        [artistArray addObject:artistString];
        [resultArray addObject:label];
        [imageUrlArray addObject:imageURL];
        
    }
    [[self myTableView]reloadData];
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
    return [resultArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    
    FFCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell= [[FFCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSData *imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[imageUrlArray objectAtIndex:indexPath.row]]];
    
    cell.myCover.image=[[UIImage alloc]initWithData:imageData];
    
    cell.albumsLabel.text=[resultArray objectAtIndex:indexPath.row];
    cell.artistLabel.text=[artistArray objectAtIndex:indexPath.row];
    cell.rankLabel.text=[indexArray objectAtIndex:indexPath.row];
    return cell;
}

- (IBAction)getAuButton:(id)sender {
    
    [resultArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/au/rss/topalbums/limit=10/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        onlineJsonData = [[NSMutableData alloc]init];
        
    }
}
@end
