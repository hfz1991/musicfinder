//
//  FFAUDetailViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-1.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFAUDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *myCover;
@property (weak, nonatomic) IBOutlet UILabel *albumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) NSString *artistName;


- (IBAction)addFavorite:(id)sender;

@end
