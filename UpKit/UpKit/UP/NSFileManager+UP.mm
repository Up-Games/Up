//
//  NSFileManager+UP.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "NSFileManager+UP.h"

@implementation NSFileManager (UP)

- (NSString *)documentsDirectoryPathWithFileName:(NSString *)fileName
{
    NSString *path = nil;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *possibleURLs = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    if (possibleURLs.count > 0) {
        NSURL *documentDirectoryURL = [possibleURLs objectAtIndex:0];
        NSURL *fileURL = [documentDirectoryURL URLByAppendingPathComponent:fileName];
        path = [NSString stringWithUTF8String:[[fileURL path] fileSystemRepresentation]];
    }
    return path;
}

@end
