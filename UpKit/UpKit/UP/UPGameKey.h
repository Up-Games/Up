//
//  UPGameKey.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#if __OBJC__
#import <Foundation/Foundation.h>
#endif  // __OBJC__

#if __cplusplus

#import <string>

#import <UPKit/UPMacros.h>
#import <UPKit/UPRandom.h>

namespace UP {

class GameKey {
public:
    static constexpr size_t StringLength = 8;
    static constexpr size_t Permutations = 26 * 26 * 26 * 10 * 10 * 10 * 10;  // 175,760,000

    static constexpr const char *DefaultCharString = "AAA-0000";
    static constexpr uint32_t DefaultValue = 0;
    static constexpr size_t MaxValue = Permutations - 1;

    GameKey() : m_string(DefaultCharString), m_value(DefaultValue) {}
    GameKey(const std::string &str) : m_string(validate(str)), m_value(parse_string(m_string)) {}
    GameKey(uint32_t value) : m_string(format_string(validate(value))), m_value(validate(value)) {}

    static GameKey random() {
        return GameKey(Random::instance().uint32_less_than(Permutations));
    }

    static bool is_well_formed(const std::string &str) {
        return validate(str) == str;
    }
    
    static bool is_well_formed(uint32_t value) {
        return value < Permutations;
    }
    
    uint32_t value() const { return m_value; }
    std::string string() const { return m_string; }

private:
    static constexpr uint32_t Letter1Factor = 26 * 26; // big-endian ;-)
    static constexpr uint32_t Letter2Factor = 26;
    static constexpr uint32_t Letter3Factor = 1;
    static constexpr uint32_t Number1Factor = 1000;
    static constexpr uint32_t Number2Factor = 100;
    static constexpr uint32_t Number3Factor = 10;
    static constexpr uint32_t Number4Factor = 1;

    static constexpr uint32_t Letter1Max = Letter1Factor * 'Z';
    static constexpr uint32_t Letter2Max = Letter2Factor * 'Z';
    static constexpr uint32_t Letter3Max = Letter3Factor * 'Z';
    static constexpr uint32_t LetterSpaceMax = 26 * 26 * 26;

    static constexpr char validate_letter(char c) {
        if (c >= 'a' && c <= 'z') {
            return c - 32;
        }
        else if (c < 'A' || c > 'Z') {
            return 'A';
        }
        return c;
    }

    static constexpr char validate_number(char c) {
        if (c < '0' || c > '9') {
            return '0';
        }
        return c;
    }

    static std::string validate(const std::string &str) {
        std::string result = str;
        if (str.length() != StringLength) {
            result = DefaultCharString;
        }
        result[0] = validate_letter(result[0]);
        result[1] = validate_letter(result[1]);
        result[2] = validate_letter(result[2]);
        result[3] = '-';
        result[4] = validate_number(result[4]);
        result[5] = validate_number(result[5]);
        result[6] = validate_number(result[6]);
        result[7] = validate_number(result[7]);
        return result;
    }

    static constexpr uint32_t validate(uint32_t value) {
        return value >= Permutations ? 0 : value;
    }

    static constexpr char letter_for_value(uint32_t rem, uint32_t letter_factor, uint32_t letter_max) {
        uint32_t n = rem % 26;
        return n + 'A';
    }

    static std::string format_string(uint32_t value) {
        uint32_t rem = value;
        char chars[StringLength + 1];
        char c;
        c = rem % 10; rem /= 10; chars[7] = c + '0';
        c = rem % 10; rem /= 10; chars[6] = c + '0';
        c = rem % 10; rem /= 10; chars[5] = c + '0';
        c = rem % 10; rem /= 10; chars[4] = c + '0';
        chars[3] = '-'; // dash at index 3
        c = rem % 26; rem /= 26; chars[2] = c + 'A';
        c = rem % 26; rem /= 26; chars[1] = c + 'A';
        c = rem % 26; rem /= 26; chars[0] = c + 'A';
        chars[StringLength] = '\0';
        return std::string(chars);
    }

    static constexpr uint32_t value_for_letter(char c) {
        return c - 'A';
    }

    static constexpr uint32_t value_for_number(char c) {
        return c - '0';
    }

    // Must be in the form ABC-1234, i.e. three letters, dash, four numbers
    // Permutations: 175,760,000.
    static uint32_t parse_string(const std::string &str) {
        uint32_t value = 0;

        // three letters
        value += value_for_letter(str[0]) * Letter1Factor;
        value += value_for_letter(str[1]) * Letter2Factor;
        value += value_for_letter(str[2]) * Letter3Factor;
        value *= 10000;
        // dash at index 3
        value += value_for_number(str[4]) * Number1Factor;
        value += value_for_number(str[5]) * Number2Factor;
        value += value_for_number(str[6]) * Number3Factor;
        value += value_for_number(str[7]) * Number4Factor;
        return value;
    }

    std::string m_string;
    uint32_t m_value;
};

UP_STATIC_INLINE bool operator==(const GameKey &a, const GameKey &b) { return a.value() == b.value(); }
UP_STATIC_INLINE bool operator!=(const GameKey &a, const GameKey &b) { return !(a == b); }

}  // namespace UP

#endif  // __cplusplus

// =========================================================================================================================================

#if __OBJC__
@interface UPGameKey : NSObject <NSSecureCoding>

@property (class, readonly) BOOL supportsSecureCoding;

@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) uint32_t value;

+ (UPGameKey *)randomGameKey;
+ (UPGameKey *)gameKeyWithString:(NSString *)string;
+ (UPGameKey *)gameKeyWithValue:(uint32_t)value;

- (instancetype)initWithString:(NSString *)string;
- (instancetype)initWithValue:(uint32_t)value;

@end
#endif  // __OBJC__
