//
//  UPSpellExtrasPaneShare.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAccessoryPane.h"

@interface UPSpellExtrasPaneShare : UPAccessoryPane

+ (UPSpellExtrasPaneShare *)pane;

- (void)shareSheetDismissed;

@end
