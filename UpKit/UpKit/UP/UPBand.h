//
//  UPBand.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UPKit/UPAssertions.h>

#import <string.h>

namespace UP {

using Band = const char * const;

static constexpr Band BandGameAll = "game.*";
static constexpr Band BandGameDelay = "game.delay";
static constexpr Band BandGameUI = "game.ui";
static constexpr Band BandGameUITile = "game.ui.tile";
static constexpr Band BandGameUITileSlide = "game.ui.tile.slide";
static constexpr Band BandGameUIColor = "game.ui.color";
static constexpr Band BandWordScore = "wordscore";
static constexpr Band BandModeAll = "mode.*";
static constexpr Band BandModeDelay = "mode.delay";
static constexpr Band BandModeUI = "mode.ui";
static constexpr Band BandResumeAll = "resume.*";
static constexpr Band BandResumeDelay = "resume.delay";
static constexpr Band BandResumeUI = "resume.ui";
static constexpr Band BandSettingsUI = "settings.ui";
static constexpr Band BandSettingsAnimationDelay = "settings.animation.delay";
static constexpr Band BandSettingsUpdateDelay = "settings.update.delay";
static constexpr Band BandAboutPlaying = "about.playing";
static constexpr Band BandAboutPlayingDelay = "about.playing.delay";
static constexpr Band BandAboutPlayingUI = "about.playing.ui";
static constexpr Band BandTest = "test";

template <bool B = true> bool band_match(Band pattern, Band band)
{
    bool b = (pattern == band) || (strcmp(pattern, band) == 0);
    if (!b) {
        const char *star = strchr(pattern, '*');
        if (star) {
            size_t len = star - pattern;
            b = strncmp(pattern, band, len) == 0;
        }
    }
    return b == B;
}

}  // namespace UP
