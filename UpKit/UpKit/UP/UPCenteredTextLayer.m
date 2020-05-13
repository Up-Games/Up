//
//  UPCenteredTextLayer.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPCenteredTextLayer.h"

@implementation UPCenteredTextLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat height = self.bounds.size.height;
    CGFloat fontSize = self.fontSize;
    CGFloat dy = (height - fontSize) / 2 - (fontSize / 10);
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0, dy);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

@end
