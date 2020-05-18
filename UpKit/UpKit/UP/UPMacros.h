//
//  UPMacros.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#define UP_STATIC_CONST_EXPLICIT static const

#define UP_STATIC_CONSTEXPR_EXPLICIT static constexpr
#define UP_STATIC_CONSTEXPR UP_STATIC_CONSTEXPR_EXPLICIT

#define UP_STATIC_INLINE_CONSTEXPR_EXPLICIT static inline constexpr
#define UP_STATIC_INLINE_EXPLICIT static inline
#define UP_STATIC_INLINE UP_STATIC_INLINE_EXPLICIT

#if __cplusplus
#define UP_STATIC_CONST UP_STATIC_CONSTEXPR_EXPLICIT
#else
#define UP_STATIC_CONST UP_STATIC_CONST_EXPLICIT
#endif  // __cplusplus

#if __cplusplus
#define UP_STATIC_INLINE_CONST UP_STATIC_INLINE_CONSTEXPR_EXPLICIT
#else
#define UP_STATIC_INLINE_CONST UP_STATIC_INLINE_EXPLICIT
#endif  // __cplusplus
