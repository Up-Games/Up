//
//  UPAssertions.h
//  Copyright © 2020 Up Games. All rights reserved.
//
//  Based on Assertions.h from WebKit.
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

void UPLog(UPLogChannel *, const char *format, ...);

void UPGetBacktrace(void **stack, int *size);
void UPReportBacktrace(void);
void UPPrintBacktrace(void** stack, int size);

typedef void (*UPCrashHookFunction)(void);
void UPSetCrashHook(UPCrashHookFunction);
void UPInstallReportBacktraceOnCrashHook(void);

bool UPIsDebuggerAttached(void);

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

#define NO_RETURN_DUE_TO_ASSERT NO_RETURN_DUE_TO_CRASH

#endif  // ASSERT_DISABLED

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
