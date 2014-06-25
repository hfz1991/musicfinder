//
//  FFFavoriteCell.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-16.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFavoriteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myCover;
@property (weak, nonatomic) IBOutlet UILabel *myAlbumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *myArtistLabel;

@end
