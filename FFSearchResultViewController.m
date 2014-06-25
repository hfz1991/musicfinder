//
//  FFSearchResultViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-18.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFSearchResultViewController.h"
#import "FFSearchCell.h"
#import "FFSearchResultDetailViewController.h"
#import "FFAppDelegate.h"

@interface FFSearchResultViewController ()
{
    NSMutableData *onlineJsonData;
    NSURLConnection *connection;
    UIAlertView *connectAlert;
    NSMutableArray *nameArray;
    NSMutableArray *locationArray;
    NSMutableArray *logoArray;
    NSMutableArray *artistLogoArray;
    NSMutableArray *albumArray;
    NSMutableArray *artistArray;
    NSMutableArray *lyricsURLArray;
}
@end

@implementation FFSearchResultViewController
@synthesize keyWord,myTableView;

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
	// Initial UITableView
    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    nameArray = [[NSMutableArray alloc]init];
    locationArray = [[NSMutableArray alloc]init];
    logoArray=[[NSMutableArray alloc]init];
    artistLogoArray=[[NSMutableArray alloc]init];
    artistArray=[[NSMutableArray alloc]init];
    albumArray=[[NSMutableArray alloc]init];
    artistArray=[[NSMutableArray alloc]init];
    lyricsURLArray=[[NSMutableArray alloc]init];
    
    //Checking History Exist
    FFAppDelegate *appDelegateForHistory=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSEntityDescription *entityForHistory=[NSEntityDescription entityForName:@"History" inManagedObjectContext:appDelegateForHistory.managedObjectContext];
    NSFetchRequest *fetchRqst = [[NSFetchRequest alloc]init];
    [fetchRqst setEntity:entityForHistory];
    NSMutableArray *keyWordArray=[[appDelegateForHistory.managedObjectContext executeFetchRequest:fetchRqst error:nil]mutableCopy];
    int historyExistFlag=0;
    //    int tempDeleteNumber=0;
    for (NSManagedObject *obj in keyWordArray) {
        //        NSLog(@"%@",[obj valueForKey:@"keyWord"]);
        if ([[obj valueForKey:@"keyWord"] isEqualToString:keyWord]) {
            //delete redundant record
            //            if (tempDeleteNumber==0) {
            //                NSManagedObjectContext *context=appDelegateForHistory.managedObjectContext;
            //                [context deleteObject:obj];
            //                NSError *error;
            //                if(![context save:&error])
            //                {
            //                    NSLog(@"Can't Delete! %@ %@",error,[error localizedDescription]);
            //                }
            //                tempDeleteNumber++;
            //            }
            
            
            NSLog(@"History %@ exist!",keyWord);
            historyExistFlag=1;
        }
    }
    
    if (historyExistFlag!=1) {
        
        //Add to History
        FFAppDelegate *appDelegate=(FFAppDelegate *)[[UIApplication sharedApplication]delegate];
        NSEntityDescription *entity=[NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:appDelegate.managedObjectContext];
        [entity setValue:keyWord forKey:@"keyWord"];
        NSError *error;
        BOOL isSaved = [appDelegate.managedObjectContext save:&error];
        if (isSaved==1) {
            NSLog(@"History saved Status: %d",isSaved);
        }
        
    }
    else historyExistFlag=0;
    
    //Request the connection
    NSString *urlString=@"http://nnlife.cdn.duapp.com/xiami.php?key=";
    NSString *search=[urlString stringByAppendingString:keyWord];
    NSString *searchURL=[search stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@",search);
    
    
    NSURL *url = [NSURL URLWithString:[searchURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    connection=[NSURLConnection connectionWithRequest:request delegate:self];
    if (connection) {
        if (onlineJsonData==NULL) {
            onlineJsonData = [[NSMutableData alloc]init];
        }
        else [self.myTableView reloadData];
    }
    connectAlert=[[UIAlertView alloc]initWithTitle:nil message:@"connecting" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [connectAlert show];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [connectAlert dismissWithClickedButtonIndex:-1 animated:YES];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error: No connection!" message:@"Please check your connection and try again" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
    NSLog(@"Error:(Search)Failed with connection error.");
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *nameString;
    NSString *locationString;
    NSString *logoString;
    NSString *albumString;
    NSString *artistString;
    NSString *artistLogoString;
    NSString *lyricsURLString;
    
    [connectAlert dismissWithClickedButtonIndex:-1 animated:YES];
    NSDictionary *allDataDictionary=[NSJSONSerialization JSONObjectWithData:onlineJsonData options:0 error:nil];
    NSDictionary *songDictionary=[allDataDictionary objectForKey:@"song"];
    
    if (allDataDictionary==NULL) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"No result found!" message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        if ((NSNull*)songDictionary==[NSNull null]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Server not support this song!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            [alert show];
        }
        else{
            nameString=[songDictionary objectForKey:@"song_name"];
            locationString=[songDictionary objectForKey:@"song_location"];
            logoString=[songDictionary objectForKey:@"song_logo"];
            albumString=[songDictionary objectForKey:@"album_name"];
            artistString=[songDictionary objectForKey:@"artist_name"];
            artistLogoString=[songDictionary objectForKey:@"artist_logo"];
            lyricsURLString=[songDictionary objectForKey:@"song_lrc"];
        }
        
    }
    
    NSLog(@"%@ - %@ - %@ - %@ - %@",nameString,locationString,logoString,albumString,artistString);
    if (allDataDictionary!=NULL&&(NSNull*)songDictionary!=[NSNull null]) {
        NSString *checkedNameString=[nameString stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        [nameArray addObject:checkedNameString];
        [locationArray addObject:locationString];
        [logoArray addObject:logoString];
        NSString *checkedAlbumString=[albumString stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        [albumArray addObject:checkedAlbumString];
        NSString *checkedArtistString=[artistString stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"];
        [artistArray addObject:checkedArtistString];
        [artistLogoArray addObject:artistLogoString];
        [lyricsURLArray addObject:lyricsURLString];
        /*
         UIAlertView *reminderAlert=[[UIAlertView alloc]initWithTitle:@"Reminder:" message:@"This song is probably too large. Please make sure you are in good network and wait for a while" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
         [reminderAlert show];
         */
    }
    
    
    [[self myTableView]reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nameArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"SCell";
    FFSearchCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        cell=[[FFSearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSData *imageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:[logoArray objectAtIndex:indexPath.row]]];
    cell.myCover.image=[[UIImage alloc]initWithData:imageData];
    
    
    if (connection) {
        cell.nameLabel.text=[nameArray objectAtIndex:indexPath.row];
        cell.artistLabel.text=[artistArray objectAtIndex:indexPath.row];
        cell.albumLabel.text=[albumArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SearchResultSegue"]) {
        FFSearchResultDetailViewController *vc=[segue destinationViewController];
        NSIndexPath *index=[myTableView indexPathForSelectedRow];
        vc.logoURL=[logoArray objectAtIndex:index.row];
        vc.nameString=[nameArray objectAtIndex:index.row];
        vc.albumString=[albumArray objectAtIndex:index.row];
        vc.artisString=[artistArray objectAtIndex:index.row];
        vc.songURL=[locationArray objectAtIndex:index.row];
        vc.artistImageURL=[artistLogoArray objectAtIndex:index.row];
        vc.lyricsURL=[lyricsURLArray objectAtIndex:index.row];
    }
    
    
}

@end
