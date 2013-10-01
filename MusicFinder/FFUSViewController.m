//
//  FFUSViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-8-31.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFUSViewController.h"

@interface FFUSViewController ()
{
    NSMutableData *onlineJsonData;
    NSURLConnection *connection;
    NSMutableArray *resultArray;
    UIRefreshControl *refreshControl;
}
@end

@implementation FFUSViewController
@synthesize notificationLabel;

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
    [[self myTableView]setDataSource:self];
    [[self myTableView]setDelegate:self];
    resultArray=[[NSMutableArray alloc]init];
    
    //Initial Refresh Controller
    refreshControl=[[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(didDragRefreshController)
             forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshControl];

    
}

-(void)didDragRefreshController
{
    notificationLabel.text=@"Connecting...";
    [resultArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=10/json"];
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
    NSLog(@"Error:(US)Failed with error.");
    notificationLabel.text=@"Error! Please check the connection.";
    [notificationLabel setHidden:NO];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [notificationLabel setHidden:YES];
    NSDictionary *allDataDictionary = [NSJSONSerialization JSONObjectWithData:onlineJsonData options:0 error:nil];
    NSDictionary *feed = [allDataDictionary objectForKey:@"feed"];
    NSArray *arrayOfEntry = [feed objectForKey:@"entry"];
    int indexInRank=0;
    for (NSDictionary *diction in arrayOfEntry) {
        NSDictionary *title = [diction objectForKey:@"title"];
        NSString *label=[title objectForKey:@"label"];
        NSString *rank=[NSString stringWithFormat:@"%i: ",indexInRank+1];
        NSString *newLabel=[rank stringByAppendingString:label];
        
        [resultArray addObject:newLabel];
        indexInRank++;
    }
    
    [[self myTableView]reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button:(id)sender {
    
    notificationLabel.text=@"Connecting...";
    [resultArray removeAllObjects];
    
    NSURL *url = [NSURL URLWithString:@"http://itunes.apple.com/us/rss/topalbums/limit=10/json"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    connection = [NSURLConnection connectionWithRequest:request delegate:self];
    
    if(connection)
    {
        onlineJsonData = [[NSMutableData alloc]init];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"usCell";
    UITableViewCell *usCell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!usCell)
    {
        usCell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    usCell.textLabel.text=[resultArray objectAtIndex:indexPath.row];
    return usCell;
}

@end
