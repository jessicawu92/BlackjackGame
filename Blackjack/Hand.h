//
//  Hand.h
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Hand : NSObject

@property NSMutableArray *cardsInHand;

@property BOOL handClosed;

-(void) addCard:(Card *)card;
-(NSInteger) getPipValue;
-(NSInteger) countCards;
-(Card *) getCardAtIndex:(NSInteger) index;

@end


