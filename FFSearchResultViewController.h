//
//  FFSearchResultViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-18.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSearchResultViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *keyWord;


@end
