//
//  DieLabel.m
//  Farkle
//
//  Created by Kagan Riedel on 1/15/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "DieLabel.h"

@implementation DieLabel

-(IBAction)labelWasTapped:(id *)sender
{
    [_delegate didChooseDie:self];
    
    self.backgroundColor = [UIColor purpleColor];
}

-(void) roll
{
    self.text = [NSString stringWithFormat:@"%i", arc4random_uniform(6)+1];
}

@end
