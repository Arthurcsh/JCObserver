//
//  JCObserverMacros.h
//  JCObserver
//
//  Created by abc on 17/4/4.
//  Copyright © 2017年 jackcat. All rights reserved.
//

/**
 *  该文件中的宏来自原ReactiveCocoa项目
 */

#ifndef JCObserverMacros_h
#define JCObserverMacros_h

/**
 *
 * \@keypath allows compile-time verification of key paths. Given a real object
 * receiver and key path:
 *
 * @code
 
 NSString *UTF8StringPath = @keypath(str.lowercaseString.UTF8String);
 // => @"lowercaseString.UTF8String"
 
 NSString *versionPath = @keypath(NSObject, version);
 // => @"version"
 
 NSString *lowercaseStringPath = @keypath(NSString.new, lowercaseString);
 // => @"lowercaseString"
 
 * @endcode
 *
 * ... the macro returns an \c NSString containing all but the first path
 * component or argument (e.g., @"lowercaseString.UTF8String", @"version").
 *
 * In addition to simply creating a key path, this macro ensures that the key
 * path is valid at compile-time (causing a syntax error if not), and supports
 * refactoring, such that changing the name of the property will also update any
 * uses of \@keypath.
 
 #define keypath(...) \
 keypath2(__VA_ARGS__)
 metamacro_if_eq(1, metamacro_argcount(__VA_ARGS__))(keypath1(__VA_ARGS__))(keypath2(__VA_ARGS__))
 */

#define jc_keypath(...) jc_keypath2(__VA_ARGS__)

#define jc_keypath1(PATH) \
(((void)(NO && ((void)PATH, NO)), strchr(# PATH, '.') + 1))

#define jc_keypath2(OBJ, PATH) \
(((void)(NO && ((void)OBJ.PATH, NO)), # PATH))



#define _JCObserve(TARGET, KEYPATH) \
({ \
__weak id target_ = (TARGET); \
[target_ jc_observeValueForKeyPath:@jc_keypath(TARGET, KEYPATH)];\
})



#if __clang__ && (__clang_major__ >= 8)
#define JCObserve(TARGET, KEYPATH) _JCObserve(TARGET, KEYPATH)
#else
#define JCObserve(TARGET, KEYPATH) \
({ \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \
_JCObserve(TARGET, KEYPATH) \
_Pragma("clang diagnostic pop") \
})
#endif

#endif /* JCObserverMacros_h */
