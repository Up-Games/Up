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
static NSString *const ColorChipThin = @"Thin";
static NSString *const ColorChipLight = @"Light";
static NSString *const ColorChipNormal = @"Normal";
static NSString *const ColorChipThick = @"Thick";
static NSString *const ColorChipAccent = @"Accent";


@interface ViewController ()

@property (nonatomic) CGFloat hue;
@property (nonatomic) ColorChip *hintColorChip;
@property (nonatomic) ColorChip *thinColorChip;
@property (nonatomic) ColorChip *lightColorChip;
@property (nonatomic) ColorChip *normalColorChip;
@property (nonatomic) ColorChip *thickColorChip;
@property (nonatomic) ColorChip *accentColorChip;
@property (nonatomic) ColorChip *selectedChip;
@property (nonatomic) ColorChip *savedChip;

@property (nonatomic) NSMutableDictionary *colorMap;
@property (nonatomic) NSDictionary *defaultColorMap;

@property (nonatomic) GameMockupView *gameMockupView;

@property (nonatomic) IBOutlet UILabel *hintColorLabel;
@property (nonatomic) IBOutlet UILabel *thinColorLabel;
@property (nonatomic) IBOutlet UILabel *lightColorLabel;
@property (nonatomic) IBOutlet UILabel *normalColorLabel;
@property (nonatomic) IBOutlet UILabel *thickColorLabel;
@property (nonatomic) IBOutlet UILabel *accentColorLabel;

@property (nonatomic) IBOutlet UIView *hintColorView;
@property (nonatomic) IBOutlet UIView *thinColorView;
@property (nonatomic) IBOutlet UIView *lightColorView;
@property (nonatomic) IBOutlet UIView *normalColorView;
@property (nonatomic) IBOutlet UIView *thickColorView;
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

@property (nonatomic) IBOutlet UIButton *prevHueButton;
@property (nonatomic) IBOutlet UIButton *nextHueButton;

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
        ColorChipThin : [[ColorChip alloc] initWithName:ColorChipThin grayValue:0.95 hue:0 saturation:0.6 lightness:0.45],
        ColorChipLight : [[ColorChip alloc] initWithName:ColorChipLight grayValue:0.75 hue:0 saturation:0.5 lightness:0.1],
        ColorChipNormal : [[ColorChip alloc] initWithName:ColorChipNormal grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
        ColorChipThick : [[ColorChip alloc] initWithName:ColorChipThick grayValue:0.45 hue:0 saturation:0.4 lightness:0.0],
        ColorChipAccent : [[ColorChip alloc] initWithName:ColorChipAccent grayValue:0.5 hue:0 saturation:0.94 lightness:0.0]
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
        [self.thinColorView addGestureRecognizer:tap];
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
        [self.thickColorView addGestureRecognizer:tap];
    }
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.accentColorView addGestureRecognizer:tap];
    }
    
    self.hueSlider.value = 225;
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
    else if (tap.view == self.thinColorView) {
        self.selectedChip = self.thinColorChip;
    }
    else if (tap.view == self.lightColorView) {
        self.selectedChip = self.lightColorChip;
    }
    else if (tap.view == self.normalColorView) {
        self.selectedChip = self.normalColorChip;
    }
    else if (tap.view == self.thickColorView) {
        self.selectedChip = self.thickColorChip;
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

- (NSDictionary *)colorChipMapForHue:(int)hue
{
    NSMutableDictionary *colorChipMap = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%d", hue];
    NSDictionary *map = self.colorMap[key];
    if (map) {
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipHint]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipHint] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipHint] = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipThin]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipThin] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipThin] = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipLight]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipLight] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipLight] = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipNormal]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipNormal] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipNormal] = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipThick]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipThick] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipThick] = chip;
        }
        {
            ColorChip *chip = [[ColorChip alloc] initWithDictionary:map[ColorChipAccent]];
            if (!chip) {
                chip = [self.defaultColorMap[ColorChipAccent] copy];
                chip.hue = hue;
            }
            colorChipMap[ColorChipAccent] = chip;
        }
    }
    else {
        ColorChip *chip;
        
        chip = [self.defaultColorMap[ColorChipHint] copy];
        chip.hue = hue;
        colorChipMap[ColorChipHint] = chip;

        chip = [self.defaultColorMap[ColorChipThin] copy];
        chip.hue = hue;
        colorChipMap[ColorChipThin] = chip;

        chip = [self.defaultColorMap[ColorChipLight] copy];
        chip.hue = hue;
        colorChipMap[ColorChipLight] = chip;

        chip = [self.defaultColorMap[ColorChipNormal] copy];
        chip.hue = hue;
        colorChipMap[ColorChipNormal] = chip;

        chip = [self.defaultColorMap[ColorChipThick] copy];
        chip.hue = hue;
        colorChipMap[ColorChipThick] = chip;

        chip = [self.defaultColorMap[ColorChipAccent] copy];
        chip.hue = hue;
        colorChipMap[ColorChipAccent] = chip;
    }
    return colorChipMap;
}

- (void)updateHue:(int)hue
{
    BOOL isMilepostHue = (hue % 15) == 0;

    if (isMilepostHue) {
        NSLog(@"milepost: %d", hue);
        NSDictionary *colorChipMap = [self colorChipMapForHue:hue];
        self.hintColorChip = colorChipMap[ColorChipHint];
        self.thinColorChip = colorChipMap[ColorChipThin];
        self.lightColorChip = colorChipMap[ColorChipLight];
        self.normalColorChip = colorChipMap[ColorChipNormal];
        self.thickColorChip = colorChipMap[ColorChipThick];
        self.accentColorChip = colorChipMap[ColorChipAccent];
    }
    else {
        int prevHue = [self prevHue];
        int nextHue = [self nextHue];
        NSDictionary *prev = [self colorChipMapForHue:prevHue];
        NSDictionary *next = [self colorChipMapForHue:nextHue];
        CGFloat diff = 360 - fabs(360 - fabs(hue - prevHue));
        CGFloat fraction = diff / 15.0f;
        NSLog(@"fraction: %.2f : %d : %d => %d", fraction, prevHue, nextHue, hue);
        self.hintColorChip = [[ColorChip alloc] initWithName:ColorChipHint hue:hue chipA:prev[ColorChipHint] chipB:next[ColorChipHint] fraction:fraction];
        self.thinColorChip = [[ColorChip alloc] initWithName:ColorChipThin hue:hue chipA:prev[ColorChipThin] chipB:next[ColorChipThin] fraction:fraction];
        self.lightColorChip = [[ColorChip alloc] initWithName:ColorChipLight hue:hue chipA:prev[ColorChipLight] chipB:next[ColorChipLight] fraction:fraction];
        self.normalColorChip = [[ColorChip alloc] initWithName:ColorChipNormal hue:hue chipA:prev[ColorChipNormal] chipB:next[ColorChipNormal] fraction:fraction];
        self.thickColorChip = [[ColorChip alloc] initWithName:ColorChipThick hue:hue chipA:prev[ColorChipThick] chipB:next[ColorChipThick] fraction:fraction];
        self.accentColorChip = [[ColorChip alloc] initWithName:ColorChipAccent hue:hue chipA:prev[ColorChipAccent] chipB:next[ColorChipAccent] fraction:fraction];
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
    self.thinColorLabel.attributedText = [self.thinColorChip attributedDescription];
    self.lightColorLabel.attributedText = [self.lightColorChip attributedDescription];
    self.normalColorLabel.attributedText = [self.normalColorChip attributedDescription];
    self.thickColorLabel.attributedText = [self.thickColorChip attributedDescription];
    self.accentColorLabel.attributedText = [self.accentColorChip attributedDescription];

    self.hintColorView.backgroundColor = self.hintColorChip.color;
    self.thinColorView.backgroundColor = self.thinColorChip.color;
    self.lightColorView.backgroundColor = self.lightColorChip.color;
    self.normalColorView.backgroundColor = self.normalColorChip.color;
    self.thickColorView.backgroundColor = self.thickColorChip.color;
    self.accentColorView.backgroundColor = self.accentColorChip.color;

    self.gameMockupView.hintColor = self.hintColorChip.color;
    self.gameMockupView.thinColor = self.thinColorChip.color;
    self.gameMockupView.lightColor = self.lightColorChip.color;
    self.gameMockupView.normalColor = self.normalColorChip.color;
    self.gameMockupView.thickColor = self.thickColorChip.color;
    self.gameMockupView.accentColor = self.accentColorChip.color;
}

- (IBAction)hueChanged:(UISlider *)sender
{
    int value = roundf(sender.value);
    self.hueValueField.text = [NSString stringWithFormat:@"%d", value];
    [self updateHue:value];
}

- (int)prevHue
{
    int value = roundf(self.hueSlider.value);
    int dv = value % 15;
    if (dv == 0) {
        dv = 15;
    }
    value -= dv;
    if (value < 0) {
        value = 345;
    }
    return value;
}

- (int)nextHue
{
    int value = roundf(self.hueSlider.value);
    int dv = value % 15;
    if (dv == 0) {
        value += 15;
    }
    else {
        value += (15 - dv);
    }
    if (value >= 360) {
        value = 0;
    }
    return value;
}

- (IBAction)prevHueButtonPressed:(UIButton *)sender
{
    int hue = [self prevHue];
    self.hueSlider.value = hue;
    self.hueValueField.text = [NSString stringWithFormat:@"%d", hue];
    [self updateHue:hue];
}

- (IBAction)nextHueButtonPressed:(UIButton *)sender
{
    int hue = [self nextHue];
    self.hueSlider.value = hue;
    self.hueValueField.text = [NSString stringWithFormat:@"%d", hue];
    [self updateHue:hue];
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
    ColorChip *defaultChip = [self.defaultColorMap[self.selectedChip.name] copy];
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

