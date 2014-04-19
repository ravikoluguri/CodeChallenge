//
//  CustomCell.m
//  CodingChallenge
//
//  Created by Ravi Tega Koluguri on 3/28/14.
//  Copyright (c) 2014 Ravi Tega Koluguri. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize  description;
@synthesize text;
@synthesize customImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
