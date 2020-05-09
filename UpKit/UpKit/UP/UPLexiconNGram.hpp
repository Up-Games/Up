//
//  UPLexiconNGram.hpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LEXICON_NGRAM_HPP
#define UP_LEXICON_NGRAM_HPP

#import <iostream>
#import <string>

#import "UPRandom.hpp"
#import "UPStringTools.h"
#import "json.hpp"

namespace UP {

template <size_t S> struct LexiconNGram
{
    static constexpr size_t length = S;

    LexiconNGram() {}

    explicit LexiconNGram(const std::u32string &_text) : text(_text), size(text.length()) {
        if (_text.length() > length) {
            text.erase(0, S - 1);
        }
    }

    explicit LexiconNGram(char32_t c) : text(1, c), size(1) {}

    LexiconNGram(const LexiconNGram &o, char32_t c) : text(o.text), size(o.size) {
        push_back(c);
    }

    LexiconNGram shuffled() const {
        LexiconNGram s = *this;
        std::shuffle(s.text.begin(), s.text.end(), Random::gameplay_instance().g());
        return s;
    }

    void push_back(char32_t c) {
        if (size < length) {
            text += c;
            size++;
        }
        else {
            for (size_t i = 0; i < size - 1; i++) {
                text[i] = text[i + 1];
            }
            text[size - 1] = c;
        }
    }

    char32_t at(size_t idx) const {
        return (idx < length) ? text[idx] : 0;
    }

    bool is_complete() const { return text.length() == length; }

    void clear() { text = U""; size = 0; }
    
    std::u32string text = U"";
    size_t size = 0;
};

typedef LexiconNGram<1> Unigram;
typedef LexiconNGram<2> Bigram;
typedef LexiconNGram<3> Trigram;
typedef LexiconNGram<4> Quadgram;

template <size_t S> void to_json(nlohmann::json &j, const LexiconNGram<S> &n) {
    j = nlohmann::json{{"t", cpp_str(n.text)}, {"s", n.size}};
}

template <size_t S> void from_json(const nlohmann::json &j, LexiconNGram<S> &n) {
    j.at("s").get_to(n.size);
    std::string str;
    j.at("t").get_to(str);
    n.text = cpp_u32str(str);
}

template <size_t S> bool operator==(const LexiconNGram<S> &a, const LexiconNGram<S> &b) {
    return a.text == b.text;
}

template <size_t S> bool operator<(const LexiconNGram<S> &a, const LexiconNGram<S> &b) {
    return a.text < b.text;
}

template <size_t S> std::ostream &operator<<(std::ostream &os, const LexiconNGram<S> &n) {
    return os << n.text;
}

} // namescape UP

#endif // UP_LEXICON_NGRAM_HPP
