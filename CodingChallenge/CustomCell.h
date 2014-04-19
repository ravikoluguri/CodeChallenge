//
//  CustomCell.h
//  CodingChallenge
//
//  Created by Ravi Tega Koluguri on 3/28/14.
//  Copyright (c) 2014 Ravi Tega Koluguri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *description;

@property (weak, nonatomic) IBOutlet UIImageView *customImageView;

@property (weak, nonatomic) IBOutlet UILabel *text;

@end
