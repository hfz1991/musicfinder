//
//  FFSearchViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-10-2.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFSearchViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
- (IBAction)searchButton:(id)sender;

@end
