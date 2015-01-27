//
//  WhiskeyViewController.m
//  Alcolator
//
//  Created by Waine Tam on 1/22/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "WhiskeyViewController.h"

@interface WhiskeyViewController ()

@end

@implementation WhiskeyViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewTitleName = @"Whiskey";
    self.title = NSLocalizedString(self.viewTitleName, @"whiskey");
    
    self.drinkVesselNameSingular = @"shot";
    self.drinkVesselNamePlural = @"shots";
}

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"%@ (%.0f %@)", @"Whiskey", self.conversionDrinkCount, self.conversionDrinkText];
    // QUESTION: how to reference current self.title?
}

- (void)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    
    // first calc how much alcohol is in all those beers
    
    CGFloat numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; // assume they are 12oz bottles
    
    CGFloat alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    CGFloat ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    CGFloat ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    // now calc the equiv amount of whisky
    
    CGFloat ouncesInOneWhiskeyGlass = 1.5;
    CGFloat alcoholPercentageOfWhiskey = 0.4;
    
    CGFloat ouncesOfAlcoholPerWhiskeyGlass = ouncesInOneWhiskeyGlass * alcoholPercentageOfWhiskey;
    CGFloat numberOfWhiskeyGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWhiskeyGlass;
    
    // decide whether to use "beer"/"beers" and "shot"/"shots"
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *whiskeyText;
    
    if (numberOfWhiskeyGlassesForEquivalentAlcoholAmount == 1) {
        whiskeyText = NSLocalizedString(self.drinkVesselNameSingular, @"singular shot of whiskey");
    } else {
        whiskeyText = NSLocalizedString(self.drinkVesselNamePlural, @"plural of shot");
    }
    
    // generate result text
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%.1f %@ contains as much alcohol as %.1lf %@ of whiskey.", nil), numberOfBeers, beerText, numberOfWhiskeyGlassesForEquivalentAlcoholAmount, whiskeyText];
    
    self.resultLabel.text = resultText;
    
    // update title
    self.conversionDrinkCount = numberOfWhiskeyGlassesForEquivalentAlcoholAmount;
    self.conversionDrinkText = whiskeyText;
    [self updateTitle];
}


@end
