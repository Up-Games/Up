//
//  AVAudioPlayer+UPSpell.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

#import "UPSoundPlayer.h"
#import "UPTunePlayer.h"

@interface AVAudioPlayer (UPSpell)
@property (nonatomic) NSString *filePath;
@property (nonatomic) UPSoundID soundID;
@property (nonatomic) UPTuneID tuneID;
@property (nonatomic) UPTuneSegment segment;
@end

