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
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
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
    
    self.viewTitleName = @"Wine";
//    self.title = NSLocalizedString(self.viewTitleName, @"wine");
    
    // QUESTION: why do this vs just self.title above
    // right place to set these here?
    [self.navigationItem setTitle:self.viewTitleName]; // prop only exists bc we are using a nav controller in appDelegate?
    // QUESTION: is this right -- to create a selector, etc for a back button?
    UIBarButtonItem *leftBackButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed:)];
    self.navigationItem.leftBarButtonItem = leftBackButton;

    self.drinkVesselNameSingular = @"glass";
    self.drinkVesselNamePlural = @"glasses";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // tell the text field that self, this instance of ViewController, should be treated as the text field's delegate
    self.beerPercentTextField.delegate = self; // QUESTION: does every UIControl have a delegate property?
    
    // set placeholder text
    self.beerPercentTextField.placeholder = NSLocalizedString(@"% Alcohol Content Per Beer", @"Beer percent placeholder text");

    // config style of subviews
    for (UIView *subview in self.view.subviews) {
        if([subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UITextField class]]) {
            //            (UILabel *)subview.font = [UIFont fontWithName:@"Didot" size:16];
//            UIFont* font = [UIFont fontWithName:@"Didot" size:16];
//            UILabel* label = (UILabel*) subview;
//            label.font = font;
//            [label setFont:font];
            
//            ((UILabel*) subview).font = font;
            
            [(UILabel *)subview setFont:[UIFont fontWithName:@"Didot" size:16]]; // QUESTION why need to use explicit setter vs dot notation?
        }
    }
    
    self.beerPercentTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    self.calculateButton.backgroundColor = self.view.tintColor;
    self.calculateButton.layer.borderWidth = 2.0;
    
    self.calculateButton.layer.borderColor = self.view.tintColor.CGColor;
    self.calculateButton.titleLabel.textColor = [UIColor whiteColor];
    self.calculateButton.titleLabel.font = [UIFont fontWithName:@"Didot-Bold" size:20];
    [self.calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.calculateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    self.calculateButton.layer.cornerRadius = 5;

    // tells self.beerCountSlider that when its value changes, it should call [self -sliderValueDidChange:]
    // this is equivalent to connecting the IBAction on our previous checkpoint

    [self.beerPercentTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.beerCountSlider addTarget:self action:@selector(sliderValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    // set the min and max number of beers
    self.beerCountSlider.minimumValue = 1;
    self.beerCountSlider.maximumValue = 10;
    
    // tells self.calculateButton that when a finger is lifted from the button while still in its bounds, to call [self -buttonPressed:]
    [self.calculateButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    // set title of button
    [self.calculateButton setTitle:NSLocalizedString(@"Calculate", @"Calculate command") forState:UIControlStateNormal];
    
    // tells the tap gesture recognizer to call [self -tapGestureDidFire:] when it detects a tap
    [self.hideKeyboardTapGestureRecognizer addTarget:self action:@selector(tapGestureDidFire:)];
    
    // gets rid of the max num of lines on a label
    self.resultLabel.numberOfLines = 0;
    
    self.beerCountLabel.numberOfLines = 0;
    
    // bc we are implementing auto layout programmatically
    for (UIView *subview in self.view.subviews) {
        subview.translatesAutoresizingMaskIntoConstraints = NO;
    }
}

// QUESTION: need to add
- (void) backPressed:(UIButton *) sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat padding = 30;
//    CGFloat itemWidth = viewWidth - padding - padding;
//    CGFloat itemHeight = 44;

//    self.beerPercentTextField.frame = CGRectMake(padding, padding, itemWidth, itemHeight);
    
//    CGFloat bottomOfTextField = CGRectGetMaxY(self.beerPercentTextField.frame);
//    self.beerCountSlider.frame = CGRectMake(padding, bottomOfTextField + padding, itemWidth, itemHeight);
    
//    CGFloat bottomOfSlider = CGRectGetMaxY(self.beerCountSlider.frame);
//    self.resultLabel.frame = CGRectMake(padding, bottomOfSlider + padding, itemWidth, itemHeight * 3);
    
//    CGFloat bottomOfLabel = CGRectGetMaxY(self.resultLabel.frame);
//    self.calculateButton.frame = CGRectMake(padding, bottomOfLabel + padding, itemWidth, itemHeight);
    
    // QUESTION: why doesn't this work?
    self.calculateButton.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // create dictionary that associates keys to any view we are defining
    NSDictionary *viewsDictionary = @{@"label": self.beerCountLabel, @"textField": self.beerPercentTextField, @"slider":self.beerCountSlider, @"result":self.resultLabel, @"button":self.calculateButton};
                                      
    // create constraints for subviews
    NSDictionary *metrics = @{@"paddingBelowNavBar": @64, @"padding": @30, @"buttonHeight": @40, @"textFieldHeight": @40};
    
    NSArray *beerCountLabelConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-paddingBelowNavBar-[label]"
                                                                                        options:0
                                                                                        metrics:metrics
                                                                                          views:viewsDictionary];
    
    NSArray *beerCountLabelConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[label]"
                                                                                        options:0
                                                                                        metrics:metrics
                                                                                          views:viewsDictionary];
    
    [self.view addConstraints:beerCountLabelConstraint_V];
    [self.view addConstraints:beerCountLabelConstraint_H];
    
    
    NSArray *beerPercentTextFieldConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-padding-[textField(textFieldHeight)]"
                                                                                            options:0
                                                                                            metrics:metrics
                                                                                              views:viewsDictionary];
    
    NSArray *beerPercentTextFieldConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[textField]-padding-|"
                                                                                            options:0
                                                                                            metrics:metrics
                                                                                              views:viewsDictionary];
    
    [self.view addConstraints:beerPercentTextFieldConstraint_V];
    [self.view addConstraints:beerPercentTextFieldConstraint_H];
    
    NSArray *beerCountSliderConstaint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[textField]-padding-[slider]"
                                                                                            options:0
                                                                                            metrics:metrics
                                                                                              views:viewsDictionary];
    
    NSArray *beerCountSliderConstaint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[slider]-padding-|"
                                                                                            options:0
                                                                                            metrics:metrics
                                                                                              views:viewsDictionary];
    
    [self.view addConstraints:beerCountSliderConstaint_V];
    [self.view addConstraints:beerCountSliderConstaint_H];
    
    NSArray *resultLabelConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[slider]-padding-[result]"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewsDictionary];
    
    NSArray *resultLabelConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[result]-padding-|"
                                                                                       options:0
                                                                                       metrics:metrics
                                                                                         views:viewsDictionary];
    
    [self.view addConstraints:resultLabelConstraint_V];
    [self.view addConstraints:resultLabelConstraint_H];
    
    
    NSArray *calculateButtonConstraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[result]-padding-[button(buttonHeight)]"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:viewsDictionary];
    
    NSArray *calculateButtonConstraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[button]-padding-|"
                                                                                   options:0
                                                                                   metrics:metrics
                                                                                     views:viewsDictionary];
    
    [self.view addConstraints:calculateButtonConstraint_V];
    [self.view addConstraints:calculateButtonConstraint_H];
    
//    for (UIView *subview in self.view.subviews) {
//        if([subview isKindOfClass:[UILabel class]]) {
//            (UILabel *)subview.font = [UIFont fontWithName:@"Didot" size:16];
//            [(UILabel *)subview setFont:[UIFont fontWithName:@"Didot" size:16]];
//        }
//        subview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    }
    
//    self.beerCountSlider.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
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

    NSString *formattedBeerCountStr = [NSString stringWithFormat:@"%.1f", self.beerCount];
    
    self.beerCountLabel.text = NSLocalizedString([formattedBeerCountStr stringByAppendingString: @" beers"], @"beer count");
    
    [self updateTitle];
    
    [self buttonPressed: self.calculateButton];

    [self.beerPercentTextField resignFirstResponder];
}

- (void)updateTitle {
    self.title = [NSString stringWithFormat:@"%@ (%.0f %@)", self.viewTitleName, self.conversionDrinkCount, self.conversionDrinkText];
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
        wineText = NSLocalizedString(self.drinkVesselNameSingular, @"singular glass of wine");
    } else {
        wineText = NSLocalizedString(self.drinkVesselNamePlural, @"plural of glasses");
    }
    
    // generate result text
    NSString *resultText = [NSString stringWithFormat:NSLocalizedString(@"%.1f %@ contains as much alcohol as %.1lf %@ of wine.", nil), numberOfBeers, beerText, numberOfWineGlassesForEquivalentAlcoholAmount, wineText];
    
    self.resultLabel.text = resultText;
    
    // update title
    self.conversionDrinkCount = numberOfWineGlassesForEquivalentAlcoholAmount;
    self.conversionDrinkText = wineText;
    [self updateTitle];
}

- (void)tapGestureDidFire:(UITapGestureRecognizer *)sender {
    [self.beerPercentTextField resignFirstResponder];
}


@end
