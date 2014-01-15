//
//  DieLabelDelegate.h
//  Farkle
//
//  Created by Kagan Riedel on 1/15/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DieLabel;


@protocol DieLabelDelegate

-(void) didChooseDie:(DieLabel *)dieLabel;

@end
