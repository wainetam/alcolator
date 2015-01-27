//
//  ViewController.h
//  Alcolator
//
//  Created by Waine Tam on 1/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) UITextField *beerPercentTextField;
@property (weak, nonatomic) UISlider *beerCountSlider;
@property (weak, nonatomic) UILabel *resultLabel;
@property (weak, nonatomic) UILabel *beerCountLabel;
@property (assign, nonatomic) CGFloat conversionDrinkCount;
@property (weak, nonatomic) NSString *conversionDrinkText;
@property (weak, nonatomic) NSString *viewTitleName;
@property (weak, nonatomic) NSString *drinkVesselNameSingular;
@property (weak, nonatomic) NSString *drinkVesselNamePlural;

- (void) buttonPressed:(UIButton*) sender;

@end

