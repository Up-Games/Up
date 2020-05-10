//
//  UPLexicon.mm
//  Copyright © 2020 Up Games. All rights reserved.
//

#import "UPLexicon.h"
#import "UPStringTools.h"

#if __cplusplus

#import <fstream>
#import <iostream>
#import <istream>
#import <ostream>
#import <random>
#import <sstream>
#import <ios>

#import <float.h>
#import <math.h>

#import "json.hpp"

#import "UPLexicon.h"
#import "UPRandom.hpp"
#import "UPStringTools.h"

using nlohmann::json;

const NSUInteger UPLexiconLanguageCount = 1;

namespace UP {

std::mutex Lexicon::g_mutex;

static NSString *up_lexicon_file_name(UPLexiconLanguage language)
{
    switch (language) {
        case UPLexiconLanguageEnglish:
            return @"en-lexicon";
    }
}

static std::string read_utf8_string_file(const std::string &filename)
{
    std::string contents;
    std::ifstream in(filename.c_str(), std::ios::in | std::ios::binary);
    if (in) {
        in.seekg(0, std::ios::end);
        contents.resize(in.tellg());
        in.seekg(0, std::ios::beg);
        in.read(&contents[0], contents.size());
        in.close();
    }
    return contents;
}

void write_file(const std::string &file, const std::string &contents)
{
    std::ofstream os(file, std::ios::trunc);
    if (os.fail()) {
        return;
    }
    os << contents;
    os.close();
}

Lexicon &Lexicon::instance_for_language(UPLexiconLanguage language)
{
    static Lexicon *lexicons[UPLexiconLanguageCount];
    std::lock_guard<std::mutex> guard(Lexicon::g_mutex);
    size_t idx = (size_t)language;
    if (!lexicons[idx]) {
        NSBundle *upkitBundle = [NSBundle bundleForClass:[UPLexicon class]];
        NSString *fileName = up_lexicon_file_name(language);
        NSString *wordsFilePath = [upkitBundle pathForResource:fileName ofType:@"txt"];
        NSString *metadataFilePath = [upkitBundle pathForResource:fileName ofType:@"json"];
        lexicons[idx] = new Lexicon(cpp_str(wordsFilePath), cpp_str(metadataFilePath));
    }
    return *lexicons[idx];
}

Lexicon::Lexicon(const std::string &words_file_path, const std::string &metadata_file_path)
    : m_words_file_path(words_file_path), m_metadata_file_path(metadata_file_path)
{
    if (load_words()) {
        if (!load_frequencies()) {
            calculate_frequencies();
            store_frequencies();
        }
    }
}

bool Lexicon::contains(const std::u32string &word)
{
    return m_words.find(word) != m_words.end();
}

bool Lexicon::load_words()
{
    m_words.clear();
    if (m_words_file_path.length() == 0) {
        return false;
    }
    std::string contents(read_utf8_string_file(m_words_file_path));
    if (contents.length() == 0) {
        return false;
    }
    std::istringstream iss(contents);
    for (std::string line; std::getline(iss, line); ) {
        m_words.emplace(cpp_u32str(line));
    }
    return true;
}

bool Lexicon::load_frequencies()
{
    m_letter_frequencies.clear();
    m_top_bigrams.clear();
    m_top_trigrams.clear();
    m_top_quadgrams.clear();
    
    m_top_bigrams_sum = 0;
    m_top_trigrams_sum = 0;
    m_top_quadgrams_sum = 0;

    std::ifstream i(m_metadata_file_path);
    if (!i.is_open()) {
        return false;
    }
    
    json j;
    i >> j;

    auto fv = j["letter_frequencies"];
    for (auto e : fv) {
        m_letter_frequencies.emplace(e.get<LexiconEntry<char32_t>>());
    }

    auto bv = j["top_bigrams"];
    for (auto e : bv) {
        m_top_bigrams.push_back(e.get<LexiconEntry<Bigram>>());
        m_top_bigrams_sum += m_top_bigrams.back().frequency;
    }

    auto tv = j["top_trigrams"];
    for (auto e : tv) {
        m_top_trigrams.push_back(e.get<LexiconEntry<Trigram>>());
        m_top_trigrams_sum += m_top_trigrams.back().frequency;
    }

    auto qv = j["top_quadgrams"];
    for (auto e : qv) {
        m_top_quadgrams.push_back(e.get<LexiconEntry<Quadgram>>());
        m_top_quadgrams_sum += m_top_quadgrams.back().frequency;
    }

    return true;
}

void Lexicon::store_frequencies() const
{
    if (m_metadata_file_path.length() == 0) {
        return;
    }
    
    json j;
    j["letter_frequencies"] = m_letter_frequencies;
    j["top_bigrams"] = m_top_bigrams;
    j["top_trigrams"] = m_top_trigrams;
    j["top_quadgrams"] = m_top_quadgrams;

    write_file(m_metadata_file_path, j.dump());
}

void Lexicon::calculate_frequencies()
{
    LexiconEntrySet<Bigram> bigram_frequencies;
    LexiconEntrySet<Trigram> trigram_frequencies;
    LexiconEntrySet<Quadgram> quadgram_frequencies;

    Bigram bigram;
    Trigram trigram;
    Quadgram quadgram;

    for (const auto &word : m_words) {
        bigram.clear();
        trigram.clear();
        quadgram.clear();
        
        size_t length = word.size();
        for (int i = 0; i < length; i++) {
            char c = toupper(word[i]);
            if (!isalpha(c)) {
                continue;
            }
            
            // update letter frequencies
            {
                auto letter_it = m_letter_frequencies.find(c);
                if (letter_it == m_letter_frequencies.end()) {
                    LexiconEntry<char32_t> entry(c, 1);
                    m_letter_frequencies.insert(entry);
                }
                else {
                    letter_it->count++;
                }
            }

            // update bigram frequencies
            bigram.push_back(c);
            if (bigram.is_complete()) {
                auto it = bigram_frequencies.find(bigram);
                if (it == bigram_frequencies.end()) {
                    LexiconEntry<Bigram> entry(bigram, 1);
                    bigram_frequencies.insert(entry);
                }
                else {
                    it->count++;
                }
            }

            // update trigram frequencies
            trigram.push_back(c);
            if (trigram.is_complete()) {
                auto it = trigram_frequencies.find(trigram);
                if (it == trigram_frequencies.end()) {
                    LexiconEntry<Trigram> entry(trigram, 1);
                    trigram_frequencies.insert(entry);
                }
                else {
                    it->count++;
                }
            }
            
            // update quadgram frequencies
            quadgram.push_back(c);
            if (quadgram.is_complete()) {
                auto it = quadgram_frequencies.find(quadgram);
                if (it == quadgram_frequencies.end()) {
                    LexiconEntry<Quadgram> entry(quadgram, 1);
                    quadgram_frequencies.insert(entry);
                }
                else {
                    it->count++;
                }
            }
            
        }
    }

    // compute letter frequencies
    size_t total_chars = 0;
    for (auto entry : m_letter_frequencies) {
        total_chars += entry.count;
    }
    for (auto &entry : m_letter_frequencies) {
        entry.frequency = (float)entry.count / total_chars;
    }

    // compute bigram frequencies
    size_t total_bigrams = 0;
    for (const auto &entry : bigram_frequencies) {
        total_bigrams += entry.count;
    }
    for (auto &entry : bigram_frequencies) {
        entry.frequency = (float)entry.count / total_bigrams;
    }
    m_top_bigrams = top_entries(bigram_frequencies, TopBigramsCount);
    m_top_bigrams_sum = 0;
    for (const auto &entry : m_top_bigrams) {
        m_top_bigrams_sum += entry.frequency;
    }

    // compute trigram frequencies
    size_t total_trigrams = 0;
    for (const auto &entry : trigram_frequencies) {
        total_trigrams += entry.count;
    }
    for (auto &entry : trigram_frequencies) {
        entry.frequency = (float)entry.count / total_trigrams;
    }
    m_top_trigrams = top_entries(trigram_frequencies, TopTrigramsCount);
    m_top_trigrams_sum = 0;
    for (const auto &entry : m_top_trigrams) {
        m_top_trigrams_sum += entry.frequency;
    }

    // compute quadgram frequencies
    size_t total_quadgrams = 0;
    for (const auto &entry : quadgram_frequencies) {
        total_quadgrams += entry.count;
    }
    for (auto &entry : quadgram_frequencies) {
        entry.frequency = (float)entry.count / total_quadgrams;
    }
    m_top_quadgrams = top_entries(quadgram_frequencies, TopQuadgramsCount);
    m_top_quadgrams_sum = 0;
    for (const auto &entry : m_top_quadgrams) {
        m_top_quadgrams_sum += entry.frequency;
    }
}

char32_t Lexicon::random_letter() const
{
    static int count = 0;
    count++;
    float f = Random::gameplay_instance().unit();
    float t = 0;
    for (const auto &entry : m_letter_frequencies) {
        t += entry.frequency;
        if (f <= t) {
            return entry.datum;
        }
    }
    return '-';
}

char32_t Lexicon::random_consonant() const
{
    while (1) {
        char32_t c = random_letter();
        if (is_consonant(c)) {
            return c;
        }
    }
    return 'S';
}

char32_t Lexicon::random_vowel() const
{
    while (1) {
        char c = random_letter();
        if (is_vowel(c)) {
            return c;
        }
    }
    return 'E';
}

bool Lexicon::is_vowel(char32_t c) {
    switch (c) {
        case U'A':
        case U'E':
        case U'I':
        case U'O':
        case U'U':
            return true;
    }
    return false;
}

Unigram Lexicon::random_unigram() const
{
    return Unigram(random_letter());
}

Bigram Lexicon::random_bigram() const
{
    float f = Random::gameplay_instance().unit() * m_top_bigrams_sum;
    float t = 0;
    for (const auto &entry : m_top_bigrams) {
        t += entry.frequency;
        if (f <= t) {
            return entry.datum;
        }
    }
    return Bigram(U"ET");
}

Trigram Lexicon::random_trigram() const
{
    float f = Random::gameplay_instance().unit() * m_top_trigrams_sum;
    float t = 0;
    for (const auto &entry : m_top_trigrams) {
        t += entry.frequency;
        if (f <= t) {
            return entry.datum;
        }
    }
    return Trigram(U"ING");
}

Quadgram Lexicon::random_quadgram() const
{
    float f = Random::gameplay_instance().unit() * m_top_quadgrams_sum;
    float t = 0;
    for (const auto &entry : m_top_quadgrams) {
        t += entry.frequency;
        if (f <= t) {
            return entry.datum;
        }
    }
    return Quadgram(U"TION");
}

} // namespace UP

#endif  // __cplusplus

// =========================================================================================================================================

@interface UPLexicon ()
@end

@implementation UPLexicon

+ (UPLexicon *)instanceForLanguage:(UPLexiconLanguage)language
{
    return [[UPLexicon alloc] initForLanguage:language];
}

- (instancetype)initForLanguage:(UPLexiconLanguage)language
{
    self = [super init];
    self.language = language;
    return self;
}

- (BOOL)containsWord:(NSString *)word
{
    UP::Lexicon &lexicon = UP::Lexicon::instance_for_language(self.language);
    return lexicon.contains(UP::cpp_u32str(word));
}

@end
