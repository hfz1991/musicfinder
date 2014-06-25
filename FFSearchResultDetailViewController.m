//
//  FFSearchResultDetailViewController.m
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-18.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import "FFSearchResultDetailViewController.h"

@interface FFSearchResultDetailViewController ()
{
    AVAudioPlayer *avPlayer;
    NSData *songData;
    int repeatFlag;
    int playPauseFlag;
    UIAlertView *connectAlert;
    int finishLoadFlag;
    int viewDisappaerFlag;
    int numOfLoadingData;
}
@end

@implementation FFSearchResultDetailViewController
@synthesize logoImage,logoURL,nameLabel,nameString,albumLabel,albumString,artistLabel,artisString,songURL,artistImage,artistImageURL,lyricsURL,myToolbar,playButtonItem,currentTime,durationTime;

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
    nameLabel.text=nameString;
    albumLabel.text=albumString;
    artistLabel.text=artisString;
    repeatFlag=0;
    playPauseFlag=0;
    finishLoadFlag=0;
    viewDisappaerFlag=0;
    numOfLoadingData=0;
    
    
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
        [dict setObject:nameString forKey:MPMediaItemPropertyTitle];
        [dict setObject:artisString forKey:MPMediaItemPropertyArtist];
        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"blue.png"]]  forKey:MPMediaItemPropertyArtwork];
        
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
    }
    
    
    connectAlert=[[UIAlertView alloc]initWithTitle:nil message:@"Connecting to the server of song..." delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    NSData *logoImageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:logoURL]];
    NSData *artistImageData=[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:artistImageURL]];
    logoImage.image=[[UIImage alloc]initWithData:logoImageData];
    artistImage.image=[[UIImage alloc]initWithData:artistImageData];
    
    NSLog(@"URL:%@",songURL);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (songData==NULL&&numOfLoadingData<4) {
            songData = [NSData dataWithContentsOfURL:[NSURL URLWithString:songURL]];
            NSLog(@"Data:%@",songData);
            NSLog(@"Number of Loading:%d",numOfLoadingData);
            numOfLoadingData++;
            
        }
        if (songData==NULL) {
            [connectAlert dismissWithClickedButtonIndex:-1 animated:YES];
            UIAlertView *dataAlert=[[UIAlertView alloc]initWithTitle:@"Failed with data of song:" message:@"Internet is slow!" delegate:nil cancelButtonTitle:@"Back to result and connect again" otherButtonTitles:nil];
            [dataAlert show];
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSError *error;
            avPlayer = [[AVAudioPlayer alloc]initWithData:songData error:&error];
            
            if (songData !=NULL)
            {
                [connectAlert dismissWithClickedButtonIndex:-1 animated:YES];
                finishLoadFlag=1;
            }
            
        });
        
        
        [avPlayer prepareToPlay];
        
        if (viewDisappaerFlag==0) {
            [avPlayer play];
        }
        
        //For the previous changing of REPEAT button working
        if(repeatFlag==1)
        {
            [avPlayer setNumberOfLoops:-1];
            NSLog(@"Play mode changed(by viewdidload checking):Repeat.");
        }
        else{
            [avPlayer setNumberOfLoops:0];
            NSLog(@"Play mode changed(by viewdidload checking):Normal.");
        }
        
        //Set Session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        if([session setCategory:AVAudioSessionCategoryPlayback error:nil])
        {
            if ([session setActive:YES error:nil]) {
                NSLog(@"Prepared for background playing!");
            }
        }
    });
    
    avPlayer.volume=self.volumeOutlet.value;
    [NSTimer scheduledTimerWithTimeInterval:0.12 target:self selector:@selector(updatemyProgress) userInfo:nil repeats:YES];
    
    
    /**
     * Sometimes the API is very slow due to high demand of usage.
     * I tested it on my home network. It's working fantastic
     * But I tried on RMIT's network, sometimes it's weird and hard to pull the song data
     */
    
    
    //    //AV Player
    //    NSData *songData = [NSData dataWithContentsOfURL:[NSURL URLWithString:songURL]];
    //    NSError *error;
    //
    //    avPlayer = [[AVAudioPlayer alloc]initWithData:songData error:&error];
    //    avPlayer.numberOfLoops=0;
    //    avPlayer.volume=self.volumeOutlet.value;
    //    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatemyProgress) userInfo:nil repeats:YES];
    //
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [avPlayer stop];
    viewDisappaerFlag=1;
}

-(void)updatemyProgress
{
    float progress = [avPlayer currentTime]/[avPlayer duration];
    self.myProgressView.progress=progress;
    NSString *currentTimeString=[NSString stringWithFormat:@"%.2f",[avPlayer currentTime]];
    currentTime.text=currentTimeString;
    NSString *durationTimeString=[NSString stringWithFormat:@"%.2f",[avPlayer duration]];
    durationTime.text=durationTimeString;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playButton:(id)sender {
    
    //    UIBarButtonItem *pause;
    //    pause=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:nil];
    //    pause.style=UIBarButtonItemStyleBordered;
    //    sender=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:nil];
    //    [sender setBackButtonBackgroundImage:[UIImage imageNamed:@"65-note.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [sender setBackBarButtonItem:pause];
    //    sender=pause;
    //    self.navigationItem.rightBarButtonItem=pause;
    
    
    if (finishLoadFlag==0) {
        [connectAlert show];
    }
    if (avPlayer.playing) {
        [avPlayer pause];
        
    }
    else{
        [avPlayer play];
    }
    
}



- (IBAction)stopButton:(id)sender {
    [avPlayer stop];
    [avPlayer setCurrentTime:0];
}

- (IBAction)volumeAction:(id)sender {
    UISlider *mySlider = sender;
    [avPlayer setVolume:mySlider.value];
}

- (IBAction)repeatButton:(id)sender {
    if(repeatFlag==0)
    {
        [sender setTitle:@"Repeat" forState:UIControlStateNormal];
        [avPlayer setNumberOfLoops:-1];
        repeatFlag=1;
        NSLog(@"Play mode changed:Repeat.");
    }
    else{
        [sender setTitle:@"Normal" forState:UIControlStateNormal];
        [avPlayer setNumberOfLoops:0];
        repeatFlag=0;
        NSLog(@"Play mode changed:Normal.");
    }
}

@end
