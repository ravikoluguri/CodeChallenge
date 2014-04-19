//
//  ViewController.h
//  CodingChallenge
//
//  Created by Ravi Tega Koluguri on 3/24/14.
//  Copyright (c) 2014 Ravi Tega Koluguri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchDisplay;

@end
