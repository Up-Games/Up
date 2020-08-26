//
//  UPUtility.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//

#ifdef __cplusplus

#import <iterator>

namespace UP {

// =========================================================================================================================================
// shifts

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

// =========================================================================================================================================
// to_array
// cribbed from: https://en.cppreference.com/w/cpp/container/array/to_array

namespace detail {

template <class T, std::size_t N, std::size_t... I>
constexpr std::array<std::remove_cv_t<T>, N>
to_array_impl(T (&&a)[N], std::index_sequence<I...>)
{
    return { {std::move(a[I])...} };
}

}

template <class T, std::size_t N>
constexpr std::array<std::remove_cv_t<T>, N> to_array(T (&&a)[N])
{
    return detail::to_array_impl(std::move(a), std::make_index_sequence<N>{});
}

// =========================================================================================================================================

}  // namespace UP

#endif  // __cplusplus
