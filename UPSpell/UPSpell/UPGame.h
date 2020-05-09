//
//  UPGame.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

namespace UP {

class Game {
public:
    static Game &instance() {
        static Game _Instance;
        return _Instance;
    }

    void set_language(UPLexiconLanguage language) { m_language = language; }
    Lexicon &lexicon() const { return Lexicon::instance_for_language(m_language); }

private:
    Game() : m_language(UPLexiconLanguageEnglish) {}

    UPLexiconLanguage m_language;
};

}  // namespace UP

#endif  // __cplusplus

#if __OBJC__

@class UPLexicon;

@interface UPGame : NSObject

@property (nonatomic) UPLexicon *lexicon;

+ (UPGame *)instance;

- (instancetype)init NS_UNAVAILABLE;

@end

#endif  // __OBJC__
