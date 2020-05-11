//
//  UPLexicon.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LEXICON_H
#define UP_LEXICON_H

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

#import <map>
#import <mutex>
#import <set>
#import <string>
#import <unordered_set>
#import <vector>

#import <UpKit/UPRandom.hpp>

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
    Lexicon(const std::string &words_file_path);

    bool load_words();

    std::string m_words_file_path;
    std::unordered_set<std::u32string> m_words;
    std::vector<std::u32string> m_word_list;
    
    static std::mutex g_mutex;
};

} // namescape UP

#endif  // __cplusplus


#if __OBJC__

@interface UPLexicon : NSObject

@property (nonatomic) UPLexiconLanguage language;

//+ (UPLexicon *)instanceForLanguage:(UPLexiconLanguage)language;
//
//- (instancetype)init NS_UNAVAILABLE;
//
//- (BOOL)containsWord:(NSString *)word;

@end

#endif  // __OBJC__


#endif // UP_LEXICON_H
