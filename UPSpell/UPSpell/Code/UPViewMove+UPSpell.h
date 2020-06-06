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

template <class ...Args> UPViewMove *UPViewMoveMake(UIView *view, Args... args) {
    return UPViewMoveMake(view, UP::SpellLayout::Location(std::forward<Args>(args)...));
}
