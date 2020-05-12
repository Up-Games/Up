//
//  UPLetterTileContext.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifdef __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#ifdef __cplusplus

#import <iostream>

#import <UpKit/UPGameCode.h>
#import <UpKit/UPLetterTileSequence.h>
#import <UpKit/UPLexicon.h>

namespace UP {

class LetterTileContext {
public:
    LetterTileContext() : m_language(UPLexiconLanguageEnglish) {}

    void configure(UPLexiconLanguage language, const GameCode &game_code) {
        m_language = language;
        m_game_code = game_code;
        Lexicon::set_language(m_language);
        m_letter_sequence.set_game_code(m_game_code);
    }

    GameCode game_code() const { return m_game_code; }
    Lexicon &lexicon() { return Lexicon::instance(); }
    LetterTileSequence &letter_sequence() { return m_letter_sequence; }
    
private:
    UPLexiconLanguage m_language;
    GameCode m_game_code;
    LetterTileSequence m_letter_sequence;
};

}  // namespace UP

#endif  // __cplusplus
