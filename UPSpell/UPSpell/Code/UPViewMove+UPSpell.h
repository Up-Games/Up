//
//  UPViewMove+UPSpell.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UpKit/UPViewMove.h>

#import "UPSpellLayout.h"

UP_STATIC_INLINE UPViewMove *UPViewMoveMake(UIView *view, const UP::SpellLayout::Location &location) {
    UP::SpellLayout &layout = UP::SpellLayout::instance();
    return [UPViewMove view:view beginning:view.center destination:layout.center_for(location)];
}

UP_STATIC_INLINE UPViewMove *UPViewMoveMake(UIView *view,
                                            const UP::SpellLayout::Location &beginningLocation,
                                            const UP::SpellLayout::Location &destinationLocation) {
    UP::SpellLayout &layout = UP::SpellLayout::instance();
    CGPoint beginning = layout.center_for(beginningLocation);
    CGPoint destination = layout.center_for(destinationLocation);
    return [UPViewMove view:view beginning:beginning destination:destination];
}
