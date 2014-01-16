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
    __weak IBOutlet UILabel *turnScore;
    __weak IBOutlet UILabel *turnLabel;
    Player *player1;
    Player *player2;
    __weak IBOutlet UIButton *calculateButton;
    __weak IBOutlet UIButton *rollButton;
    __weak IBOutlet UIButton *endButton;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    dice = [NSMutableArray new];
    [self loadDiceArrayWithDice];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"felt_table.jpg"]];
    player1 = [Player new];
    player2 = [Player new];
    
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
        if ([dieLabel isKindOfClass:[DieLabel class]] && dieLabel.backgroundColor == [UIColor whiteColor])
        {
            [dieLabel roll];
        } else {
            dieLabel.backgroundColor = [UIColor redColor];
        }
    }
    [self loadDiceArrayWithDice];
    rollButton.alpha = 0;
    calculateButton.alpha = 1;
    endButton.alpha = 0;
}
- (IBAction)onEndTurnButtonPressed:(id)sender
{
    if ([turnLabel.text isEqualToString:@"Player 1's Turn"]) {
        
        player1.totalScore =  player1.totalScore + bankedScore.text.intValue;
        playerOneScore.text = [NSString stringWithFormat:@"%i" ,player1.totalScore];
        if (player1.totalScore>=1000) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Winner!" message:@"Player 1 is the winner!" delegate:nil cancelButtonTitle:@"New Game" otherButtonTitles: nil];
            [alert show];
            [self newGame];
        }
        turnLabel.text = @"Player 2's Turn";
    } else {
        
        player2.totalScore = player2.totalScore + bankedScore.text.intValue;
        playerTwoScore.text = [NSString stringWithFormat:@"%i" ,player2.totalScore];
        if (player2.totalScore>=1000) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Winner!" message:@"Player 2 is the winner!" delegate:nil cancelButtonTitle:@"New Game" otherButtonTitles: nil];
            [alert show];
            [self newGame];
        }
        turnLabel.text = @"Player 1's Turn";
    }
    bankedScore.text = @"0";
    [self resetAllDice];
    endButton.alpha = 0;
    rollButton.alpha = 1;
    
}
- (IBAction)onCalculateButtonPressed:(id)sender
{
    if([self calculateRollScore]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Farkle!" message:@"Oops! You lost your turn." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        if ([turnLabel.text isEqualToString:@"Player 1's Turn"])
        {
            turnLabel.text = @"Player 2's Turn";
        } else {
            turnLabel.text = @"Player 1's Turn";
        }
        bankedScore.text = @"0";
        [self resetAllDice];
        endButton.alpha = 0;
        calculateButton.alpha = 0;
        rollButton.alpha = 1;
    } else {
        bankedScore.text = [NSString stringWithFormat:@"%i",bankedScore.text.intValue +[self calculateRollScore]];
        calculateButton.alpha = 0;
        endButton.alpha = 1;
        rollButton.alpha = 1;
        for (DieLabel *dieLabel in dice)
        {
            if ([dieLabel isKindOfClass:[DieLabel class]] && dieLabel.backgroundColor != [UIColor whiteColor])
            {
                dieLabel.backgroundColor = [UIColor redColor];
            }
        }
    }
}

-(int)calculateRollScore
{
    NSMutableString *diceString = [NSMutableString new];
    int rollScore = 0;
    for (DieLabel *dieLabel in dice)
    {
        if (dieLabel.backgroundColor == [UIColor purpleColor])
        {
            [diceString appendString:dieLabel.text];
        }
    }
    NSLog(@"%@",diceString);
    for (int i = 1; i < 7; i++) {
        
        NSString *intString = [NSString stringWithFormat:@"%i",i];
        int count = [self numberOfOccurances:intString inString:diceString];
        if (count >= 3)
        {
            switch (i)
            {
                case 1:
                    rollScore = rollScore + 1000 + (count-3)*100;
                    break;
                case 2:
                    rollScore = rollScore + 200;
                    break;
                case 3:
                    rollScore = rollScore + 300;
                    break;
                case 4:
                    rollScore = rollScore + 400;
                    break;
                case 5:
                    rollScore = rollScore + 500 + (count-3)*100;
                    break;
                case 6:
                    rollScore = rollScore + 600;
                    break;
                default:
                    break;
            }
        }
        if (count < 3)
        {
            switch (i) {
                case 1:
                    rollScore = rollScore + count*100;
                    break;
                case 5:
                    rollScore = rollScore + count*50;
                    break;
                    
                default:
                    break;
            }
        }
    }
    NSLog(@"%i", rollScore);
    return rollScore;
}


//Checks the number of occurances of a certain character in a string (from Josef)
-(int)numberOfOccurances:(NSString*) searchCharacter inString:(NSString*)string
{
    int count = 0;
    NSString *extract;
    NSRange rangeToExtract;
    if (string == nil)
        return 0;
    
    for (int i=0; i< (string.length - searchCharacter.length + 1); i++)
        {
            rangeToExtract = NSMakeRange(i, searchCharacter.length);
            extract = [string substringWithRange:rangeToExtract];
            if ([extract isEqualToString:searchCharacter])
                count++;
            }
    return count;
}

-(void)resetAllDice
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
            dieLabel.text = @"";
        }
    }
}

-(void)loadDiceArrayWithDice
{
    [dice removeAllObjects];
    dice = [NSMutableArray new];
	for (DieLabel *dieLabel in self.view.subviews)
    {
        if ([dieLabel isKindOfClass:[DieLabel class]] && dieLabel.backgroundColor != [UIColor redColor])
        {
            [dice addObject:dieLabel];
            dieLabel.delegate = self;
            dieLabel.backgroundColor = [UIColor whiteColor];
        }
    }
}

-(void)didChooseDie:(DieLabel*)dieLabel
{
    if (rollButton.alpha == 0) {
        if (dieLabel.backgroundColor == [UIColor whiteColor])
        {
            dieLabel.backgroundColor = [UIColor purpleColor];
        } else if (dieLabel.backgroundColor == [UIColor purpleColor])
        {
            dieLabel.backgroundColor = [UIColor whiteColor];
        }
    }
}

-(void)newGame
{
    [self resetAllDice];
    player1.totalScore = 0;
    player2.totalScore = 0;
    bankedScore.text = @"0";
    turnScore.text = @"0";
    playerOneScore.text = @"0";
    playerTwoScore.text = @"0";
    turnLabel.text = @"Player 1's Turn";
}


@end
