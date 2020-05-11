//
//  UPLexicon.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LEXICON_H
#define UP_LEXICON_H

#ifdef __cplusplus

#import <mutex>
#import <string>
#import <unordered_set>
#import <vector>

#import <UpKit/UPRandom.h>

typedef enum {
    UPLexiconLanguageEnglish,
} UPLexiconLanguage;

extern const size_t UPLexiconLanguageCount;

namespace UP {

class Lexicon {
public:
    static void set_language(UPLexiconLanguage language);
    static UPLexiconLanguage language();
    static Lexicon &instance();

    Lexicon() {}

    bool contains(const std::u32string &word);
    const std::unordered_set<std::u32string> &words() const { return m_words; }
    std::u32string random_word(Random &) const;

    static bool is_vowel(char32_t c);
    static bool not_vowel(char32_t c) { return !is_vowel(c); }

    static bool is_consonant(char32_t c) { return not_vowel(c); }
    static bool not_consonant(char32_t c) { return is_vowel(c); }
    
private:
    Lexicon(const std::string &);

    std::unordered_set<std::u32string> m_words;
    std::vector<std::u32string> m_word_list;
};

} // namescape UP

#endif  // __cplusplus

#endif  // UP_LEXICON_H
