//
//  FFUSViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-8-31.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFUSViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myFlag;

- (IBAction)button:(id)sender;

@end
