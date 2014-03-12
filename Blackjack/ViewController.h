//
//  ViewController.h
//  Blackjack
//
//  Created by Jessica Wu on 3/10/14.
//  Copyright (c) 2014 Jessica Wu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    NSMutableArray *allImageViews;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *HitButton;

- (IBAction)HitCard:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *dealerLabel;

@property (weak, nonatomic) IBOutlet UILabel *playerLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *standButton;
- (IBAction)Stand:(id)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *resetButton;
- (IBAction)ResetGame:(id)sender;

@property NSMutableArray *allImageViews;

@end
