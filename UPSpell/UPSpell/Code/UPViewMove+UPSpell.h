//
//  UPViewMove+UPSpell.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
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

UP_STATIC_INLINE UPViewMove *UPViewVariableSizeMoveMake(UIView *view, const UP::SpellLayout::Location &location) {
    UP::SpellLayout &layout = UP::SpellLayout::instance();
    [view sizeToFit];
    CGPoint destinationPoint = layout.center_for(location);
    CGSize defaultSize = layout.size_for(location);
    CGSize effectiveSize = view.bounds.size;
    destinationPoint.x += ((effectiveSize.width - defaultSize.width) * 0.5);
    destinationPoint.y += ((effectiveSize.height - defaultSize.height) * 0.5);
    return [UPViewMove view:view beginning:view.center destination:destinationPoint];
}

template <class ...Args> UPViewMove *UPViewVariableSizeMoveMake(UIView *view, Args... args) {
    return UPViewVariableSizeMoveMake(view, UP::SpellLayout::Location(std::forward<Args>(args)...));
}
