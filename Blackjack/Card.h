//
//  Card.h
//  BlackJack
//
//  Created by Jin on 3/10/14.
//  Copyright (c) 2014 TeamCrud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    Hearts,
    Spades,
    Diamonds,
    Clubs
} Suit;

@interface Card : NSObject

@property NSInteger cardNumber;
@property Suit suit;
@property BOOL cardClosed;

-(id) initWithCardNumber:(NSInteger) aCardNumber suit:(Suit) aSuit;
-(NSInteger) pipValue;
-(NSString *) filename;


@end
