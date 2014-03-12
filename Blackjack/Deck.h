//
//  Deck.h
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Card;

@interface Deck : NSObject {
    
    NSMutableArray *cards;
    
}

-(Card * ) drawCard;
-(void) shuffle;
-(NSUInteger) cardCount;

@end
