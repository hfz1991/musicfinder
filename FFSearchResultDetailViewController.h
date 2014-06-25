//
//  FFSearchResultDetailViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-18.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface FFSearchResultDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;

@property (strong, nonatomic) NSString *logoURL;
@property (strong, nonatomic) NSString *artistImageURL;
@property (strong, nonatomic) NSString *nameString;
@property (strong, nonatomic) NSString *albumString;
@property (strong, nonatomic) NSString *artisString;
@property (strong, nonatomic) NSString *songURL;
@property (strong, nonatomic) NSString *lyricsURL;

@property (weak, nonatomic) IBOutlet UIProgressView *myProgressView;
@property (weak, nonatomic) IBOutlet UISlider *volumeOutlet;

- (IBAction)playButton:(id)sender;
- (IBAction)stopButton:(id)sender;

- (IBAction)volumeAction:(id)sender;
- (IBAction)repeatButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIToolbar *myToolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *playButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *durationTime;

@end
