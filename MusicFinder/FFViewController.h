//
//  FFViewController.h
//  jsonTute
//
//  Created by Fangzhou He on 13-8-30.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

- (IBAction)getAuButton:(id)sender;



@end
