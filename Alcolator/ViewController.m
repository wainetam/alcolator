//
//  ViewController.m
//  Alcolator
//
//  Created by Waine Tam on 1/19/15.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

#import "ViewController.h"

//@interface ViewController ()
@interface ViewController () <UITextFieldDelegate>

//@property (weak, nonatomic) UITextField *beerPercentTextField;
//@property (weak, nonatomic) UISlider *beerCountSlider;
//@property (weak, nonatomic) UILabel *resultLabel;
//@property (weak, nonatomic) UILabel *beerCountLabel;
@property (weak, nonatomic) UIButton *calculateButton;
@property (weak, nonatomic) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@property (assign, nonatomic) CGFloat beerCount;

//@property (weak, nonatomic) IBOutlet UITextField *beerPercentTextField;
//@property (weak, nonatomic) IBOutlet UISlider *beerCountSlider;
//@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
//@property (weak, nonatomic) IBOutlet UILabel *beerCountLabel;
//@property (weak, nonatomic) IBOutlet UIButton *calculateRatios;

@end

@implementation ViewController

- (void)loadView {
    self.view = [UIView new];
    
    // allocate and initialize each of the views and gesture recognizer
    UITextField *textField = [UITextField new];
    UISlider *slider = [UISlider new];
    UILabel *result = [UILabel new];
    UILabel *label = [UILabel new];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    
    // add each view and gesture recognizer as the view's subviews
    [self.view addSubview:textField];
    [self.view addSubview:slider];
    [self.view addSubview:result];
    [self.view addSubview:label];
    [self.view addSubview:button];
    [self.view addGestureRecognizer:tap];
    
    // assign the views and gesture recognizer to properties
    self.beerPercentTextField = textField;
    self.beerCountSlider = slider;
    self.resultLabel = result;
    self.beerCountLabel = label;
    self.calculateButton = button;
    self.hideKeyboardTapGestureRecognizer = tap;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // tell the text field that self, this instance of ViewController, should be treated as the text field's delegate
    self.beerPercentTextField.delegate = self; // QUESTION: does every UIControl have a delegate property?
    
    // set placeholder text
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");
    
    // tells self.beerCountSlider that when its value changes, it should call [self -sliderValueDidChange:]
    // this is equivalent to connecting the IBAction on our previous checkpoint
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // set the min and max number of beers
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    // tells self.calculateButton that when a finger is lifted from the button while still in its bounds, to call [self -buttonPressed:]
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set title of button
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate!", @"Calculate command") forState:UIControlStateNormal];
    
    // tells the tap gesture recognizer to call [self -tapGestureDidFire:] when it detects a tap
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    // gets rid of the max num of lines on a label
    self.resultLabel.numberOfLines = 0;
    
    self.beerCountLabel.numberOfLines = 0;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = 320;
    CGFloat padding = 30;
    CGFloat itemWidth = viewWidth - padding - padding;
    CGFloat itemHeight = 44;

    self.beerPercentTextField.frame = CGRectMake(padding, padding, itemWidth, itemHeight);
    self.beerPercentTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
    self.beerCountSlider.frame = CGRectMake(padding, bottomOfTextField + padding, itemWidth, itemHeight);
    
    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
    self.resultLabel.frame = CGRectMake(padding, bottomOfSlider + padding, itemWidth, itemHeight * 4);
    
    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame); // QUESTION: where is best place to set properties for subviews? more efficient/readable way to do it?
    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
    self.calculateButton.backgroundColor = self.view.tintColor;
    self.calculateButton.layer.borderWidth = 2.0;
//    self.calculateButton.layer.borderColor = [UIColor blueColor].CGColor; // QUESTION: why need to use layer to set corner radius and border attributes?
    self.calculateButton.layer.borderColor = self.view.tintColor.CGColor;
    self.calculateButton.titleLabel.textColor = [UIColor whiteColor];
    [self.calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.calculateButton.layer.cornerRadius = 5;

    
//    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];

    for (UIView* subview in self.view.subviews) {
//        subview.translatesAutoresizingMaskIntoConstraints = YES;
        subview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    
//    self.beerCountSlider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textFieldDidChange:(UITextField *)sender {
    NSString *enteredText = sender.text;
    CGFloat enteredNumber = [enteredText floatValue];
    
    if (enteredNumber == 0) {
        sender.text = nil;
    }
}

- (void)sliderValueDidChange:(UISlider *)sender {
    NSLog(@"Slider value changed to %f", sender.value);
    self.beerCount = sender.value;
    //    NSNumberFormatter *formatter = [NSNumberFormatter new];
    //    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    //    NSNumber *beerCountNum = [formatter self.beerCount];
    NSString *formattedBeerCountStr = [NSString stringWithFormat:@"%.1f",self.beerCount];
    
    self.beerCountLabel.text = NSLocalizedString([formattedBeerCountStr stringByAppendingString: @" beers"], @"beer count");
    
    [self buttonPressed: self.calculateButton];
    
    [self.beerPercentTextField resignFirstResponder];
}

- (void)buttonPressed:(UIButton *)sender {
    [self.beerPercentTextField resignFirstResponder];
    
    // first calc how much alcohol is in all those beers
    
    CGFloat numberOfBeers = self.beerCountSlider.value;
    int ouncesInOneBeerGlass = 12; // assume they are 12oz bottles
    
    CGFloat alcoholPercentageOfBeer = [self.beerPercentTextField.text floatValue] / 100;
    CGFloat ouncesOfAlcoholPerBeer = ouncesInOneBeerGlass * alcoholPercentageOfBeer;
    CGFloat ouncesOfAlcoholTotal = ouncesOfAlcoholPerBeer * numberOfBeers;
    
    // now calc the equiv amount of wine
    
    CGFloat ouncesInOneWineGlass = 5;
    CGFloat alcoholPercentageOfWine = 0.13;
    
    CGFloat ouncesOfAlcoholPerWineGlass = ouncesInOneWineGlass * alcoholPercentageOfWine;
    CGFloat numberOfWineGlassesForEquivalentAlcoholAmount = ouncesOfAlcoholTotal / ouncesOfAlcoholPerWineGlass;
    
    // decide whether to use "beer"/"beers" and "glass"/"glasses"
    
    NSString *beerText;
    
    if (numberOfBeers == 1) {
        beerText = NSLocalizedString(@"beer", @"singular beer");
    } else {
        beerText = NSLocalizedString(@"beers", @"plural of beer");
    }
    
    NSString *wineText;
    
    if (numberOfWineGlassesForEquivalentAlcoholAmount == 1) {
        wineText = NSLocalizedString(@"glass", @"singular glass of wine");
    } else {
        wineText = NSLocalizedString(@"glasses", @"plural of glasses");
    }
    
    // generate result text
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%.1f %@ contains as much alcohol as %.1lf %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    
    self.resultLabel.text = resultText;
}

- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}


@end
