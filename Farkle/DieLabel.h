//
//  DieLabel.h
//  Farkle
//
//  Created by Kagan Riedel on 1/15/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DieLabelDelegate.h"

@interface DieLabel : UILabel
@property BOOL setAside;
@property id<DieLabelDelegate> delegate;

-(void) roll;

@end
