//
//  UPAccessoryPane.mm
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import "UPAccessoryPane.h"
#import "UPSpellLayout.h"

using UP::SpellLayout;

@implementation UPAccessoryPane

+ (UPAccessoryPane *)pane
{
    return [[self alloc] initWithFrame:SpellLayout::instance().screen_bounds()];
}

- (void)prepare
{
}

@end
