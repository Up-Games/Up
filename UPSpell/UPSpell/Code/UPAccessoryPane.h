//
//  UPAccessoryPane.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UpKit/UPContainerView.h>

@interface UPAccessoryPane : UPContainerView

+ (UPAccessoryPane *)pane;

- (void)prepare;
- (void)finish;

@end
