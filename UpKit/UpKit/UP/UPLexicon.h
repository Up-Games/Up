//
//  UPLexicon.h
//  Copyright © 2020 Up Games. All rights reserved.
//

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

#import <UpKit/UPLexiconEntry.hpp>
#import <UpKit/UPLexiconNGram.hpp>

typedef NS_ENUM(NSInteger, UPLexiconLanguage) {
    UPLexiconLanguageEnglish,
};

extern const NSUInteger UPLexiconLanguageCount;

namespace UP {

class Lexicon {
public:
    enum { TopEntriesCount = 2000 };

    Lexicon() {}
    Lexicon(const std::string &words_file_path, const std::string &metadata_file_path = "");

    static Lexicon &instance_for_language(UPLexiconLanguage language);

    bool contains(const std::u32string &word);
    const std::unordered_set<std::u32string> &words() const { return m_words; }
    const std::set<LexiconEntry<char32_t>> &letter_frequencies() const { return m_letter_frequencies; }
    const LexiconEntryVector<Bigram> &top_bigrams() const { return m_top_bigrams; }
    const LexiconEntryVector<Trigram> &top_trigrams() const { return m_top_trigrams; }
    const LexiconEntryVector<Quadgram> &top_quadgrams() const { return m_top_quadgrams; }
    char32_t random_letter() const;
    char32_t random_vowel() const;
    char32_t random_consonant() const;
    Unigram random_unigram() const;
    Bigram random_bigram() const;
    Trigram random_trigram() const;
    Quadgram random_quadgram() const;

    static bool is_vowel(char32_t c);
    static bool not_vowel(char32_t c) { return !is_vowel(c); }

    static bool is_consonant(char32_t c) { return not_vowel(c); }
    static bool not_consonant(char32_t c) { return is_vowel(c); }
    
private:
    void calculate_frequencies();
    bool load_words();
    bool load_frequencies();
    void store_frequencies() const;

    std::string m_words_file_path;
    std::string m_metadata_file_path;
    std::unordered_set<std::u32string> m_words;
    LexiconEntrySet<char32_t> m_letter_frequencies;
    LexiconEntryVector<Bigram> m_top_bigrams;
    LexiconEntryVector<Trigram> m_top_trigrams;
    LexiconEntryVector<Quadgram> m_top_quadgrams;
    float m_top_bigrams_sum;
    float m_top_trigrams_sum;
    float m_top_quadgrams_sum;
    
    static std::mutex g_mutex;
};

} // namescape UP

#endif  // __cplusplus

@interface UPLexicon : NSObject

@property (nonatomic) UPLexiconLanguage language;

+ (UPLexicon *)instanceForLanguage:(UPLexiconLanguage)language;

- (instancetype)init NS_UNAVAILABLE;

- (BOOL)containsWord:(NSString *)word;

@end
