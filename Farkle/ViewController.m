//
//  ViewController.m
//  Farkle
//
//  Created by Kagan Riedel on 1/15/14.
//  Copyright (c) 2014 Kagan Riedel. All rights reserved.
//

#import "ViewController.h"
#import "DieLabel.h"
#import "Player.h"

@interface ViewController () <DieLabelDelegate>
{
    NSMutableArray *dice;
    __weak IBOutlet UILabel *playerOneScore;
    __weak IBOutlet UILabel *playerTwoScore;
    __weak IBOutlet UILabel *bankedScore;
    __weak IBOutlet UILabel *turnLabel;
    Player *player1;
    Player *player2;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dice = [NSMutableArray new];
    [self loadDiceArrayWithAllDice];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"felt_table.jpg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onRollButtonPressed:(id)sender
{
    for (DieLabel *dieLabel in dice)
    {
        if ([dieLabel isKindOfClass:[DieLabel class]])
        {
            [dieLabel roll];
        }
    }
    [self loadDiceArrayWithAllDice];
}
- (IBAction)onEndTurnButtonPressed:(id)sender
{
    if ([turnLabel.text isEqualToString:@"Player 1's Turn"]) {
        turnLabel.text = @"Player 2's Turn";
        playerOneScore.text = [NSString stringWithFormat:@"Player 1 Score: %i" ,player1.totalScore];
    } else {
        turnLabel.text = @"Player 1's Turn";
        playerTwoScore.text = [NSString stringWithFormat:@"Player 2 Score: %i" ,player2.totalScore];
    }
    [self loadDiceArrayWithAllDice];
}

-(void) loadDiceArrayWithAllDice
{
    [dice removeAllObjects];
    dice = [NSMutableArray new];
	for (DieLabel *dieLabel in self.view.subviews)
    {
        if ([dieLabel isKindOfClass:[DieLabel class]])
        {
            [dice addObject:dieLabel];
            dieLabel.delegate = self;
            dieLabel.backgroundColor = [UIColor whiteColor];
        }
    }

}

-(void)didChooseDie:(id)dieLabel
{
    [dice removeObject:dieLabel];
}

@end
