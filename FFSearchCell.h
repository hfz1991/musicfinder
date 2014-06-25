//
//  FFSearchCell.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-18.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *myCover;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;

@end
