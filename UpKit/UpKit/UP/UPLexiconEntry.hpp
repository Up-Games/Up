//
//  UPLexiconEntry.hpp
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifndef UP_LEXICON_ENTRY_HPP
#define UP_LEXICON_ENTRY_HPP

#import <set>
#import <vector>

#import <UpKit/json.hpp>

namespace UP {

template <class T> struct LexiconEntry
{
    LexiconEntry() {}
    LexiconEntry(const T &_datum, size_t _count = 0, float _frequency = 0.f) : datum(_datum), count(_count), frequency(_frequency) {}

    T datum;
    mutable size_t count;
    mutable float frequency;
};

template <class T> bool operator==(const LexiconEntry<T> &a, const LexiconEntry<T> &b) {
    return a.datum == b.datum;
}

template <class T> bool operator<(const LexiconEntry<T> &a, const LexiconEntry<T> &b) {
    return a.datum < b.datum;
}

template <class T> inline std::ostream &operator<<(std::ostream &os, const LexiconEntry<T> &e) {
    return os << e.datum << ") " << e.count << ": " << e.frequency;
}

template <class T> using LexiconEntryVector = std::vector<LexiconEntry<T>>;
template <class T> using LexiconEntrySet = std::set<LexiconEntry<T>>;

template <class T> LexiconEntryVector<T> top_entries(const std::set<LexiconEntry<T>> &entries, size_t count)
{
    LexiconEntryVector<T> result;
    std::copy(entries.begin(), entries.end(), std::back_inserter(result));
    std::sort(result.begin(), result.end(), [](const LexiconEntry<T> &a, const LexiconEntry<T> &b) {
        return a.count > b.count;   
    });
    if (result.size() > count) {
        result.resize(count);
    }
    return result;
}

template <class T> void to_json(nlohmann::json &j, const LexiconEntry<T> &e) {
    j = nlohmann::json{{"d", e.datum}, {"f", e.frequency}};
}

template <class T> void from_json(const nlohmann::json &j, LexiconEntry<T> &e) {
    j.at("d").get_to(e.datum);
    j.at("f").get_to(e.frequency);
}

} // namescape UP

#endif // UP_LEXICON_ENTRY_HPP
