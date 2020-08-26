//
//  ColorChipTableViewCell.m
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UpKit/UPGeometry.h>

#import "ColorChipTableViewCell.h"
#import "ColorChip.h"

@interface ColorChipTableViewCell ()
@property (nonatomic) UIView *selectedView;
@property (nonatomic) UIView *colorView;
@property (nonatomic) UILabel *descriptionLabel;
@end

@implementation ColorChipTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    self.selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.selectedView];

    self.colorView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:self.colorView];

    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descriptionLabel.numberOfLines = 2;
    [self addSubview:self.descriptionLabel];

    return self;
}

- (void)setColorChip:(ColorChip *)colorChip
{
    _colorChip = colorChip;
    self.colorView.backgroundColor = colorChip.color;
    self.descriptionLabel.attributedText = colorChip.attributedDescription;
    [self setNeedsLayout];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.selectedView.backgroundColor = [UIColor blueColor];
    }
    else {
        self.selectedView.backgroundColor = [UIColor clearColor];
    }
}

- (void)layoutSubviews
{
    CGRect bounds = self.bounds;
    CGFloat w = CGRectGetWidth(bounds);
    CGFloat h = CGRectGetHeight(bounds);
    CGRect selectedFrame = CGRectMake(0, 0, 8, 8);
    self.selectedView.layer.cornerRadius = 4;
    self.selectedView.frame = up_rect_centered_y_in_rect(selectedFrame, bounds);
    self.colorView.frame = CGRectInset(CGRectMake(16, 0, (w * 0.2) - 12, h), 0, 2);
    self.descriptionLabel.frame = CGRectMake(w * 0.25, -2, w * 0.75, h);
}

@end
