//
//  FFMoreViewController.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-9-1.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface FFMoreViewController : UIViewController
<MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
- (IBAction)contactButton:(id)sender;

@end
