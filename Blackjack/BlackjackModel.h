//
//  NYUBlackjackModel.h
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Hand.h"

typedef enum {
    Player,
    Dealer,
    Draw
} Winner;

@interface BlackjackModel : NSObject
{
    Hand *dealerHand;
    Hand *playerHand;
    Deck *deck;
}
@property Hand *dealerHand;
@property Hand *playerHand;
@property Deck *deck;
@property int totalPlays;
@property int playerWins;
@property int dealerWins;
@property int draw;

-(void) setup;

+(BlackjackModel *)getBlackjackModel;
-(void)playerHandDraws;
-(void)dealerHandDraws;

-(void) playerStands;
-(void) resetGame;
-(int) totalGame;
-(int) getTotalPlayer;
-(int) getTotalDealer;
-(int) getTotalDraw;
-(int) gameResult;

@end
