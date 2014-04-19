//
//  ModelObject.h
//  CodingChallenge
//
//  Created by Ravi Tega Koluguri on 4/17/14.
//  Copyright (c) 2014 Ravi Tega Koluguri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelObject : NSObject

@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* detailText;
@property (nonatomic, retain) NSString* url;
@property (nonatomic, strong) UIImage *castImage;


@end
