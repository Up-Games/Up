//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "ColorChip.h"
#import "GameMockupView.h"
#import "ViewController.h"

static NSString *const ColorMapPath = @"/Users/kocienda/Desktop/up-color-map.json";
static NSString *const ColorChipHint = @"Hint";
static NSString *const ColorChipExtraLight = @"ExtraLight";
static NSString *const ColorChipLight = @"Light";
static NSString *const ColorChipNormal = @"Normal";
static NSString *const ColorChipBright = @"Bright";
static NSString *const ColorChipAccent = @"Accent";


@interface ViewController ()

@property (nonatomic) CGFloat hue;
@property (nonatomic) ColorChip *hintColorChip;
@property (nonatomic) ColorChip *extraLightColorChip;
@property (nonatomic) ColorChip *lightColorChip;
@property (nonatomic) ColorChip *normalColorChip;
@property (nonatomic) ColorChip *brightColorChip;
@property (nonatomic) ColorChip *accentColorChip;
@property (nonatomic) ColorChip *selectedChip;
@property (nonatomic) ColorChip *savedChip;

@property (nonatomic) NSMutableDictionary *colorMap;
@property (nonatomic) NSDictionary *defaultColorMap;

@property (nonatomic) GameMockupView *gameMockupView;

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

@property (nonatomic) IBOutlet UIView *selectedIndicatorView;

@property (nonatomic) IBOutlet UISlider *hueSlider;
@property (nonatomic) IBOutlet UITextField *hueValueField;

@property (nonatomic) IBOutlet UILabel *editColorNameLabel;

@property (nonatomic) IBOutlet UILabel *inputGrayLabel;
@property (nonatomic) IBOutlet UISlider *inputGraySlider;
@property (nonatomic) IBOutlet UITextField *inputGrayValueField;

@property (nonatomic) IBOutlet UILabel *saturationLabel;
@property (nonatomic) IBOutlet UISlider *saturationSlider;
@property (nonatomic) IBOutlet UITextField *saturationValueField;

@property (nonatomic) IBOutlet UILabel *lightnessLabel;
@property (nonatomic) IBOutlet UISlider *lightnessSlider;
@property (nonatomic) IBOutlet UITextField *lightnessValueField;

@property (nonatomic) IBOutlet UIView *beforeColorView;
@property (nonatomic) IBOutlet UIView *afterColorView;

@property (nonatomic) IBOutlet UIButton *okButton;
@property (nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)hueChanged:(UISlider *)sender;
- (IBAction)wordTrayActiveChanged:(UISwitch *)sender;

@end

@implementation ViewController

static ViewController *_Instance;

+ (ViewController *)instance
{
    return _Instance;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _Instance = self;
    
    self.defaultColorMap = @{
        ColorChipHint: [[ColorChip alloc] initWithName:ColorChipHint grayValue:0.98 hue:0 saturation:0.7 lightness:0.45],
        ColorChipExtraLight : [[ColorChip alloc] initWithName:ColorChipExtraLight grayValue:0.95 hue:0 saturation:0.6 lightness:0.45],
        ColorChipLight : [[ColorChip alloc] initWithName:ColorChipLight grayValue:0.75 hue:0 saturation:0.5 lightness:0.1],
        ColorChipNormal : [[ColorChip alloc] initWithName:ColorChipNormal grayValue:0.3 hue:0 saturation:0.55 lightness:0.0],
        ColorChipBright : [[ColorChip alloc] initWithName:ColorChipBright grayValue:0.4 hue:0 saturation:0.65 lightness:0.0],
        ColorChipAccent : [[ColorChip alloc] initWithName:ColorChipAccent grayValue:0.5 hue:0 saturation:0.9 lightness:0.0]
    };

    [self loadColorMap];

    self.gameMockupView = [[GameMockupView alloc] initWithFrame:CGRectMake(0, 0, 812, 375)];
    self.gameMockupView.layer.borderWidth = 1;
    [self.view addSubview:self.self.gameMockupView];
    
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.hintColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.extraLightColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.lightColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.normalColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.brightColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.accentColorView addGestureRecognizer:tap];
    }
    
    self.hueSlider.value = 220;
    [self hueChanged:self.hueSlider];
    
    self.selectedIndicatorView.layer.cornerRadius = 8;
    self.selectedIndicatorView.backgroundColor = [UIColor blueColor];
    self.selectedIndicatorView.alpha = 0;
    self.selectedChip = nil;
}

- (void)viewDidLayoutSubviews
{
    CGRect layoutRect1 = CGRectInset(self.view.bounds, 0, 64);
    self.gameMockupView.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutRect1 hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
    [self.gameMockupView layoutWithRule];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    [self cancelEditing];

    CGRect frame = self.selectedIndicatorView.frame;

    if (tap.view == self.hintColorView) {
        self.selectedChip = self.hintColorChip;
    }
    else if (tap.view == self.extraLightColorView) {
        self.selectedChip = self.extraLightColorChip;
    }
    else if (tap.view == self.lightColorView) {
        self.selectedChip = self.lightColorChip;
    }
    else if (tap.view == self.normalColorView) {
        self.selectedChip = self.normalColorChip;
    }
    else if (tap.view == self.brightColorView) {
        self.selectedChip = self.brightColorChip;
    }
    else if (tap.view == self.accentColorView) {
        self.selectedChip = self.accentColorChip;
    }

    frame.origin.y = CGRectGetMidY(tap.view.frame);
    frame.origin.y -= CGRectGetHeight(self.selectedIndicatorView.bounds) * 0.5;
    self.selectedIndicatorView.frame = frame;
    self.selectedIndicatorView.alpha = 1;
}

- (void)setSelectedChip:(ColorChip *)selectedChip
{
    _selectedChip = selectedChip;
    if (selectedChip) {
        self.savedChip = [selectedChip copy];
        self.editColorNameLabel.text = self.selectedChip.name;
        self.editColorNameLabel.enabled = YES;
        self.hueSlider.enabled = NO;
        self.hueValueField.enabled = NO;
        self.inputGrayLabel.enabled = YES;
        self.inputGraySlider.enabled = YES;
        self.inputGrayValueField.enabled = YES;
        self.saturationLabel.enabled = YES;
        self.saturationSlider.enabled = YES;
        self.saturationValueField.enabled = YES;
        self.lightnessLabel.enabled = YES;
        self.lightnessSlider.enabled = YES;
        self.lightnessValueField.enabled = YES;
        self.okButton.enabled = YES;
        self.defaultButton.enabled = YES;
        self.cancelButton.enabled = YES;
        self.beforeColorView.backgroundColor = self.selectedChip.color;
        self.afterColorView.backgroundColor = self.selectedChip.color;
        
        self.inputGraySlider.value = self.selectedChip.grayValue * 100;
        [self inputGraySliderChanged:self.inputGraySlider];

        self.saturationSlider.value = self.selectedChip.saturation * 100;
        [self saturationSliderChanged:self.saturationSlider];

        self.lightnessSlider.value = self.selectedChip.lightness * 100;
        [self lightnessSliderChanged:self.lightnessSlider];
    }
    else {
        self.savedChip = nil;
        self.editColorNameLabel.text = @"None";
        self.editColorNameLabel.enabled = NO;
        self.hueSlider.enabled = YES;
        self.hueValueField.enabled = YES;
        self.inputGrayLabel.enabled = NO;
        self.inputGraySlider.enabled = NO;
        self.inputGrayValueField.enabled = NO;
        self.saturationLabel.enabled = NO;
        self.saturationSlider.enabled = NO;
        self.saturationValueField.enabled = NO;
        self.lightnessLabel.enabled = NO;
        self.lightnessSlider.enabled = NO;
        self.lightnessValueField.enabled = NO;
        self.okButton.enabled = NO;
        self.defaultButton.enabled = NO;
        self.cancelButton.enabled = NO;
        self.beforeColorView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        self.afterColorView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    }
}

- (void)loadColorMap
{
    NSData *data = [NSData dataWithContentsOfFile:ColorMapPath];
    if (!data) {
        [self setDefaultColorMap];
        return;
    }
    NSError *error = nil;
    self.colorMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if (error) {
        [self setDefaultColorMap];
        return;
    }
}

- (void)saveColorMap
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.colorMap options:NSJSONWritingPrettyPrinted|NSJSONWritingSortedKeys error:&error];
    if (error) {
        NSLog(@"*** error saving color map: %@", error.localizedDescription);
        return;
    }
    [data writeToFile:ColorMapPath atomically:YES];
}

- (void)setDefaultColorMap
{
    self.colorMap = [NSMutableDictionary dictionary];
}

- (void)updateHue:(int)hue
{
    NSString *key = [NSString stringWithFormat:@"%d", hue];
    NSDictionary *map = self.colorMap[key];
    if (map) {
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipHint]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipHint] copy];
                chip.hue = hue;
            }
            self.hintColorChip = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipExtraLight]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipExtraLight] copy];
                chip.hue = hue;
            }
            self.extraLightColorChip = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipLight]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipLight] copy];
                chip.hue = hue;
            }
            self.lightColorChip = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipNormal]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipNormal] copy];
                chip.hue = hue;
            }
            self.normalColorChip = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipBright]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipBright] copy];
                chip.hue = hue;
            }
            self.brightColorChip = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipAccent]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipAccent] copy];
                chip.hue = hue;
            }
            self.accentColorChip = chip;
        }
    }
    else {
        self.hintColorChip = [[ColorChip alloc] initWithName:ColorChipHint grayValue:0.98 hue:hue saturation:0.7 lightness:0.45];
        self.extraLightColorChip = [[ColorChip alloc] initWithName:ColorChipExtraLight grayValue:0.95 hue:hue saturation:0.6 lightness:0.45];
        self.lightColorChip = [[ColorChip alloc] initWithName:ColorChipLight grayValue:0.75 hue:hue saturation:0.5 lightness:0.1];
        self.normalColorChip = [[ColorChip alloc] initWithName:ColorChipNormal grayValue:0.3 hue:hue saturation:0.55 lightness:0.0];
        self.brightColorChip = [[ColorChip alloc] initWithName:ColorChipBright grayValue:0.4 hue:hue saturation:0.65 lightness:0.0];
        self.accentColorChip = [[ColorChip alloc] initWithName:ColorChipAccent grayValue:0.5 hue:hue saturation:0.9 lightness:0.0];
    }
    
    [self updateColors];
    
    self.selectedIndicatorView.alpha = 0;
}

- (void)updateColors
{
    if (self.selectedChip) {
        self.afterColorView.backgroundColor = self.selectedChip.color;
    }

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
    int value = roundf(sender.value);
    self.hueValueField.text = [NSString stringWithFormat:@"%d", value];
    [self updateHue:value];
}

- (IBAction)inputGraySliderChanged:(UISlider *)sender
{
    int value = roundf(sender.value);
    self.inputGrayValueField.text = [NSString stringWithFormat:@"%d", value];
    self.selectedChip.grayValue = (float)value / 100;
    [self updateColors];
}

- (IBAction)saturationSliderChanged:(UISlider *)sender
{
    int value = roundf(sender.value);
    self.saturationValueField.text = [NSString stringWithFormat:@"%d", value];
    self.selectedChip.saturation = (float)value / 100;
    [self updateColors];
}

- (IBAction)lightnessSliderChanged:(UISlider *)sender
{
    int value = roundf(sender.value);
    self.lightnessValueField.text = [NSString stringWithFormat:@"%d", value];
    self.selectedChip.lightness = (float)value / 100;
    [self updateColors];
}

- (IBAction)wordTrayActiveChanged:(UISwitch *)sender
{
    self.gameMockupView.wordTrayActive = sender.on;
}

- (IBAction)okButtonPressed:(UIButton *)sender
{
    if (![self.selectedChip isEqual:self.savedChip]) {
        int hue = self.selectedChip.hue;
        NSString *key = [NSString stringWithFormat:@"%d", hue];
        NSMutableDictionary *map = self.colorMap[key];
        if (!map) {
            map = [NSMutableDictionary dictionary];
        }
        map[self.selectedChip.name] = [self.selectedChip dictionary];
        self.colorMap[key] = map;
        [self saveColorMap];
    }
    self.selectedChip = nil;
    self.selectedIndicatorView.alpha = 0;
}

- (IBAction)defaultButtonPressed:(UIButton *)sender
{
    int hue = self.selectedChip.hue;
    NSString *key = [NSString stringWithFormat:@"%d", hue];
    NSMutableDictionary *map = self.colorMap[key];
    if (map) {
        map[self.selectedChip.name] = nil;
        if (map.count == 0) {
            self.colorMap[key] = nil;
        }
        else {
            self.colorMap[key] = map;
        }
        [self saveColorMap];
    }
    ColorChip *defaultChip = self.defaultColorMap[self.selectedChip.name];
    defaultChip.hue = hue;
    [self.selectedChip takeValuesFrom:defaultChip];
    self.selectedChip = nil;
    self.savedChip = nil;
    self.selectedIndicatorView.alpha = 0;
    [self updateColors];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self cancelEditing];
}

- (void)cancelEditing
{
    [self.selectedChip takeValuesFrom:self.savedChip];
    [self updateColors];
    self.selectedChip = nil;
    self.savedChip = nil;
    self.selectedIndicatorView.alpha = 0;
}

@end

