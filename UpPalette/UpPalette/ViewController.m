//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "AppDelegate.h"
#import "ColorChip.h"
#import "GameMockupView.h"
#import "ViewController.h"

//UPColorCategoryPrimaryFill
//UPColorCategoryInactiveFill
//UPColorCategoryActiveFill
//UPColorCategoryHighlightedFill
//UPColorCategoryPrimaryStroke
//UPColorCategoryInactiveStroke
//UPColorCategoryActiveStroke
//UPColorCategoryHighlightedStroke
//UPColorCategoryContent
//UPColorCategoryCanvas
//UPColorCategoryInformation

static NSString *const ColorMapPathFormat = @"/Users/kocienda/Desktop/up-color-map-%@.json";


@interface ViewController ()

@property (nonatomic) NSArray *colorKeys;

@property (nonatomic) ColorTheme colorTheme;
@property (nonatomic) NSMutableDictionary *colorMap;
@property (nonatomic) NSDictionary *defaultColorMap;

@property (nonatomic) CGFloat hue;

@property (nonatomic) NSMutableDictionary *colorChips;
@property (nonatomic) ColorChip *selectedChip;
@property (nonatomic) ColorChip *savedChip;

@property (nonatomic) GameMockupView *gameMockupView;

@property (nonatomic) IBOutlet UILabel *primaryFillColorLabel;
@property (nonatomic) IBOutlet UILabel *inactiveFillColorLabel;
@property (nonatomic) IBOutlet UILabel *activeFillColorLabel;
@property (nonatomic) IBOutlet UILabel *highlightedFillColorLabel;
@property (nonatomic) IBOutlet UILabel *primaryStrokeColorLabel;
@property (nonatomic) IBOutlet UILabel *inactiveStrokeColorLabel;
@property (nonatomic) IBOutlet UILabel *activeStrokeColorLabel;
@property (nonatomic) IBOutlet UILabel *highlightedStrokeColorLabel;
@property (nonatomic) IBOutlet UILabel *contentColorLabel;
@property (nonatomic) IBOutlet UILabel *informationColorLabel;
@property (nonatomic) IBOutlet UILabel *canvasColorLabel;

@property (nonatomic) NSDictionary *colorLabels;

@property (nonatomic) IBOutlet UIView *primaryFillColorView;
@property (nonatomic) IBOutlet UIView *inactiveFillColorView;
@property (nonatomic) IBOutlet UIView *activeFillColorView;
@property (nonatomic) IBOutlet UIView *highlightedFillColorView;
@property (nonatomic) IBOutlet UIView *primaryStrokeColorView;
@property (nonatomic) IBOutlet UIView *inactiveStrokeColorView;
@property (nonatomic) IBOutlet UIView *activeStrokeColorView;
@property (nonatomic) IBOutlet UIView *highlightedStrokeColorView;
@property (nonatomic) IBOutlet UIView *contentColorView;
@property (nonatomic) IBOutlet UIView *informationColorView;
@property (nonatomic) IBOutlet UIView *canvasColorView;

@property (nonatomic) NSDictionary *colorViews;

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

    self.gameMockupView = [[GameMockupView alloc] initWithFrame:CGRectMake(0, 0, 812, 375)];
    self.gameMockupView.layer.borderWidth = 1;
    [self.view addSubview:self.self.gameMockupView];

    self.colorKeys = @[
        PrimaryFillKey, InactiveFillKey, ActiveFillKey, HighlightedFillKey,
        PrimaryStrokeKey, InactiveStrokeKey, ActiveStrokeKey, HighlightedStrokeKey,
        ContentKey, InformationKey, CanvasKey,
    ];

    self.colorChips = [NSMutableDictionary dictionary];

    self.colorLabels = @{
        PrimaryFillKey: self.primaryFillColorLabel,
        InactiveFillKey: self.inactiveFillColorLabel,
        ActiveFillKey: self.activeFillColorLabel,
        HighlightedFillKey: self.highlightedFillColorLabel,
        PrimaryStrokeKey: self.primaryStrokeColorLabel,
        InactiveStrokeKey: self.inactiveStrokeColorLabel,
        ActiveStrokeKey: self.activeStrokeColorLabel,
        HighlightedStrokeKey: self.highlightedStrokeColorLabel,
        ContentKey: self.contentColorLabel,
        InformationKey: self.informationColorLabel,
        CanvasKey: self.canvasColorLabel
    };

    self.colorViews = @{
        PrimaryFillKey: self.primaryFillColorView,
        InactiveFillKey: self.inactiveFillColorView,
        ActiveFillKey: self.activeFillColorView,
        HighlightedFillKey: self.highlightedFillColorView,
        PrimaryStrokeKey: self.primaryStrokeColorView,
        InactiveStrokeKey: self.inactiveStrokeColorView,
        ActiveStrokeKey: self.activeStrokeColorView,
        HighlightedStrokeKey: self.highlightedStrokeColorView,
        ContentKey: self.contentColorView,
        InformationKey: self.informationColorView,
        CanvasKey: self.canvasColorView
    };

    [self.colorViews enumerateKeysAndObjectsUsingBlock:^(id key, UIView *colorView, BOOL *stop) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [colorView addGestureRecognizer:tap];
        colorView.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
        colorView.layer.borderWidth = 0.5;
    }];

    [self loadColorMap];

    self.hueSlider.value = 225;
    [self hueChanged:self.hueSlider];
    
    self.selectedIndicatorView.layer.cornerRadius = 8;
    self.selectedIndicatorView.backgroundColor = [UIColor blueColor];
    self.selectedIndicatorView.alpha = 0;
    self.selectedChip = nil;
}

- (void)viewDidLayoutSubviews
{
    CGRect layoutRect1 = CGRectInset(self.view.bounds, 38, 66);
    self.gameMockupView.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutRect1 hLayout:UPLayoutHorizontalRight vLayout:UPLayoutVerticalTop];
    [self.gameMockupView layoutWithRule];
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
    if (tap.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    [self cancelEditing];

    __block ColorChip *tappedChip = nil;
    [self.colorViews enumerateKeysAndObjectsUsingBlock:^(id key, id colorView, BOOL *stop) {
        if (tap.view == colorView) {
            tappedChip = self.colorChips[key];
        }
    }];

    if (tappedChip.isClear) {
        // no-op
    }
    else {
        self.selectedChip = tappedChip;
        CGRect frame = self.selectedIndicatorView.frame;
        frame.origin.y = CGRectGetMidY(tap.view.frame);
        frame.origin.y -= CGRectGetHeight(self.selectedIndicatorView.bounds) * 0.5;
        self.selectedIndicatorView.frame = frame;
        self.selectedIndicatorView.alpha = 1;
    }
}

- (void)setSelectedChip:(ColorChip *)selectedChip
{
    _selectedChip = selectedChip;
    if (selectedChip) {
        self.savedChip = [selectedChip copy];
        self.hueSlider.enabled = NO;
        self.hueValueField.enabled = NO;
        self.prevHueButton.enabled = NO;
        self.nextHueButton.enabled = NO;
        self.editColorNameLabel.text = self.selectedChip.name;
        self.editColorNameLabel.enabled = YES;
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
        self.prevHueButton.enabled = YES;
        self.nextHueButton.enabled = YES;
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

- (NSString *)stringForColorTheme:(ColorTheme)colorTheme
{
    switch (colorTheme) {
        case ColorThemeLight:
            return ColorThemeLightKey;
        case ColorThemeDark:
            return ColorThemeDarkKey;
        case ColorThemeStarkLight:
            return ColorThemeStarkLightKey;
        case ColorThemeStarkDark:
            return ColorThemeStarkDarkKey;
    }
    return ColorThemeLightKey;
}

- (void)loadColorMap
{
    [self setDefaultColorMap];

    NSString *pathName = [NSString stringWithFormat:ColorMapPathFormat, [self stringForColorTheme:self.colorTheme]];
    NSData *data = [NSData dataWithContentsOfFile:pathName];
    if (!data) {
        self.colorMap = [NSMutableDictionary dictionary];
        return;
    }
    NSError *error = nil;
    self.colorMap = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error];
    if (error) {
        self.colorMap = [NSMutableDictionary dictionary];
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
    NSString *pathName = [NSString stringWithFormat:ColorMapPathFormat, [self stringForColorTheme:self.colorTheme]];
    [data writeToFile:pathName atomically:YES];
}

- (void)setDefaultColorMap
{
    switch (self.colorTheme) {
        case ColorThemeLight: {
            self.defaultColorMap = @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey grayValue:0.86 hue:0 saturation:0.6 lightness:0.38],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey grayValue:0.73 hue:0 saturation:0.6 lightness:0.42],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey grayValue:0.76 hue:0 saturation:1.0 lightness:0.0],
                PrimaryStrokeKey : [ColorChip clearChipWithName:PrimaryStrokeKey],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey grayValue:0.88 hue:0 saturation:0.81 lightness:0.0],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey grayValue:0.6 hue:0 saturation:1.0 lightness:0.0],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey grayValue:0.5 hue:0 saturation:1.0 lightness:0.0],
                ContentKey : [ColorChip chipWithName:ContentKey grayValue:1.0 hue:0 saturation:0 lightness:1.0],
                InformationKey : [ColorChip chipWithName:InformationKey grayValue:0.43 hue:0 saturation:0.47 lightness:0.0],
                CanvasKey : [ColorChip chipWithName:CanvasKey grayValue:0.92 hue:0 saturation:0.50 lightness:0.54],
            };
            break;
        }
        case ColorThemeDark:
            self.defaultColorMap = @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey grayValue:0.95 hue:0 saturation:0.6 lightness:0.45],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey grayValue:0.75 hue:0 saturation:0.5 lightness:0.1],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                PrimaryStrokeKey : [ColorChip chipWithName:PrimaryStrokeKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey grayValue:0.5 hue:0 saturation:0.94 lightness:0.0],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                ContentKey : [ColorChip chipWithName:ContentKey grayValue:1.0 hue:0 saturation:0 lightness:1.0],
                InformationKey : [ColorChip chipWithName:InformationKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                CanvasKey : [ColorChip chipWithName:CanvasKey grayValue:0.12 hue:0 saturation:0.7 lightness:0.0],
            };
            break;
        case ColorThemeStarkLight:
            self.defaultColorMap = @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey grayValue:0.95 hue:0 saturation:0.6 lightness:0.45],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey grayValue:0.75 hue:0 saturation:0.5 lightness:0.1],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                PrimaryStrokeKey : [ColorChip chipWithName:PrimaryStrokeKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey grayValue:0.5 hue:0 saturation:0.94 lightness:0.0],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                ContentKey : [ColorChip chipWithName:ContentKey grayValue:1.0 hue:0 saturation:0 lightness:1.0],
                InformationKey : [ColorChip chipWithName:InformationKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                CanvasKey : [ColorChip chipWithName:CanvasKey grayValue:0.12 hue:0 saturation:0.7 lightness:0.0],
            };
            break;
        case ColorThemeStarkDark:
            self.defaultColorMap = @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey grayValue:0.95 hue:0 saturation:0.6 lightness:0.45],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey grayValue:0.75 hue:0 saturation:0.5 lightness:0.1],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                PrimaryStrokeKey : [ColorChip chipWithName:PrimaryStrokeKey grayValue:0.43 hue:0 saturation:0.675 lightness:0.0],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey grayValue:0.5 hue:0 saturation:0.94 lightness:0.0],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                ContentKey : [ColorChip chipWithName:ContentKey grayValue:1.0 hue:0 saturation:0 lightness:1.0],
                InformationKey : [ColorChip chipWithName:InformationKey grayValue:0.5 hue:0 saturation:0.75 lightness:0.0],
                CanvasKey : [ColorChip chipWithName:CanvasKey grayValue:0.12 hue:0 saturation:0.7 lightness:0.0],
            };
            break;
    }
}

- (NSDictionary *)colorChipMapForHue:(int)hue
{
    NSMutableDictionary *colorChipMap = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%d", hue];
    NSDictionary *map = self.colorMap[key];
    if (map) {
        for (NSString *key in self.colorKeys) {
            ColorChip *chip = [ColorChip chipWithDictionary:map[key]];
            if (!chip) {
                chip = [self.defaultColorMap[key] copy];
                chip.hue = hue;
            }
            colorChipMap[key] = chip;
        }
    }
    else {
        for (NSString *key in self.colorKeys) {
            ColorChip *chip = [self.defaultColorMap[key] copy];
            chip.hue = hue;
            colorChipMap[key] = chip;
        }
    }
    return colorChipMap;
}

- (void)updateHue:(int)hue
{
    self.hue = hue;

    BOOL isMilepostHue = (hue % 15) == 0;

    [self.colorChips removeAllObjects];

    if (isMilepostHue) {
        NSDictionary *colorChipMap = [self colorChipMapForHue:hue];
        for (NSString *key in self.colorKeys) {
            self.colorChips[key] = colorChipMap[key];
        }
    }
    else {
        int prevHue = [self prevHue];
        int nextHue = [self nextHue];
        NSDictionary *prev = [self colorChipMapForHue:prevHue];
        NSDictionary *next = [self colorChipMapForHue:nextHue];
        CGFloat diff = 360 - fabs(360 - fabs(hue - prevHue));
        CGFloat fraction = diff / 15.0f;
        for (NSString *key in self.colorKeys) {
            self.colorChips[key] = [ColorChip chipWithName:key hue:hue chipA:prev[key] chipB:next[key] fraction:fraction];
        }
    }
    
    [self updateColors];
    
    self.selectedIndicatorView.alpha = 0;
}

- (void)updateColors
{
    if (self.selectedChip) {
        self.afterColorView.backgroundColor = self.selectedChip.color;
    }

    NSMutableDictionary *colors = [NSMutableDictionary dictionary];
    for (NSString *key in self.colorKeys) {
        ColorChip *chip = self.colorChips[key];
        UIColor *color = chip.color;
        [self.colorLabels[key] setAttributedText:chip.attributedDescription];
        [self.colorViews[key] setBackgroundColor:color];
        colors[key] = color;
    }
    self.gameMockupView.colors = colors;
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

- (IBAction)colorThemeChanged:(UISegmentedControl *)sender
{
    [self saveColorMap];
    [self.colorMap removeAllObjects];
    self.colorTheme = sender.selectedSegmentIndex;
    [self loadColorMap];
    [self updateHue:self.hue];
    [self updateColors];
}

- (IBAction)gameStateChanged:(UISegmentedControl *)sender
{
    self.gameMockupView.gameState = sender.selectedSegmentIndex;
}

@end

