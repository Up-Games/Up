//
//  UPGame.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#ifdef __cplusplus

#import <UpKit/UpKit.h>

namespace UP {

class Game {
public:
    static Game &instance() {
        static Game _Instance;
        return _Instance;
    }

    void configure(UPLexiconLanguage language, const GameCode &game_code) {
        m_language = language;
        m_game_code = game_code;
        Lexicon::set_language(m_language);
        m_letter_sequence.set_game_code(m_game_code);
    }

    GameCode game_code() const { return m_game_code; }
    Lexicon &lexicon() { return Lexicon::instance(); }
    LetterSequence &letter_sequence() { return m_letter_sequence; }
    
private:
    Game() : m_language(UPLexiconLanguageEnglish) {}

    UPLexiconLanguage m_language;
    GameCode m_game_code;
    LetterSequence m_letter_sequence;
};

}  // namespace UP

#endif  // __cplusplus

#ifdef __OBJC__

@class UPLexicon;

@interface UPGame : NSObject

@property (nonatomic) UPLexicon *lexicon;

+ (UPGame *)instance;

- (instancetype)init NS_UNAVAILABLE;

@end

#endif  // __OBJC__
