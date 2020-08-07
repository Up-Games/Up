//
//  UPDialogShared.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>

#import "UPControl+UPSpell.h"
#import "UPDialogShared.h"
#import "UPSharedGameRequest.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;

@interface UPDialogShared ()
@property (nonatomic, readwrite) UPLabel *promptLabel;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPButton *goButton;
@end

@implementation UPDialogShared

+ (UPDialogShared *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogShared *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogShared alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.promptLabel = [UPLabel label];
    self.promptLabel.font = layout.shared_dialog_prompt_font();
    self.promptLabel.textAlignment = NSTextAlignmentCenter;
    self.promptLabel.frame = layout.frame_for(SpellLayout::Role::DialogMessageVerticallyCentered);
    [self addSubview:self.promptLabel];

    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonAlternativeResponse);
    [self addSubview:self.cancelButton];

    self.goButton = [UPTextButton textButton];
    self.goButton.labelString = @"PLAY";
    [self.goButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.goButton.frame = layout.frame_for(SpellLayout::Role::DialogButtonDefaultResponse);
    [self addSubview:self.goButton];

    [self updateThemeColors];

    return self;
}

- (void)updatePromptWithSharedGameRequest:(UPSharedGameRequest *)sharedGameRequest
{
    self.promptLabel.string = [NSString stringWithFormat:@"PLAY A SHARED GAME?\nTHE SCORE TO BEAT IS %d.", sharedGameRequest.score];
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
