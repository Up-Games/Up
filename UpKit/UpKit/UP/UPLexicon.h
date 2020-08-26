//
//  UPLexicon.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#ifdef __cplusplus

#import <string>
#import <unordered_map>
#import <vector>

#import <UpKit/UPMacros.h>
#import <UpKit/UPRandom.h>

typedef enum {
    UPLexiconLanguageEnglish,
} UPLexiconLanguage;

extern const size_t UPLexiconLanguageCount;

namespace UP {

class Lexicon {
public:
    struct Lookup {
        bool found;
        std::u32string_view string;
    };

    static void set_language(UPLexiconLanguage language);
    static UPLexiconLanguage language();
    static Lexicon &instance();
    static Lexicon &fixed_instance();

    Lexicon() {}

    bool contains(const std::u32string &key) {
        return m_lookup.find(key) != m_lookup.end();
    }
    
    Lookup lookup(const std::u32string &key) {
        const auto it = m_lookup.find(key);
        if (it == m_lookup.end()) {
            return { false, std::u32string_view() };
        }
        else {
            return { true, it->second };
        }
    }
    
    std::u32string random_key(Random &r) const {
        uint32_t idx = r.uint32_between(0, (uint32_t)m_keys.size());
        return std::u32string(m_keys[idx]);
    }

    static bool is_vowel(char32_t c);
    static bool not_vowel(char32_t c) { return !is_vowel(c); }

    static bool is_consonant(char32_t c) { return not_vowel(c); }
    static bool not_consonant(char32_t c) { return is_vowel(c); }
    
private:
    Lexicon(std::u32string &&);

    std::u32string m_contents;
    std::unordered_map<std::u32string_view, std::u32string_view> m_lookup;
    std::vector<std::u32string_view> m_keys;
};

} // namescape UP

#endif  // __cplusplus
