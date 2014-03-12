//
//  ViewController.m
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import "ViewController.h"
#import "BlackjackModel.h"
#import "Card.h"
#import "Hand.h"


@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalPlayed;
@property (strong, nonatomic) IBOutlet UILabel *playerWins;
@property (strong, nonatomic) IBOutlet UILabel *dealerWins;
@property (strong, nonatomic) IBOutlet UILabel *totalDraw;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (strong, nonatomic) IBOutlet UILabel *sliderValue;
@property (strong, nonatomic) IBOutlet UIButton *moreMoneyBtn;
@property int moneyLeft;
@end

@implementation ViewController
@synthesize dealerLabel=_dealerLabel, playerLabel=_playerLabel,allImageViews = _allImageViews,
    statusLabel,totalPlayed,playerWins,dealerWins,totalDraw,moneyLabel,slider,moneyLeft,sliderValue,moreMoneyBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [statusLabel setText:[NSString stringWithFormat:@"Game Status: In Progress"]];
    _allImageViews = [[NSMutableArray alloc] initWithCapacity:5];
    
	// Do any additional setup after loading the view, typically from a nib.
    [[BlackjackModel getBlackjackModel]  addObserver:self forKeyPath:@"dealerHand"
                                             options:NSKeyValueObservingOptionNew context:NULL];
    [[BlackjackModel getBlackjackModel]  addObserver:self forKeyPath:@"playerHand"
                                             options:NSKeyValueObservingOptionNew context:NULL];
    [[BlackjackModel getBlackjackModel]  addObserver:self forKeyPath:@"totalPlays"
                                             options:NSKeyValueObservingOptionNew context:NULL];
    [[BlackjackModel getBlackjackModel] setup];
    
    
    moneyLeft = 100;//start out with 100 dollar
    
    [slider addTarget:self action:@selector(mySliderChanged:) forControlEvents:UIControlEventValueChanged];

}
- (IBAction)addMoney:(id)sender {
    moneyLeft=10;//add 10 dollar
    [moneyLabel setText:[NSString stringWithFormat:@"Money Left: $%d",moneyLeft]];
    [slider setMaximumValue:moneyLeft];
    [slider setValue:1.0];
    int value = ceil(slider.value);
    NSString *labelString = [NSString stringWithFormat:@"%d", value];
    [sliderValue setText:labelString];
    [moreMoneyBtn setEnabled:NO];
    [moreMoneyBtn setTitle:@"" forState:UIControlStateNormal];
    [self ResetGame: nil];
}

-(void) mySliderChanged: (id) sender{
    int value = ceil(slider.value);
    NSString *labelString = [NSString stringWithFormat:@"%d", value];
    [sliderValue setText:labelString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)HitCard:(id)sender{
    [slider setEnabled:NO];
    [[BlackjackModel getBlackjackModel] playerHandDraws];
}

-(void) showHand:(Hand *)hand atYPos:(NSInteger) yPos;
{
    
    for (int i=0; i< [hand countCards] ; i++) {
        Card *card = [hand getCardAtIndex:i];
        
        UIImage  *cardImage = [ UIImage imageNamed:[card filename]];
        
        UIImageView *imageView=[[UIImageView alloc] initWithImage:cardImage];
        CGRect arect = CGRectMake( (i*40)+20, yPos, 60, 81);
        imageView.frame = arect;
        
        [self.view addSubview:imageView];
        [_allImageViews addObject:imageView];
    }
    
}

-(void) showDealerHand:(Hand *)hand;
{
    [self showHand:hand atYPos:80];
    _dealerLabel.text = [NSString stringWithFormat:@"Dealer (%d)",[hand getPipValue]];
}

-(void) showPlayerHand:(Hand *)hand;
{
    [self showHand:hand atYPos:188];
    _playerLabel.text = [NSString stringWithFormat:@"Player (%d)",[hand getPipValue]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:@"dealerHand"])
    {
        [self showDealerHand: (Hand *)[object dealerHand]];
    } else
        if ([keyPath isEqualToString:@"playerHand"])
        {
            [self showPlayerHand: (Hand *)[object playerHand]];
        }
        else if ([keyPath isEqualToString:@"totalPlays"])
        {
            [self endGame];
        }
    
}

- (IBAction)Stand:(id)sender {
    [_HitButton setEnabled:NO];
    [_standButton setEnabled:NO];
    [_resetButton setEnabled:NO];
    [slider setEnabled:NO];
    
    [[BlackjackModel getBlackjackModel] playerStands];
} 

- (IBAction)ResetGame:(id)sender{
    [_HitButton setEnabled:YES];
    [_standButton setEnabled:YES];
    [slider setEnabled:NO];
    
    //
    // reset the model
    for (UIView *view in _allImageViews)
    {
        [view removeFromSuperview];
    }
    
    [_allImageViews removeAllObjects];
    [_dealerLabel setText:@"Dealer"];
    [_playerLabel setText:@"Player"];
    [_resetButton setEnabled:NO];
    
    [[BlackjackModel getBlackjackModel] resetGame];
    [statusLabel setText:[NSString stringWithFormat:@"Game Status: In Progress"]];
}


-(void) endGame{
    [_HitButton setEnabled:NO];
    [_standButton setEnabled:NO];
    [_resetButton setEnabled:YES];
    [slider setEnabled:YES];
    
    
    [totalPlayed setText:[NSString stringWithFormat:@"Total Played: %d",[[BlackjackModel getBlackjackModel] totalPlays]]];
    
    [playerWins setText:[NSString stringWithFormat:@"Total Player Wins: %d",[[BlackjackModel getBlackjackModel] getTotalPlayer]]];
    [dealerWins setText:[NSString stringWithFormat:@"Total Dealer Wins: %d",[[BlackjackModel getBlackjackModel] getTotalDealer]]];
    [totalDraw setText:[NSString stringWithFormat:@"Total Draw: %d",[[BlackjackModel getBlackjackModel] getTotalDraw]]];
    
    int status = [[BlackjackModel getBlackjackModel] gameResult];
    int value = ceil(slider.value);
    switch (status) {
        case 0:
            moneyLeft += value;
            [statusLabel setText:[NSString stringWithFormat:@"Game Status: Player Won"]];
            break;
        case 1:
            moneyLeft -= value;
            [statusLabel setText:[NSString stringWithFormat:@"Game Status: Dealer Won"]];
            break;
        case 2:
            [statusLabel setText:[NSString stringWithFormat:@"Game Status: Draw"]];
            break;
        default:
            [statusLabel setText:[NSString stringWithFormat:@"Game Status: In Progress"]];
            break;
    }
    
    [moneyLabel setText:[NSString stringWithFormat:@"Money Left: $%d",moneyLeft]];
    [slider setMaximumValue:moneyLeft];
    [slider setValue:1.0];
    value = ceil(slider.value);
    NSString *labelString = [NSString stringWithFormat:@"%d", value];
    [sliderValue setText:labelString];
    if( moneyLeft < 1){
        [_HitButton setEnabled:NO];
        [_standButton setEnabled:NO];
        [_resetButton setEnabled:NO];
        [statusLabel setText:[NSString stringWithFormat:@"Game Status: You Lost! No Money!"]];
        [moreMoneyBtn setEnabled:YES];
        [moreMoneyBtn setTitle:@"More Money?" forState:UIControlStateNormal];
    }
    
}





@end
