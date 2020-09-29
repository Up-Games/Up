//
//  UPSpellExtrasPaneHowTo.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAccessoryPane.h"

@interface UPSpellExtrasPaneHowTo : UPAccessoryPane

+ (UPSpellExtrasPaneHowTo *)pane;

- (void)commonConfigure;
- (void)configureForFullScreenTutorial;
- (void)startTutorial;
- (void)finish;

@end
