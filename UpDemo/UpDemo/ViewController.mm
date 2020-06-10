//
//  ViewController.m
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <string>

#import <UpKit/UpKit.h>

#import "ViewController.h"

using UP::ObjCProperty;

@interface UPSpellSettings : UPSettings
@property (nonatomic) NSArray *foo;
@end

@implementation UPSpellSettings
@dynamic foo;
- (void)setDefaultValues
{
    self.foo = @[ @(1), @(2), @(3) ];
}
@end


@interface ViewController ()
//@property (nonatomic) UPQuadView *v1;
//@property (nonatomic) UIView *v2;
//@property (nonatomic) UIView *v3;
//@property (nonatomic) UIImage *image;
//@property (nonatomic) UIImageView *imageView;
//@property (nonatomic) CGFloat hue;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    LOG_CHANNEL_ON(General);
    //LOG_CHANNEL_ON(Settings);

//    std::string name = ObjCProperty::name_from_selector("set:");
    
    UPSpellSettings *settings = [[UPSpellSettings alloc] init];
//    NSInteger bar = settings.bar;
//    LOG(General, "bar: %ld", bar);
    //    NSInteger foo = settings.foo;
//    settings.foo = 37;
//    settings.foo = 59;
    [settings resetDefaultValues];
//    settings.foo = @[ @(4), @(5), @(6) ];
    LOG(General, "foo: %@", settings.foo);
    LOG(General, "ok");

    
    
//    CGRect rect = CGRectMake(100, 100, 100, 120);
//    UPQuadOffsets offsets = UPQuadOffsetsMake(UPOffsetMake(10, 0), UPOffsetMake(-10, 0), UPOffsetMake(-10, 0), UPOffsetMake(10, 0));
//    UPQuadOffsets offsets = UPQuadOffsetsMake(UPOffsetMake(0, 0), UPOffsetMake(0, 0), UPOffsetMake(-40, 0), UPOffsetMake(40, 0));
//    UPQuad q = UPQuadMakeWithRectAndOffsets(rect, offsets);
//    CGFloat a = up_quad_area(q);

//    self.v1 = [[UPQuadView alloc] initWithFrame:rect];
//    self.v1.quadOffsets = offsets;
//    self.v1.backgroundColor = [UIColor testColor1];
//    [self.view addSubview:self.v1];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        CGRect viewLayoutRect = CGRectInset(self.view.bounds, 40, 100);
//        self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:viewLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
//        [self.v1 layoutWithRule];
//    });
    
//    CATransform3D t = up_transform_for_rect_to_quad(self.v1.frame, offsets);
//    self.v1.layer.transform = t;

//    [self.v1 transformToFitQuadTopLeft:CGPointMake(100, 100) topRight:CGPointMake(200, 100) bottomLeft:CGPointMake(60, 200) bottomRight:CGPointMake(240, 200)];

    //LOG(General, "area: %.2f", a);

//    UPLexicon *lexicon = [UPLexicon instanceForLanguage:UPLexiconLanguageEnglish];
//
//    NSString *word1 = @"foo";
//    NSLog(@"contains: %@", [lexicon containsWord:word1] ? @"Y" : @"N");
//
//    NSString *word2 = @"fooa";
//    NSLog(@"contains: %@", [lexicon containsWord:word2] ? @"Y" : @"N");
//
//    NSArray *initialLetters = [lexicon initialLetters];
//    NSMutableString *string = [NSMutableString string];
//    for (NSNumber *n in initialLetters) {
//        char32_t c = n.intValue;
//        NSString *s = UP::ns_str(c);
//        [string appendString:s];
//        [string appendString:@" "];
//    }
//    NSLog(@"initialLetters: %@", string);

//    self.v1 = [[UPShapeView alloc] initWithFrame:CGRectMake(157.5, 100, 72, 90)];
//    self.v1 = [[UPShapeView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    self.v2 = [[UPShapeView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    self.v3 = [[UPShapeView alloc] initWithFrame:CGRectMake(0, 0, 300, 100)];
//    self.v1.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:self.v1];
//    [self.view addSubview:self.v2];
//    [self.view addSubview:self.v3];
  
//    self.image = [UIImage imageNamed:@"up-games-logo-colorizable"];
//    self.imageView = [[UIImageView alloc] initWithImage:self.image];
//    self.imageView.frame = CGRectMake(0, 0, 320, 320);
//    [self.view addSubview:self.imageView];

    

//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
//    [self.view addGestureRecognizer:tap];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self colorize];
//    });

}

//- (void)colorize
//{
//    self.hue++;
//    if (self.hue > 360) {
//        self.hue = 0;
//    }
//
//    UIColor *color = [UIColor colorWithHue:self.hue/360.f saturation:0.8 brightness:0.9 alpha:1.0];
//    UPColor *upcolor = [UPColor colorWithUIColor:color];
//    UIColor *color1 = [[UPColor colorWithHue:self.hue chroma:90 lightness:80 alpha:1.0] rgbColor];
//    UIColor *color2 = [[UPColor colorWithHue:self.hue chroma:60 lightness:60 alpha:1.0] rgbColor];
//    UIColor *color3 = [[UPColor colorWithHue:self.hue chroma:50 lightness:40 alpha:1.0] rgbColor];

//    UIColor *color1 = [[UPColor colorWithHue:self.hue saturation:0.90 value:0.80 alpha:1.0] rgbColor];
//    UIColor *color2 = [[UPColor colorWithHue:self.hue saturation:0.60 value:0.60 alpha:1.0] rgbColor];
//    UIColor *color3 = [[UPColor colorWithHue:self.hue saturation:0.50 value:0.40 alpha:1.0] rgbColor];

//    UIColor *color1 = [UIColor colorWithHue:self.hue/360.0 saturation:0.90 brightness:0.80 alpha:1.0];
//    UIColor *color2 = [UIColor colorWithHue:self.hue/360.0 saturation:0.60 brightness:0.60 alpha:1.0];
//    UIColor *color3 = [UIColor colorWithHue:self.hue/360.0 saturation:0.50 brightness:0.40 alpha:1.0];


//    UIImage *image = [self.image colorizedWith:color];
//    NSLog(@"hue: %.0f : %@", self.hue, color);
//    self.imageView.image = image;
//
//    self.v1.backgroundColor = color1;
//    self.v2.backgroundColor = color2;
//    self.v3.backgroundColor = color3;
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self colorize];
//    });
//}

- (void)viewDidLayoutSubviews
{
//    CGRect imageLayoutRect = CGRectInset(self.view.bounds, 40, 40);
//    self.imageView.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:imageLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalMiddle];
//    [self.imageView layoutWithRule];
//
//    CGRect viewLayoutRect = CGRectInset(self.view.bounds, 40, 100);
//    self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:viewLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalBottom];
//    [self.v1 layoutWithRule];

//    viewLayoutRect = CGRectInset(self.view.bounds, 40, 200);
//    self.v2.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:viewLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalBottom];
//    [self.v2 layoutWithRule];
//
//    viewLayoutRect = CGRectInset(self.view.bounds, 40, 300);
//    self.v3.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:viewLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalBottom];
//    [self.v3 layoutWithRule];
}

//- (void)_handleTap:(UITapGestureRecognizer *)tap
//{
//    if (tap.state != UIGestureRecognizerStateRecognized) {
//        return;
//    }
//
//    CGPoint point = [tap locationInView:self.view];
//    [self.v1 bloopWithDuration:0.4 toPosition:point completion:nil];
//
//
//    static bool flag;
//    if (flag) {
//        CGRect viewLayoutRect = CGRectInset(self.view.bounds, 40, 100);
//        self.v1.layoutRule = [UPLayoutRule layoutRuleWithReferenceFrame:viewLayoutRect hLayout:UPLayoutHorizontalMiddle vLayout:UPLayoutVerticalTop];
//        [self.v1 layoutWithRule];
//    }
//    else {
//        [self.v1 newBloop];
//    }
//    flag = !flag;


//    CGPoint point = [tap locationInView:self.view];
//    [self.v1 bloopWithDuration:1.5 toPosition:point completion:nil];
//}

@end
