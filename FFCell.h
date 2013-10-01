//
//  FFCell.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-9-30.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *albumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (strong, nonatomic) IBOutlet UIImageView *myCover;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@end
