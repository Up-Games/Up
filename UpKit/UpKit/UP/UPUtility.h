//
//  UPUtility.h
//  Copyright © 2020 Up Games. All rights reserved.
//

#ifdef __cplusplus

#import <iterator>

namespace UP {

template <class I>
using difference_type_t = typename std::iterator_traits<I>::difference_type;

template <class I>
constexpr difference_type_t<I> bounded_advance(I &i, difference_type_t<I> n, I const bound)
{
    for (; n < 0 && i != bound; ++n, void(--i)) { ; }
    for (; n > 0 && i != bound; --n, void(++i)) { ; }
    return n;
}

template <class ForwardIt>
ForwardIt shift_left(ForwardIt first, ForwardIt last, difference_type_t<ForwardIt> n)
{
    if (n <= 0) {
        return last;
    }

    auto mid = first;
    if (bounded_advance(mid, n, last)) {
        return first;
    }

    return std::move(std::move(mid), std::move(last), std::move(first));
}

template <class ForwardIt>
ForwardIt shift_right(ForwardIt first, ForwardIt last, difference_type_t<ForwardIt> n)
{
    if (n <= 0) {
        return first;
    }

    auto mid = last;
    if (bounded_advance(mid, -n, first)) {
        return last;
    }
    
    return std::move_backward(std::move(first), std::move(mid), std::move(last));
}

}  // namespace UP

#endif  // __cplusplus
