//
//  UPAssertions.h
//  Copyright © 2020 Ken Kocienda. All rights reserved.
//
//  Based (substantially) on Assertions.h from WebKit.
//
/*
 * Copyright (C) 2003, 2006, 2007, 2013 Apple Inc.  All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY APPLE INC. ``AS IS'' AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL APPLE INC. OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import <stdarg.h>
#import <stdlib.h>

#ifdef NDEBUG
#define ASSERTIONS_DISABLED_DEFAULT 1
#else
#define ASSERTIONS_DISABLED_DEFAULT 0
#endif

#ifndef ASSERT_DISABLED
#define ASSERT_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#ifndef ASSERT_MSG_DISABLED
#define ASSERT_MSG_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#ifndef ASSERT_ARG_DISABLED
#define ASSERT_ARG_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#ifndef FATAL_DISABLED
#define FATAL_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#ifndef ERROR_DISABLED
#define ERROR_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#ifndef LOG_DISABLED
#define LOG_DISABLED ASSERTIONS_DISABLED_DEFAULT
#endif

#if !defined(NO_RETURN)
#define NO_RETURN __attribute((__noreturn__))
#endif

#define NO_RETURN_DUE_TO_CRASH NO_RETURN

#ifndef UP_ALWAYS_INLINE
#ifdef NDEBUG
#define UP_ALWAYS_INLINE inline __attribute__ ((__visibility__("hidden"), __always_inline__))
#else
#define UP_ALWAYS_INLINE inline
#endif
#endif

#ifndef UP_NEVER_INLINE
#ifdef NDEBUG
#define UP_NEVER_INLINE __attribute__ ((__visibility__("default"), noinline))
#else
#define UP_NEVER_INLINE
#endif
#endif

#ifdef __cplusplus
extern "C" {
#endif

typedef enum { UPLogChannelOff, UPLogChannelOn } UPLogChannelState;

typedef struct {
    UPLogChannelState state;
    const char *name;
} UPLogChannel;

#ifndef LOG_CHANNEL_PREFIX
#define LOG_CHANNEL_PREFIX Log
#endif

#define LOG_CHANNEL(name) JOIN_LOG_CHANNEL_WITH_PREFIX(LOG_CHANNEL_PREFIX, name)
#define LOG_CHANNEL_ADDRESS(name) &LOG_CHANNEL(name),
#define JOIN_LOG_CHANNEL_WITH_PREFIX(prefix, channel) JOIN_LOG_CHANNEL_WITH_PREFIX_LEVEL_2(prefix, channel)
#define JOIN_LOG_CHANNEL_WITH_PREFIX_LEVEL_2(prefix, channel) prefix ## channel

#define DECLARE_LOG_CHANNEL(name) \
    extern UPLogChannel LOG_CHANNEL(name);

#if !defined(DEFINE_LOG_CHANNEL)
#define DEFINE_LOG_CHANNEL(name) \
    UPLogChannel LOG_CHANNEL(name) = { UPLogChannelOff, #name };
#endif

void UPLogEnable(UPLogChannel *);
void UPLogDisable(UPLogChannel *);
void UPReportNotImplementedYet(const char *file, int line, const char *function);
void UPReportAssertionFailure(const char *file, int line, const char *function, const char *assertion);
void UPReportAssertionFailureWithMessage(const char *file, int line, const char *function, const char *assertion, const char *format, ...);
void UPReportArgumentAssertionFailure(const char *file, int line, const char *function, const char *argName, const char *assertion);
void UPReportFatalError(const char *file, int line, const char *function, const char *format, ...);
void UPReportError(const char *file, int line, const char *function, const char *format, ...);
void UPLogVerbose(const char *file, int line, const char *function, UPLogChannel *channel, const char *format, ...);
void UPLogAlwaysV(const char *format, va_list args);
void UPLogAlways(const char *format, ...);
void UPLogAlwaysAndCrash(const char *format, ...);
void UPLog(UPLogChannel *, const char *format, ...);
void UPGetBacktrace(void **stack, int *size);
void UPReportBacktrace(void);
void UPPrintBacktrace(void** stack, int size);

#if LOG_DISABLED
#define LOG_CHANNEL_ON(channel) ((void)0)
#else
#define LOG_CHANNEL_ON(channel) UPLogEnable(&LOG_CHANNEL(channel))
#endif

#if LOG_DISABLED
#define LOG_CHANNEL_OFF(channel) ((void)0)
#else
#define LOG_CHANNEL_OFF(channel) UPLogDisable(&LOG_CHANNEL(channel))
#endif

#define CPU(UP_FEATURE) (defined UP_CPU_##UP_FEATURE  && UP_CPU_##UP_FEATURE)

/* CPU(X86_64) - AMD64 / Intel64 / x86_64 64-bit */
#if   defined(__x86_64__) || defined(_M_X64)
#define UP_CPU_X86_64 1
#define UP_CPU_X86_SSE2 1
#define UP_CPU_KNOWN 1
#endif

/* CPU(ARM64) - Apple */
#if (defined(__arm64__) && defined(__APPLE__)) || defined(__aarch64__)
#define UP_CPU_ARM64 1
#define UP_CPU_KNOWN 1

#if defined(__arm64e__)
#define UP_CPU_ARM64E 1
#endif
#endif

#if CPU(X86_64) || CPU(X86)
#define UPBreakpointTrap()  asm volatile ("int3")
#elif CPU(ARM_THUMB2)
#define UPBreakpointTrap()  asm volatile ("bkpt #0")
#elif CPU(ARM64)
#define UPBreakpointTrap()  asm volatile ("brk #0")
#else
#define UPBreakpointTrap() UPCrash() // Not implemented.
#endif

#ifndef CRASH

#if defined(NDEBUG)
#define CRASH() do { \
    UPBreakpointTrap(); \
    __builtin_unreachable(); \
} while (0)
#else
#define CRASH() UPCrash()
#endif

#endif // !defined(CRASH)

NO_RETURN_DUE_TO_CRASH void UPCrash(void);

#if LOG_DISABLED
#else
#define UP_LOG_CHANNELS(M) \
M(General) \
M(Gestures) \
M(Layout) \
M(Leaks) \
M(Lexicon) \
M(Mode) \
M(SaveRestore) \
M(Settings) \
M(Sound) \
M(State) \

UP_LOG_CHANNELS(DECLARE_LOG_CHANNEL)
#endif

#ifdef __cplusplus
}  // extern "C"
#endif

#define UP_PRETTY_FUNCTION __PRETTY_FUNCTION__

#if LOG_DISABLED
#define LOG(channel, ...) ((void)0)
#define LOG_DEBUG(...) ((void)0)
#else
#define LOG(channel, ...) UPLog(&LOG_CHANNEL(channel), __VA_ARGS__)
#define LOG_DEBUG(...) UPDebug(__VA_ARGS__)
#endif

#if ASSERT_DISABLED

#define ASSERT(assertion) ((void)0)
#define ASSERT_AT(assertion, file, line, function) ((void)0)
#define ASSERT_NOT_REACHED() ((void)0)
#define NO_RETURN_DUE_TO_ASSERT

#else  // ASSERT_DISABLED

#define ASSERT(assertion) do { \
    if (!(assertion)) { \
        UPReportAssertionFailure(__FILE__, __LINE__, UP_PRETTY_FUNCTION, #assertion); \
        CRASH(); \
    } \
} while (0)

#define ASSERT_AT(assertion, file, line, function) do { \
    if (!(assertion)) { \
        UPReportAssertionFailure(file, line, function, #assertion); \
        CRASH(); \
    } \
} while (0)

#define ASSERT_NOT_REACHED() do { \
    UPReportAssertionFailure(__FILE__, __LINE__, UP_PRETTY_FUNCTION, 0); \
    CRASH(); \
} while (0)

#define NO_RETURN_DUE_TO_ASSERT NO_RETURN_DUE_TO_CRASH

#endif  // ASSERT_DISABLED

/* ASSERT_WITH_MESSAGE */

#if ASSERT_MSG_DISABLED
#define ASSERT_WITH_MESSAGE(assertion, ...) ((void)0)
#else
#define ASSERT_WITH_MESSAGE(assertion, ...) do { \
    if (!(assertion)) { \
        UPReportAssertionFailureWithMessage(__FILE__, __LINE__, UP_PRETTY_FUNCTION, #assertion, __VA_ARGS__); \
        CRASH(); \
    } \
} while (0)
#endif

// FATAL

#if FATAL_DISABLED
#define FATAL(...) ((void)0)
#else
#define FATAL(...) do { \
    UPReportFatalError(__FILE__, __LINE__, UP_PRETTY_FUNCTION, __VA_ARGS__); \
    CRASH(); \
} while (0)
#endif

// LOG_ERROR

#if ERROR_DISABLED
#define LOG_ERROR(...) ((void)0)
#else
#define LOG_ERROR(...) UPReportError(__FILE__, __LINE__, UP_PRETTY_FUNCTION, __VA_ARGS__)
#endif

// LOG

#if LOG_DISABLED
#define LOG_NORMAL(channel, ...) ((void)0)
#else
#define LOG_NORMAL(channel, ...) UPLog(&LOG_CHANNEL(channel), __VA_ARGS__)
#endif

// LOG_VERBOSE

#if LOG_DISABLED
#define LOG_VERBOSE(channel, ...) ((void)0)
#else
#define LOG_VERBOSE(channel, ...) UPLogVerbose(__FILE__, __LINE__, UP_PRETTY_FUNCTION, &LOG_CHANNEL(channel), __VA_ARGS__)
#endif
