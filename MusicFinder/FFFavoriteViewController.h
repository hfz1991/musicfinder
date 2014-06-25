//
//  FFFavoriteViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-2.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFFavoriteViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)editButton:(id)sender;

@end
