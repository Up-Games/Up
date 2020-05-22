//
//  ViewController.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UPSpellModel.h"
#import "UPTileView.h"

namespace UP {

using TileViewArray = std::array<UPTileView, TileCount>;

}  // namespace UP

@interface ViewController : UIViewController
@end
