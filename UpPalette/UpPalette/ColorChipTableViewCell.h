//
//  ColorChipTableViewCell.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorChip;

@interface ColorChipTableViewCell : UITableViewCell
@property (nonatomic, weak) ColorChip *colorChip;
@end
