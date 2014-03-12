//
//  NYUBlackjackModel.m
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import "BlackjackModel.h"

@implementation BlackjackModel

@synthesize playerHand = _playerHand;
@synthesize dealerHand = _dealerHand;
@synthesize deck = _deck;
@synthesize totalPlays = _totalPlays;
@synthesize playerWins = _playerWins;
@synthesize dealerWins = _dealerWins;
@synthesize draw = _draw;

static BlackjackModel* blackjackModel = nil;
Winner whoIsWinner;
-(id) init {
    if ((self = [super init])){
        _deck = [[Deck alloc] init];
        _playerHand = [[Hand alloc] init];
        _dealerHand = [[Hand alloc] init];
        _dealerHand.handClosed = YES;
        _totalPlays = 0;
        _playerWins = 0;
        _dealerWins = 0;
        _draw = 0;
    }
    return (self);
}

-(void)setup
{
    //deal cards
    [self playerHandDraws];
    [self dealerHandDraws];
    [self playerHandDraws];
    [self dealerHandDraws];

    
    
    //NSLog ([NSString stringWithFormat:@"Player:%@", _playerHand.description] );
    //NSLog ([NSString stringWithFormat:@"Dealer:%@", _dealerHand.description] );
    
}

-(void)dealerHandDraws
{
    [self willChangeValueForKey:@"dealerHand"];
    [_dealerHand addCard:[_deck drawCard]];
    [self didChangeValueForKey:@"dealerHand"];
}


-(void)playerHandDraws
{
    [self willChangeValueForKey:@"playerHand"];
    [_playerHand addCard:[_deck drawCard]];
    [self didChangeValueForKey:@"playerHand"];
    [self EndGameIfPlayerIsBust];
}

-(void) EndGameIfPlayerIsBust
{
    if (_playerHand.getPipValue > 21)
        [self gameEnds:Dealer];
}

+(BlackjackModel *) getBlackjackModel{
    if (blackjackModel == nil){
        blackjackModel = [[BlackjackModel alloc] init];
    }
    return blackjackModel;
}

-(void)dealerStartsTurn{
    [self willChangeValueForKey:@"dealerHand"];
    [_dealerHand setHandClosed:NO];
    [self didChangeValueForKey:@"dealerHand"];
}

-(void)playerStands
{
    [self dealerStartsTurn];
    [self dealerPlays];
}

-(void) gameEnds:(Winner) winner;
{
    whoIsWinner = winner;
    switch (whoIsWinner) {
        case Player:
            self.playerWins++;
            break;
        case Dealer:
            self.dealerWins++;
            break;
        case Draw:
            self.draw++;
            break;
        default:
            break;
    }
    
    
    self.totalPlays = self.totalPlays+1;
}

-(void)dealerPlays
{
    while (_dealerHand.getPipValue < 17)
    {
        [self dealerHandDraws];
        
    }
    
    if (_dealerHand.getPipValue > 21)
        [self gameEnds:Player ];
    else if (_dealerHand.getPipValue > _playerHand.getPipValue)
        [self gameEnds:Dealer];
    else if (_dealerHand.getPipValue < _playerHand.getPipValue)
        [self gameEnds:Player];
    else
        [self gameEnds:Draw ];
}

-(int) totalGame{
    return self.totalPlays;
}

-(int) getTotalPlayer{
    return self.playerWins;
}

-(int) getTotalDealer{
    return self.dealerWins;
}
-(int) getTotalDraw{
    return self.draw;
}



-(void) resetGame
{
    if([_deck cardCount] < 10){
        //Assuming you need 10 cards minimum per game.
        //If less than 10 card, get new deck of card.
        _deck = nil;
        _deck = [[Deck alloc] init];
    }
    if(self.totalPlays % 5 == 0){//after 5 games shuffle
        //Shuffle the deck
        [_deck shuffle];
    }
    
    _playerHand = nil;
    _dealerHand = nil;
    _playerHand = [[Hand alloc] init];
    _dealerHand = [[Hand alloc] init];
    _dealerHand.handClosed = YES;
    [self setup];
}

-(int) gameResult{
    switch (whoIsWinner) {
        case Player:
            return 0;
            break;
        case Dealer:
            return 1;
            break;
        case Draw:
            return 2;
            break;
        default:
            return 3;
            break;
    }
}
@end
