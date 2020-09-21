//
//  UPDialogGameLink.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UIColor+UP.h>
#import <UpKit/UIView+UP.h>
#import <UpKit/UPBezierPathView.h>
#import <UpKit/UPControl.h>
#import <UpKit/UPGeometry.h>
#import <UpKit/UPLabel.h>
#import <UpKit/UPLogoView.h>

#import "UPControl+UPSpell.h"
#import "UPDialogGameLink.h"
#import "UPGameLink.h"
#import "UPSpellLayout.h"
#import "UPTextButton.h"
#import "UPTextPaths.h"

using UP::SpellLayout;
using Role = SpellLayout::Role;

@interface UPDialogGameLink ()
@property (nonatomic, readwrite) UPLogoView *logoView;
@property (nonatomic, readwrite) UPLabel *wordMarkLabel;
@property (nonatomic, readwrite) UPLabel *titlePromptLabel;
@property (nonatomic, readwrite) UPLabel *detailPromptLabel;
@property (nonatomic, readwrite) UPButton *cancelButton;
@property (nonatomic, readwrite) UPButton *confirmButton;
@property (nonatomic, readwrite) UPButton *helpButton;
@end

@implementation UPDialogGameLink

+ (UPDialogGameLink *)instance
{
    static dispatch_once_t onceToken;
    static UPDialogGameLink *_Instance;
    dispatch_once(&onceToken, ^{
        _Instance = [[UPDialogGameLink alloc] _init];
    });
    return _Instance;
}

- (instancetype)_init
{
    SpellLayout &layout = SpellLayout::instance();
    self = [super initWithFrame:layout.canvas_frame()];

    self.logoView = [UPLogoView logoView];
    [self addSubview:self.logoView];
    self.logoView.frame = CGRectMake(0, 0, 148, 148);
    self.logoView.center = layout.center_for(Role::HeroLogo);

    self.wordMarkLabel = [UPLabel label];
    self.wordMarkLabel.string = @"UP SPELL";
    self.wordMarkLabel.font = layout.word_mark_font();
    self.wordMarkLabel.textAlignment = NSTextAlignmentCenter;
    self.wordMarkLabel.frame = layout.frame_for(Role::HeroWordMark);
    [self addSubview:self.wordMarkLabel];
    
    self.titlePromptLabel = [UPLabel label];
    self.titlePromptLabel.string = @"CHALLENGE!";
    self.titlePromptLabel.font = layout.game_link_title_font();
    self.titlePromptLabel.textAlignment = NSTextAlignmentCenter;
    self.titlePromptLabel.frame = layout.frame_for(Role::GameLinkTitle);
    [self addSubview:self.titlePromptLabel];

    self.detailPromptLabel = [UPLabel label];
    self.detailPromptLabel.font = layout.game_link_detail_font();
    self.detailPromptLabel.textAlignment = NSTextAlignmentCenter;
    self.detailPromptLabel.frame = layout.frame_for(Role::GameLinkDetail);
    [self addSubview:self.detailPromptLabel];

    self.cancelButton = [UPTextButton textButton];
    self.cancelButton.labelString = @"CANCEL";
    [self.cancelButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.cancelButton.frame = layout.frame_for(Role::DialogButtonAlternativeResponse);
    [self addSubview:self.cancelButton];

    self.confirmButton = [UPTextButton textButton];
    self.confirmButton.labelString = @"PLAY";
    [self.confirmButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.confirmButton.frame = layout.frame_for(Role::DialogButtonDefaultResponse);
    [self addSubview:self.confirmButton];

    self.helpButton = [UPButton roundHelpButton];
    [self.helpButton setLabelColorCategory:UPColorCategoryContent forState:UPControlStateNormal];
    self.helpButton.frame = layout.frame_for(Role::DialogHelpButton);
    [self addSubview:self.helpButton];

    [self updateThemeColors];

    return self;
}

- (void)updateWithGameLink:(UPGameLink *)gameLink
{
    if (gameLink.valid) {
        if (gameLink.type == UPGameLinkTypeDuel) {
            self.titlePromptLabel.string = @"DUEL!";
            self.detailPromptLabel.string = [NSString stringWithFormat:@"GAME KEY: %@", gameLink.gameKey.string];
            self.cancelButton.labelString = @"CANCEL";
            self.confirmButton.hidden = NO;
        }
        else {
            self.titlePromptLabel.string = @"CHALLENGE!";
            self.detailPromptLabel.string = [NSString stringWithFormat:@"SCORE TO BEAT: %d", gameLink.score];
            self.cancelButton.labelString = @"CANCEL";
            self.confirmButton.hidden = NO;
        }
    }
    else {
        self.titlePromptLabel.string = @"OOPS!";
        self.detailPromptLabel.string = @"LINK IS BAD. SORRY!";
        self.cancelButton.labelString = @"OK";
        self.confirmButton.hidden = YES;
    }
}

#pragma mark - Theme colors

- (void)updateThemeColors
{
    [self.subviews makeObjectsPerformSelector:@selector(updateThemeColors)];
}

@end
