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

// UNLIKELY
#if !defined(UNLIKELY)
#define UNLIKELY(x) __builtin_expect(!!(x), 0)
#endif

#if !defined(UNLIKELY)
#define UNLIKELY(x) (x)
#endif

// LIKELY
#if !defined(LIKELY)
#define LIKELY(x) __builtin_expect(!!(x), 1)
#endif

#if !defined(LIKELY)
#define LIKELY(x) (x)
#endif

#if __OBJC__
#define UP_ENCODE(_Coder_, _Item_, _EncodeType_) \
    [_Coder_ encode##_EncodeType_:self._Item_ forKey:NSStringFromSelector(@selector(_Item_))]
#define UP_ENCODE_T(_Coder_, _ItemType_, _Item_, _EncodeType_) \
[_Coder_ encode##_EncodeType_:static_cast<_ItemType_>(self._Item_) forKey:NSStringFromSelector(@selector(_Item_))]

#define UP_DECODE(_Coder_, _Item_, _DecodeType_) \
    self._Item_ = [_Coder_ decode##_DecodeType_##ForKey:NSStringFromSelector(@selector(_Item_))]
#define UP_DECODE_T(_Coder_, _ItemType_, _Item_, _DecodeType_) \
    self._Item_ = static_cast<_ItemType_>([_Coder_ decode##_DecodeType_##ForKey:NSStringFromSelector(@selector(_Item_))])
#define UP_DECODE_OBJECT(_Coder_, _ObjectType_, _Item_) \
    self._Item_ = ([_Coder_ decodeObjectOfClass:[_ObjectType_ class] forKey:NSStringFromSelector(@selector(_Item_))])
#endif  // __OBJC__

