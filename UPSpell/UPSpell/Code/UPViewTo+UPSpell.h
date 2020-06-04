//
//  UPViewTo+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPViewTo.h>

#import "UPSpellLayout.h"

UP_STATIC_INLINE UPViewTo *UPViewToMake(UIView *view, const UP::SpellLayout::Location &location) {
    UP::SpellLayout &layout = UP::SpellLayout::instance();
    return [UPViewTo view:view destination:layout.center_for(location)];
}
