//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "ColorChip.h"
#import "GameMockupView.h"
#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) CGFloat hue;
@property (nonatomic) ColorChip *hintColorChip;
@property (nonatomic) ColorChip *extraLightColorChip;
@property (nonatomic) ColorChip *lightColorChip;
@property (nonatomic) ColorChip *normalColorChip;
@property (nonatomic) ColorChip *brightColorChip;
@property (nonatomic) ColorChip *accentColorChip;

@property (nonatomic) IBOutlet UILabel *hintColorLabel;
@property (nonatomic) IBOutlet UILabel *extraLightColorLabel;
@property (nonatomic) IBOutlet UILabel *lightColorLabel;
@property (nonatomic) IBOutlet UILabel *normalColorLabel;
@property (nonatomic) IBOutlet UILabel *brightColorLabel;
@property (nonatomic) IBOutlet UILabel *accentColorLabel;

@property (nonatomic) IBOutlet UIView *hintColorView;
@property (nonatomic) IBOutlet UIView *extraLightColorView;
@property (nonatomic) IBOutlet UIView *lightColorView;
@property (nonatomic) IBOutlet UIView *normalColorView;
@property (nonatomic) IBOutlet UIView *brightColorView;
@property (nonatomic) IBOutlet UIView *accentColorView;

@property (nonatomic) GameMockupView *gameMockupView;

@property (nonatomic) IBOutlet UISlider *hueSlider;
@property (nonatomic) IBOutlet UITextField *hueValueField;

- (IBAction)hueChanged:(UISlider *)sender;
- (IBAction)wordTrayActiveChanged:(UISwitch *)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat dl = -0.0;
    
    self.hintColorChip = [[ColorChip alloc] initWithName:@"Hint" grayValue:0.98 saturation:0.7 lightness:0.45 + dl];
    self.extraLightColorChip = [[ColorChip alloc] initWithName:@"Extra Light" grayValue:0.95 saturation:0.6 lightness:0.45];
    self.lightColorChip = [[ColorChip alloc] initWithName:@"Light" grayValue:0.75 saturation:0.5 lightness:0.1 + dl];
    self.normalColorChip = [[ColorChip alloc] initWithName:@"Normal" grayValue:0.3 saturation:0.55 lightness:0.0 + dl];
    self.brightColorChip = [[ColorChip alloc] initWithName:@"Bright" grayValue:0.4 saturation:0.65 lightness:0.0 + dl];
    self.accentColorChip = [[ColorChip alloc] initWithName:@"Accent" grayValue:0.5 saturation:0.95 lightness:0.0 + dl];

    self.gameMockupView = [[GameMockupView alloc] initWithFrame:CGRectMake(0, 0, 812, 375)];
    self.gameMockupView.layer.borderWidth = 1;
    [self.view addSubview:self.self.gameMockupView];
    
    self.hueSlider.value = 220;
    [self hueChanged:self.hueSlider];
    
}

- (void)viewDidLayoutSubviews
{
    CGRect layoutRect1 = CGRectInset(self.view.bounds, 0, 64);
    self.gameMockupView.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutRect1 hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
    [self.gameMockupView layoutWithRule];
}

- (void)updateHue:(CGFloat)hue
{
    self.hintColorChip.hue = hue;
    self.extraLightColorChip.hue = hue;
    self.lightColorChip.hue = hue;
    self.normalColorChip.hue = hue;
    self.brightColorChip.hue = hue;
    self.accentColorChip.hue = hue;
    [self updateColors];
}

- (void)updateColors
{
    self.hintColorLabel.attributedText = [self.hintColorChip attributedDescription];
    self.extraLightColorLabel.attributedText = [self.extraLightColorChip attributedDescription];
    self.lightColorLabel.attributedText = [self.lightColorChip attributedDescription];
    self.normalColorLabel.attributedText = [self.normalColorChip attributedDescription];
    self.brightColorLabel.attributedText = [self.brightColorChip attributedDescription];
    self.accentColorLabel.attributedText = [self.accentColorChip attributedDescription];

    self.hintColorView.backgroundColor = self.hintColorChip.color;
    self.extraLightColorView.backgroundColor = self.extraLightColorChip.color;
    self.lightColorView.backgroundColor = self.lightColorChip.color;
    self.normalColorView.backgroundColor = self.normalColorChip.color;
    self.brightColorView.backgroundColor = self.brightColorChip.color;
    self.accentColorView.backgroundColor = self.accentColorChip.color;

    self.gameMockupView.hintColor = self.hintColorChip.color;
    self.gameMockupView.extraLightColor = self.extraLightColorChip.color;
    self.gameMockupView.lightColor = self.lightColorChip.color;
    self.gameMockupView.normalColor = self.normalColorChip.color;
    self.gameMockupView.brightColor = self.brightColorChip.color;
    self.gameMockupView.accentColor = self.accentColorChip.color;
}

- (IBAction)hueChanged:(UISlider *)sender
{
    float value = roundf(sender.value);
    self.hueValueField.text = [NSString stringWithFormat:@"%.0f", value];
    [self updateHue:value];
}

- (IBAction)wordTrayActiveChanged:(UISwitch *)sender
{
    self.gameMockupView.wordTrayActive = sender.on;
}

@end

