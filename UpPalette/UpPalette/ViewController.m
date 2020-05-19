//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UpKit.h>

#import "AppDelegate.h"
#import "ColorChip.h"
#import "GameMockupView.h"
#import "ColorChipTableViewCell.h"
#import "ViewController.h"

static NSString *const ColorMapPathFormat = @"/Users/kocienda/Desktop/up-color-map-%@.json";
static NSString *const ExportedColorsPath = @"/System/Volumes/Data/Projects/Up-Games/Up/UpKit/UpKit/UP/UPThemeColors.c";

static const int HueCount = 360;
static const int MilepostHue = 15;

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) NSArray *colorKeys;

@property (nonatomic) ColorTheme colorTheme;
@property (nonatomic) NSMutableDictionary *colorMap;
@property (nonatomic) NSDictionary *defaultColorMap;

@property (nonatomic) CGFloat hue;

@property (nonatomic) NSMutableDictionary *colorChips;
@property (nonatomic) ColorChip *selectedChip;
@property (nonatomic) ColorChip *conformedChip;
@property (nonatomic) ColorChip *editStartChip;

@property (nonatomic) GameMockupView *gameMockupView;

@property (nonatomic) IBOutlet UITableView *colorChipTableView;

@property (nonatomic) IBOutlet UISlider *hueSlider;
@property (nonatomic) IBOutlet UITextField *hueValueField;

@property (nonatomic) IBOutlet UILabel *editColorNameLabel;

@property (nonatomic) IBOutlet UILabel *grayLabel;
@property (nonatomic) IBOutlet UISlider *graySlider;
@property (nonatomic) IBOutlet UITextField *grayValueField;

@property (nonatomic) IBOutlet UILabel *saturationLabel;
@property (nonatomic) IBOutlet UISlider *saturationSlider;
@property (nonatomic) IBOutlet UITextField *saturationValueField;

@property (nonatomic) IBOutlet UILabel *lightnessLabel;
@property (nonatomic) IBOutlet UISlider *lightnessSlider;
@property (nonatomic) IBOutlet UITextField *lightnessValueField;

@property (nonatomic) IBOutlet UIView *startColorView;
@property (nonatomic) IBOutlet UIView *adjustedColorView;
@property (nonatomic) IBOutlet UIView *conformedColorView;

@property (nonatomic) IBOutlet UILabel *startColorLabel;
@property (nonatomic) IBOutlet UILabel *conformedColorLabel;

@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) IBOutlet UIButton *defaultButton;
@property (nonatomic) IBOutlet UIButton *acceptButton;
@property (nonatomic) IBOutlet UIButton *conformButton;
@property (nonatomic) IBOutlet UIButton *conformAllButton;

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
        PrimaryFillKey,
        InactiveFillKey,
        ActiveFillKey,
        HighlightedFillKey,
        SecondaryActiveFillKey,
        SecondaryInactiveFillKey,
        SecondaryActiveFillKey,
        SecondaryHighlightedFillKey,
        PrimaryStrokeKey,
        InactiveStrokeKey,
        ActiveStrokeKey,
        HighlightedStrokeKey,
        SecondaryStrokeKey,
        SecondaryInactiveStrokeKey,
        SecondaryActiveStrokeKey,
        SecondaryHighlightedStrokeKey,
        ContentKey,
        InactiveContentKey,
        ActiveContentKey,
        HighlightedContentKey,
        InformationKey,
        InfinityKey,
    ];

    self.colorChips = [NSMutableDictionary dictionary];

    [self loadColorMap];

    self.hueSlider.value = 225;
    [self hueChanged:self.hueSlider];
    
    self.selectedChip = nil;
    
    [self.colorChipTableView registerClass:[ColorChipTableViewCell class] forCellReuseIdentifier:@"ColorChip"];
    [self.colorChipTableView reloadData];
}

- (void)viewDidLayoutSubviews
{
    CGRect layoutRect1 = CGRectInset(self.view.bounds, 38, 78);
    self.gameMockupView.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:layoutRect1 hLayout:UPLayoutHorizontalRight vLayout:UPLayoutVerticalTop];
    [self.gameMockupView layoutWithRule];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.colorKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColorChipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ColorChip"];
    NSString *key = self.colorKeys[indexPath.row];
    if (self.selectedChip && [self.selectedChip.name isEqualToString:key]) {
        cell.colorChip = self.selectedChip;
    }
    else {
        cell.colorChip = self.colorChips[key];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancelEditing];

    NSString *key = self.colorKeys[indexPath.row];
    ColorChip *tappedChip = self.colorChips[key];

    if (tappedChip.isClear) {
        // no-op
    }
    else {
        self.selectedChip = tappedChip;
    }
}

#pragma mark -

- (void)setSelectedChip:(ColorChip *)selectedChip
{
    _selectedChip = selectedChip;
    if (selectedChip) {
        self.conformedChip = [_selectedChip chipWithTargetLightness];
        self.editStartChip = [selectedChip copy];
        self.hueSlider.enabled = NO;
        self.hueValueField.enabled = NO;
        self.prevHueButton.enabled = NO;
        self.nextHueButton.enabled = NO;
        self.editColorNameLabel.text = self.selectedChip.name;
        self.editColorNameLabel.enabled = YES;
        self.grayLabel.enabled = YES;
        self.graySlider.enabled = YES;
        self.grayValueField.enabled = YES;
        self.saturationLabel.enabled = YES;
        self.saturationSlider.enabled = YES;
        self.saturationValueField.enabled = YES;
        self.lightnessLabel.enabled = YES;
        self.lightnessSlider.enabled = YES;
        self.lightnessValueField.enabled = YES;
        self.cancelButton.enabled = YES;
        self.defaultButton.enabled = YES;
        self.acceptButton.enabled = YES;
        self.conformButton.enabled = YES;
        self.conformAllButton.enabled = YES;
        self.startColorView.backgroundColor = self.selectedChip.color;
        self.adjustedColorView.backgroundColor = self.selectedChip.color;
        
        self.lightnessSlider.value = [self.defaultColorMap[self.selectedChip.name] targetLightness];
        [self lightnessSliderChanged:self.lightnessSlider];
        
        self.graySlider.value = self.selectedChip.gray * 100;
        [self inputGraySliderChanged:self.graySlider];

        self.saturationSlider.value = self.selectedChip.saturation * 100;
        [self saturationSliderChanged:self.saturationSlider];

        self.startColorLabel.attributedText = [self.selectedChip attributedDescription];
    }
    else {
        self.conformedChip = nil;
        self.editStartChip = nil;
        self.editColorNameLabel.text = @"None";
        self.editColorNameLabel.enabled = NO;
        self.hueSlider.enabled = YES;
        self.hueValueField.enabled = YES;
        self.prevHueButton.enabled = YES;
        self.nextHueButton.enabled = YES;
        self.grayLabel.enabled = NO;
        self.graySlider.enabled = NO;
        self.grayValueField.enabled = NO;
        self.saturationLabel.enabled = NO;
        self.saturationSlider.enabled = NO;
        self.saturationValueField.enabled = NO;
        self.lightnessLabel.enabled = NO;
        self.lightnessSlider.enabled = NO;
        self.lightnessValueField.enabled = NO;
        self.cancelButton.enabled = NO;
        self.defaultButton.enabled = NO;
        self.acceptButton.enabled = NO;
        self.conformButton.enabled = NO;
        self.conformAllButton.enabled = NO;
        self.startColorLabel.text = @"";
        self.conformedColorLabel.text = @"";
        self.startColorView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        self.adjustedColorView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
        self.conformedColorView.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    }
}

- (NSString *)stringForColorTheme:(ColorTheme)colorTheme
{
    switch (colorTheme) {
        case ColorThemeLight:
            return ColorThemeLightKey;
        case ColorThemeDark:
            return ColorThemeDarkKey;
        case ColorThemeLightStark:
            return ColorThemeLightStarkKey;
        case ColorThemeDarkStark:
            return ColorThemeDarkStarkKey;
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
    self.defaultColorMap = [self defaultColorMapForTheme:self.colorTheme];
}

- (NSDictionary *)defaultColorMapForTheme:(ColorTheme)colorTheme
{
    switch (colorTheme) {
        case ColorThemeLight:
            return @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey hue:0 gray:0.33 saturation:0.7 targetLightness:29],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey hue:0 gray:0.91 saturation:0.6 targetLightness:91],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey hue:0 gray:0.85 saturation:0.6 targetLightness:82],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey hue:0 gray:0.76 saturation:1.0 targetLightness:68],
                SecondaryFillKey : [ColorChip chipWithName:SecondaryFillKey hue:0 gray:0.95 saturation:0.35 targetLightness:95],
                SecondaryInactiveFillKey : [ColorChip chipWithName:SecondaryInactiveFillKey hue:0 gray:0.95 saturation:0.35 targetLightness:95],
                SecondaryActiveFillKey : [ColorChip chipWithName:SecondaryActiveFillKey hue:0 gray:0.85 saturation:0.35 targetLightness:84],
                SecondaryHighlightedFillKey : [ColorChip chipWithName:SecondaryHighlightedFillKey hue:0 gray:0.76 saturation:1.0 targetLightness:75],
                PrimaryStrokeKey : [ColorChip clearChipWithName:PrimaryStrokeKey],
                InactiveStrokeKey : [ColorChip clearChipWithName:InactiveStrokeKey],
                ActiveStrokeKey : [ColorChip clearChipWithName:ActiveStrokeKey],
                HighlightedStrokeKey : [ColorChip clearChipWithName:HighlightedStrokeKey],
                SecondaryStrokeKey : [ColorChip clearChipWithName:SecondaryStrokeKey],
                SecondaryInactiveStrokeKey : [ColorChip chipWithName:SecondaryInactiveStrokeKey hue:0 gray:0.88 saturation:0.35 targetLightness:85],
                SecondaryActiveStrokeKey : [ColorChip chipWithName:SecondaryActiveStrokeKey hue:0 gray:0.68 saturation:0.8 targetLightness:60],
                SecondaryHighlightedStrokeKey : [ColorChip chipWithName:SecondaryHighlightedStrokeKey hue:0 gray:0. saturation:1.0 targetLightness:38],
                ContentKey : [ColorChip chipWithName:ContentKey hue:0 gray:1.0 saturation:0],
                InactiveContentKey : [ColorChip chipWithName:InactiveContentKey hue:0 gray:1.0 saturation:0],
                ActiveContentKey : [ColorChip chipWithName:ActiveContentKey hue:0 gray:1.0 saturation:0],
                HighlightedContentKey : [ColorChip chipWithName:HighlightedContentKey hue:0 gray:1.0 saturation:0],
                InformationKey : [ColorChip chipWithName:InformationKey hue:0 gray:0.30 saturation:0.50 targetLightness:28],
                InfinityKey : [ColorChip chipWithName:InfinityKey hue:0 gray:0.99 saturation:0.35 targetLightness:99],
            };
        case ColorThemeDark:
            return @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey hue:0 gray:0.8 saturation:0.9 targetLightness:77],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey hue:0 gray:0.40 saturation:0.15 targetLightness:40],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey hue:0 gray:0.65 saturation:0.68 targetLightness:60],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey hue:0 gray:1.0 saturation:1.0],
                SecondaryFillKey : [ColorChip chipWithName:SecondaryFillKey hue:0 gray:0.25 saturation:0.25 targetLightness:23],
                SecondaryInactiveFillKey : [ColorChip chipWithName:SecondaryInactiveFillKey hue:0 gray:0.25 saturation:0.25 targetLightness:23],
                SecondaryActiveFillKey : [ColorChip chipWithName:SecondaryActiveFillKey hue:0 gray:0.33 saturation:0.55 targetLightness:31],
                SecondaryHighlightedFillKey : [ColorChip chipWithName:SecondaryHighlightedFillKey hue:0 gray:0.44 saturation:0.70 targetLightness:42],
                PrimaryStrokeKey : [ColorChip clearChipWithName:PrimaryStrokeKey],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey hue:0 gray:0.56 saturation:0.3 targetLightness:53],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey hue:0 gray:0.77 saturation:0.77 targetLightness:71],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey hue:0 gray:1.0 saturation:1.0],
                SecondaryStrokeKey : [ColorChip clearChipWithName:SecondaryStrokeKey],
                SecondaryInactiveStrokeKey : [ColorChip chipWithName:SecondaryInactiveStrokeKey hue:0 gray:0.56 saturation:0.3 targetLightness:53],
                SecondaryActiveStrokeKey : [ColorChip chipWithName:SecondaryActiveStrokeKey hue:0 gray:0.77 saturation:0.77 targetLightness:71],
                SecondaryHighlightedStrokeKey : [ColorChip chipWithName:SecondaryHighlightedStrokeKey hue:0 gray:1.0 saturation:1.0],
                ContentKey : [ColorChip chipWithName:ContentKey hue:0 gray:0.0 saturation:0],
                InactiveContentKey : [ColorChip chipWithName:InactiveContentKey hue:0 gray:0.0 saturation:0],
                ActiveContentKey : [ColorChip chipWithName:ActiveContentKey hue:0 gray:0.0 saturation:0],
                HighlightedContentKey : [ColorChip chipWithName:HighlightedContentKey hue:0 gray:0.0 saturation:0],
                InformationKey : [ColorChip chipWithName:InformationKey hue:0 gray:0.85 saturation:0.9 targetLightness:80],
                InfinityKey : [ColorChip chipWithName:InfinityKey hue:0 gray:0.12 saturation:0.7 targetLightness:9],
            };
        case ColorThemeLightStark:
            return @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey hue:0 gray:0.98 saturation:0.68 targetLightness:99],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey hue:0 gray:0.97 saturation:0.6 targetLightness:96.5],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey hue:0 gray:0.8 saturation:0.5 targetLightness:80],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey hue:0 gray:0.83 saturation:0.85 targetLightness:80],
                SecondaryFillKey : [ColorChip chipWithName:SecondaryFillKey hue:0 gray:0.98 saturation:0.4 targetLightness:99],
                SecondaryInactiveFillKey : [ColorChip chipWithName:SecondaryInactiveFillKey hue:0 gray:0.98 saturation:0.4 targetLightness:99],
                SecondaryActiveFillKey : [ColorChip chipWithName:SecondaryActiveFillKey hue:0 gray:0.93 saturation:0.55 targetLightness:92],
                SecondaryHighlightedFillKey : [ColorChip chipWithName:SecondaryHighlightedFillKey hue:0 gray:0.90 saturation:1.0 targetLightness:86],
                PrimaryStrokeKey : [ColorChip chipWithName:PrimaryStrokeKey hue:0 gray:0.2 saturation:0.85 targetLightness:18],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey hue:0 gray:0.90 saturation:0.40 targetLightness:87],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey hue:0 gray:0.75 saturation:0.75 targetLightness:70],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey hue:0 gray:0.52 saturation:1.0 targetLightness:45],
                SecondaryStrokeKey : [ColorChip chipWithName:SecondaryStrokeKey hue:0 gray:0.2 saturation:0.85 targetLightness:18],
                SecondaryInactiveStrokeKey : [ColorChip chipWithName:SecondaryInactiveStrokeKey hue:0 gray:0.90 saturation:0.40 targetLightness:87],
                SecondaryActiveStrokeKey : [ColorChip chipWithName:SecondaryActiveStrokeKey hue:0 gray:0.75 saturation:0.75 targetLightness:70],
                SecondaryHighlightedStrokeKey : [ColorChip chipWithName:SecondaryHighlightedStrokeKey hue:0 gray:0.52 saturation:1.0 targetLightness:45],
                ContentKey : [ColorChip chipWithName:ContentKey hue:0 gray:0.2 saturation:0.85 targetLightness:18],
                InactiveContentKey : [ColorChip chipWithName:InactiveContentKey hue:0 gray:0.8 saturation:0.45 targetLightness:80],
                ActiveContentKey : [ColorChip chipWithName:ActiveContentKey hue:0 gray:0.8 saturation:0.45 targetLightness:80],
                HighlightedContentKey : [ColorChip chipWithName:HighlightedContentKey hue:0 gray:1.0 saturation:0.0 targetLightness:100],
                InformationKey : [ColorChip chipWithName:InformationKey hue:0 gray:0.2 saturation:0.75 targetLightness:18],
                InfinityKey : [ColorChip chipWithName:InfinityKey hue:0 gray:0.98 saturation:0.50 targetLightness:99],
            };
        case ColorThemeDarkStark:
            return @{
                PrimaryFillKey: [ColorChip chipWithName:PrimaryFillKey hue:0 gray:0.12 saturation:0.68 targetLightness:8],
                InactiveFillKey : [ColorChip chipWithName:InactiveFillKey hue:0 gray:0.10 saturation:0.25 targetLightness:8],
                ActiveFillKey : [ColorChip chipWithName:ActiveFillKey hue:0 gray:0.10 saturation:0.5 targetLightness:15],
                HighlightedFillKey : [ColorChip chipWithName:HighlightedFillKey hue:0 gray:0.47 saturation:1.0 targetLightness:45],
                SecondaryFillKey : [ColorChip chipWithName:SecondaryFillKey hue:0 gray:0.12 saturation:0.68 targetLightness:8],
                SecondaryInactiveFillKey : [ColorChip chipWithName:SecondaryInactiveFillKey hue:0 gray:0.12 saturation:0.68 targetLightness:8],
                SecondaryActiveFillKey : [ColorChip chipWithName:SecondaryActiveFillKey hue:0 gray:0.20 saturation:0.5 targetLightness:15],
                SecondaryHighlightedFillKey : [ColorChip chipWithName:SecondaryHighlightedFillKey hue:0 gray:0.47 saturation:1.0 targetLightness:45],
                PrimaryStrokeKey : [ColorChip chipWithName:PrimaryStrokeKey hue:0 gray:0.80 saturation:0.68 targetLightness:77],
                InactiveStrokeKey : [ColorChip chipWithName:InactiveStrokeKey hue:0 gray:0.55 saturation:0.15 targetLightness:50],
                ActiveStrokeKey : [ColorChip chipWithName:ActiveStrokeKey hue:0 gray:0.83 saturation:0.60 targetLightness:80],
                HighlightedStrokeKey : [ColorChip chipWithName:HighlightedStrokeKey hue:0 gray:0.95 saturation:1.0 targetLightness:95],
                SecondaryStrokeKey : [ColorChip chipWithName:SecondaryStrokeKey hue:0 gray:0.80 saturation:0.68 targetLightness:77],
                SecondaryInactiveStrokeKey : [ColorChip chipWithName:SecondaryInactiveStrokeKey hue:0 gray:0.55 saturation:0.15 targetLightness:50],
                SecondaryActiveStrokeKey : [ColorChip chipWithName:SecondaryActiveStrokeKey hue:0 gray:0.83 saturation:0.60 targetLightness:80],
                SecondaryHighlightedStrokeKey : [ColorChip chipWithName:SecondaryHighlightedStrokeKey hue:0 gray:0.95 saturation:1.0 targetLightness:95],
                ContentKey : [ColorChip chipWithName:ContentKey hue:0 gray:1.00 saturation:1.0],
                InactiveContentKey : [ColorChip chipWithName:InactiveContentKey hue:0 gray:0.37 saturation:0.2 targetLightness:37],
                ActiveContentKey : [ColorChip chipWithName:ActiveContentKey hue:0 gray:0.37 saturation:0.2 targetLightness:37],
                HighlightedContentKey : [ColorChip chipWithName:HighlightedContentKey hue:0 gray:0.37 saturation:0.2 targetLightness:37],
                InformationKey : [ColorChip chipWithName:InformationKey hue:0 gray:1.00 saturation:1.0],
                InfinityKey : [ColorChip chipWithName:InfinityKey hue:0 gray:0.12 saturation:0.68 targetLightness:8],
            };
    }
    return nil;
}

- (NSDictionary *)colorChipMapForHue:(int)hue
{
    return [self colorChipMapForHue:hue colorMap:self.colorMap defaultColorMap:self.defaultColorMap];
}

- (NSDictionary *)colorChipMapForHue:(int)hue colorMap:(NSDictionary *)colorMap defaultColorMap:(NSDictionary *)defaultColorMap
{
    NSMutableDictionary *colorChipMap = [NSMutableDictionary dictionary];
    NSString *key = [NSString stringWithFormat:@"%d", hue];
    NSDictionary *hueMap = colorMap[key];
    if (hueMap) {
        for (NSString *key in self.colorKeys) {
            ColorChip *chip = [ColorChip chipWithDictionary:hueMap[key]];
            if (!chip) {
                chip = [defaultColorMap[key] copy];
                chip.hue = hue;
            }
            colorChipMap[key] = chip;
        }
    }
    else {
        for (NSString *key in self.colorKeys) {
            ColorChip *chip = [defaultColorMap[key] copy];
            chip.hue = hue;
            colorChipMap[key] = chip;
        }
    }
    return colorChipMap;
}

- (void)updateHue:(int)hue
{
    self.hue = hue;

    BOOL isMilepostHue = (hue % MilepostHue) == 0;

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
        CGFloat diff = HueCount - fabs(HueCount - fabs(hue - prevHue));
        CGFloat fraction = diff / MilepostHue;
        for (NSString *key in self.colorKeys) {
            ColorChip *chipA = prev[key];
            ColorChip *chipB = next[key];
            ColorChip *chipC = [ColorChip chipWithName:key hue:hue targetLightness:chipA.targetLightness
                chipA:chipA chipB:chipB fraction:fraction];
            ColorChip *conformedChip = [chipC chipWithTargetLightness];
            self.colorChips[key] = conformedChip;
        }
    }
    
    [self updateColors];
}

- (void)updateColors
{
    if (self.selectedChip) {
        self.adjustedColorView.backgroundColor = self.selectedChip.color;
        self.conformedChip = [self.selectedChip chipWithTargetLightness];
        self.conformedColorView.backgroundColor = self.conformedChip.color;
        self.conformedColorLabel.attributedText = self.conformedChip.attributedDescription;
    }

    [self.colorChipTableView reloadData];

    NSMutableDictionary *colors = [NSMutableDictionary dictionary];
    for (NSString *key in self.colorKeys) {
        ColorChip *chip = self.colorChips[key];
        UIColor *color = chip.color;
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

- (BOOL)isMilepostHue:(int)hue
{
    return hue % MilepostHue == 0;
}

- (int)prevHue
{
    return [self prevHueForHue:roundf(self.hueSlider.value)];
}

- (int)prevHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        dv = MilepostHue;
    }
    hue -= dv;
    if (hue < 0) {
        hue = HueCount - MilepostHue;
    }
    return hue;
}

- (int)nextHue
{
    return [self nextHueForHue:roundf(self.hueSlider.value)];
}

- (int)nextHueForHue:(int)hue
{
    int dv = hue % MilepostHue;
    if (dv == 0) {
        hue += MilepostHue;
    }
    else {
        hue += (MilepostHue - dv);
    }
    if (hue >= HueCount) {
        hue = 0;
    }
    return hue;
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
    self.grayValueField.text = [NSString stringWithFormat:@"%d", value];
    self.selectedChip.gray = (float)value / 100;
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
    ColorChip *chip = self.defaultColorMap[self.selectedChip.name];
    chip.targetLightness = (float)value;
    [self updateColors];
}

- (IBAction)conformAllButtonPressed:(UIButton *)sender
{
    int startHue = roundf(self.hueSlider.value);
    NSString *chipKey = self.conformedChip.name;
    int hue = 0;
    while (hue <= HueCount) {
        [self updateHue:hue];
        ColorChip *chip = [self.defaultColorMap[chipKey] copy];
        chip.hue = hue;
        ColorChip *conformedChip = [chip chipWithTargetLightness];
        if (![self.conformedChip isEqual:chip]) {
            NSString *hueKey = [NSString stringWithFormat:@"%d", hue];
            NSMutableDictionary *map = self.colorMap[hueKey];
            if (!map) {
                map = [NSMutableDictionary dictionary];
            }
            map[chipKey] = [conformedChip dictionary];
            self.colorMap[hueKey] = map;
        }
        hue += MilepostHue;
    }
    [self saveColorMap];
    [self updateHue:startHue];
    [self updateColors];
    self.selectedChip = nil;
}

- (IBAction)conformButtonPressed:(UIButton *)sender
{
    if (![self.conformedChip isEqual:self.editStartChip]) {
        self.colorChips[self.conformedChip.name] = self.conformedChip;
        int hue = self.conformedChip.hue;
        NSString *key = [NSString stringWithFormat:@"%d", hue];
        NSMutableDictionary *map = self.colorMap[key];
        if (!map) {
            map = [NSMutableDictionary dictionary];
        }
        map[self.conformedChip.name] = [self.conformedChip dictionary];
        self.colorMap[key] = map;
        [self saveColorMap];
        [self updateColors];
    }
    self.selectedChip = nil;
    self.conformedChip = nil;
}

- (IBAction)acceptButtonPressed:(UIButton *)sender
{
    if (![self.selectedChip isEqual:self.editStartChip]) {
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
    self.conformedChip = nil;
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
    self.editStartChip = nil;
    [self updateColors];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender
{
    [self cancelEditing];
}

- (void)cancelEditing
{
    [self.selectedChip takeValuesFrom:self.editStartChip];
    [self updateColors];
    self.selectedChip = nil;
    self.conformedChip = nil;
    self.editStartChip = nil;
}

- (IBAction)colorThemeChanged:(UISegmentedControl *)sender
{
    [self saveColorMap];
    [self.colorMap removeAllObjects];
    self.colorTheme = sender.selectedSegmentIndex;
    self.gameMockupView.colorTheme = self.colorTheme;
    [self loadColorMap];
    [self updateHue:self.hue];
    [self updateColors];
}

- (IBAction)gameStateChanged:(UISegmentedControl *)sender
{
    self.gameMockupView.gameState = sender.selectedSegmentIndex;
}

- (IBAction)exportColors:(id)sender
{
    [self generateSourceCodeForColorThemes];
}

- (void)generateSourceCodeForColorThemes
{
    NSMutableString *sourceCode = [NSMutableString string];
    [sourceCode appendString:@"//\n"];
    [sourceCode appendString:@"// Generated code for Up Games colors\n"];
    [sourceCode appendString:@"// DO NOT EDIT\n"];
    [sourceCode appendString:@"//\n"];
    [sourceCode appendString:@"typedef struct \n"];
    [sourceCode appendString:@"{ \n"];
    [sourceCode appendString:@"    CGFloat r;\n"];
    [sourceCode appendString:@"    CGFloat g;\n"];
    [sourceCode appendString:@"    CGFloat b;\n"];
    [sourceCode appendString:@"    CGFloat a;\n"];
    [sourceCode appendString:@"} _UPRGBColorComponents;\n"];
    [sourceCode appendString:@"//\n"];
    [sourceCode appendString:@"\n"];
    [sourceCode appendString:@"static _UPRGBColorComponents _UPThemeColorComponents[] = {\n"];
    [sourceCode appendString:[self generateSourceCodeForColorTheme:ColorThemeLight]];
    [sourceCode appendString:[self generateSourceCodeForColorTheme:ColorThemeDark]];
    [sourceCode appendString:[self generateSourceCodeForColorTheme:ColorThemeLightStark]];
    [sourceCode appendString:[self generateSourceCodeForColorTheme:ColorThemeDarkStark]];
    [sourceCode appendString:@"};\n"];
    [sourceCode appendString:@"\n"];
    NSError *error;
    [sourceCode writeToFile:ExportedColorsPath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"*** export error: %@", error.localizedDescription);
    }
}

- (NSString *)generateSourceCodeForColorTheme:(ColorTheme)colorTheme
{
    NSMutableString *sourceCode = [NSMutableString string];
    [sourceCode appendString:@"//\n"];
    [sourceCode appendString:@"// Colors for "];
    [sourceCode appendString:[self stringForColorTheme:colorTheme]];
    [sourceCode appendString:@" mode\n"];
    [sourceCode appendString:@"//\n"];

    NSString *pathName = [NSString stringWithFormat:ColorMapPathFormat, [self stringForColorTheme:colorTheme]];
    NSData *data = [NSData dataWithContentsOfFile:pathName];
    if (!data) {
        return sourceCode;
    }
    NSError *error = nil;
    NSDictionary *colorMap = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        return sourceCode;
    }
    
    NSDictionary *defaultColorMap = [self defaultColorMapForTheme:colorTheme];
    NSMutableDictionary *colorChips = [NSMutableDictionary dictionary];
    
    for (int hue = 0; hue < HueCount; hue++) {
        [colorChips removeAllObjects];
        if ([self isMilepostHue:hue]) {
            NSDictionary *colorChipMap = [self colorChipMapForHue:hue colorMap:colorMap defaultColorMap:defaultColorMap];
            for (NSString *key in self.colorKeys) {
                colorChips[key] = colorChipMap[key];
            }
        }
        else {
            int prevHue = [self prevHueForHue:hue];
            int nextHue = [self nextHueForHue:hue];
            NSDictionary *prev = [self colorChipMapForHue:prevHue colorMap:colorMap defaultColorMap:defaultColorMap];
            NSDictionary *next = [self colorChipMapForHue:nextHue colorMap:colorMap defaultColorMap:defaultColorMap];
            CGFloat diff = HueCount - fabs(HueCount - fabs(hue - prevHue));
            CGFloat fraction = diff / MilepostHue;
            for (NSString *key in self.colorKeys) {
                ColorChip *chipA = prev[key];
                ColorChip *chipB = next[key];
                ColorChip *chipC = [ColorChip chipWithName:key hue:hue targetLightness:chipA.targetLightness
                    chipA:chipA chipB:chipB fraction:fraction];
                ColorChip *conformedChip = [chipC chipWithTargetLightness];
                colorChips[key] = conformedChip;
            }
        }
        [sourceCode appendFormat:@"// Hue %d\n", hue];
        for (NSString *colorKey in self.colorKeys) {
            ColorChip *chip = colorChips[colorKey];
            UIColor *color = chip.color;
            CGFloat r, g, b, a;
            [color getRed:&r green:&g blue:&b alpha:&a];
            [sourceCode appendString:@"   "];
            [sourceCode appendFormat:@"{ %3.6f, %3.6f, %3.6f, %3.6f },", r, g, b, a];
            [sourceCode appendString:@" // "];
            [sourceCode appendString:colorKey];
            [sourceCode appendString:@"\n"];
        }
    }

    return sourceCode;
}

@end
