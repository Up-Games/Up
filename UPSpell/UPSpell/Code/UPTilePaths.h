//
//  TilePaths.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#import <UIKit/UIBezierPath.h>

#if __cplusplus

#import <unordered_map>

#import <UpKit/UPMacros.h>

namespace UP {
    
class TilePaths {
public:
    static TilePaths &create_instance() {
        g_instance = new TilePaths();
        return *g_instance;
    }

    static TilePaths &instance() {
        return *g_instance;
    }

    TilePaths(TilePaths &&) = delete;
    TilePaths(TilePaths const &) = delete;
    void operator=(TilePaths const &) = delete;

    UIBezierPath *tile_path_for_glyph(char32_t c) const {
        const auto it = m_canonical_tile_paths.find(c);
        return it != m_canonical_tile_paths.end() ? it->second : nil;
    }

    UIBezierPath *tile_path_for_score(int score) const {
        char32_t c = score + '0';
        const auto it = m_canonical_tile_paths.find(c);
        return it != m_canonical_tile_paths.end() ? it->second : nil;
    }

    UIBezierPath *tile_path_for_multiplier(int multiplier) const {
        char32_t c = multiplier;
        const auto it = m_canonical_tile_paths.find(c);
        return it != m_canonical_tile_paths.end() ? it->second : nil;
    }

private:
    TilePaths() {
        create_canonical_tile_paths();
    }

    UP_STATIC_INLINE TilePaths *g_instance;

    std::unordered_map<char32_t, __strong UIBezierPath *> m_canonical_tile_paths;
    void create_canonical_tile_paths();
};
    
}  // namespace UP

#endif  // __cplusplus
