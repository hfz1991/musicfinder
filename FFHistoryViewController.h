//
//  FFHistoryViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-20.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (IBAction)deleteButton:(id)sender;

@property (strong,nonatomic) NSMutableArray *keyWordStringArray;
@end
