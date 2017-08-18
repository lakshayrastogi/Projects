//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Lakshay Rastogi on 7/10/14.
//  Copyright (c) 2014 Lakshay Rastogi. All rights reserved.
//
//  Abstract class

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "HistoryViewController.h"

@interface CardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSelector;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@end

@implementation CardGameViewController

- (NSMutableArray *) flipHistory
{
    if (!_flipHistory)
        _flipHistory = [NSMutableArray array];
    return _flipHistory;
}

- (CardMatchingGame *) game
{
    if (!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck]];
        [self changeModeSelector:self.modeSelector];
    }
    return _game;
}

- (Deck *) createDeck   // abstract method
{
    return nil;
}

- (IBAction)changeSlider:(UISlider *)sender
{
    int sliderValue;
    sliderValue = roundf(self.historySlider.value);
    [self.historySlider setValue:sliderValue animated:NO];
    if ([self.flipHistory count])
    {
        self.flipDescription.alpha = (sliderValue + 1 < [self.flipHistory count] ? 0.6 : 1.0);
        self.flipDescription.text = [self.flipHistory objectAtIndex:sliderValue];
    }
}

- (IBAction)touchDealButton:(UIButton *)sender {
    self.modeSelector.enabled = YES;
    self.flipHistory = nil;
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    self.modeSelector.enabled = NO;
    int chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}

- (IBAction)changeModeSelector:(UISegmentedControl *)sender
{
    self.game.maxMatchingCards = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] integerValue];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.cardButtons)
    {
        int cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardButtonIndex];
        [cardButton setAttributedTitle:[self titleForCard: card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard: card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    if (self.game)
    {
        NSString *description = @"";
        
        if ([self.game.lastChosenCards count])
        {
            NSMutableArray *cardContents = [NSMutableArray array];
            for (Card *card in self.game.lastChosenCards)
                [cardContents addObject:card.contents];
            description = [cardContents componentsJoinedByString:@", "];
        }
        
        if (self.game.lastScore > 0)
            description = [NSString stringWithFormat:@"Matched %@ for %d points.", description, self.game.lastScore];
        else if (self.game.lastScore < 0)
            description = [NSString stringWithFormat:@"%@ don't match! %d point penalty!", description, -self.game.lastScore];
        
        self.flipDescription.text = description;
        self.flipDescription.alpha = 1;
        
        if (![description isEqualToString:@""]
            && ![[self.flipHistory lastObject] isEqualToString:description])
        {
            [self.flipHistory addObject:description];
            [self setSliderRange];
        }
    }
}

- (void) setSliderRange
{
    int maxValue = [self.flipHistory count] - 1;
    self.historySlider.maximumValue = maxValue;
    [self.historySlider setValue:maxValue animated:YES];
}

- (NSAttributedString *) titleForCard: (Card *) card
{
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:card.isChosen ? card.contents : @""];
    return title;
}

- (UIImage *) backgroundImageForCard: (Card *) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show History"])
        if ([segue.destinationViewController isKindOfClass:[HistoryViewController class]])
            [segue.destinationViewController setHistory:self.flipHistory];
}

@end
