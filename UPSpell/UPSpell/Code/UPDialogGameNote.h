//
//  UPDialogGameNote.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPLabel;

@interface UPDialogGameNote : UIView

@property (nonatomic, readonly) UPLabel *noteLabel;

+ (UPDialogGameNote *)instance;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
