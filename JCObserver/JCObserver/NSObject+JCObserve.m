//
//  NSObject+JCObserver.m
//  JCObserver
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "NSObject+JCObserve.h"
#import "JCObserveCallback.h"
#import <objc/runtime.h>

const char *jc_observer_subclass_key;
//存储回调数组的Key
const char *jc_callbacks_key;
//已监听Keypath数组的Key
const char *jc_settedKeypaths_key;

static  NSString * const jc_observer_subclass_suffix = @"_JC_OBSERVER_SUBCLASS_SUFFIX";

//在类实现体中是否已经实现了 observeValueForKeyPath:ofObject:change:context:
BOOL hasOriObserveValueForKeyPathMethod = NO;
//在类实现体中是否已经实现了 dealloc
BOOL hasOriDeallocMethod = NO;

#pragma mark - NSObject + Swizzling

@interface NSObject (Swizzling)

/**
 交换方法实现
 
 @param originalSelector 原始方法SEL
 @param swizzledSelector 新的方法SEL
 @return 1:新添加 2:替换
 */
- (uint)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector;

@end

@implementation NSObject (Swizzling)

/**
 交换方法实现
 
 @param originalSelector 原始方法SEL
 @param swizzledSelector 新的方法SEL
 @return 1:新添加 2:替换
 */
- (uint)methodSwizzlingWithOriginalSelector:(SEL)originalSelector
                         bySwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    //原有方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //替换原有方法的新方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //先尝试給源SEL添加IMP，这里是为了避免源SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class,originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {//添加成功：说明源SEL没有实现IMP，将源SEL的IMP替换到交换SEL的IMP
        class_replaceMethod(class,swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
        return 1;
    } else {//添加失败：说明源SEL已经有IMP，直接将两个SEL的IMP交换即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
        return 2;
    }
}

@end

#pragma mark - NSObject + JCObserve

@implementation NSObject (JCObserve)


/**
 执行方法交换
 */
- (void)methodSwizzling{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //[observeValueForKeyPath:ofObject:change:context:]交换
        {
            SEL oriSEL = @selector(observeValueForKeyPath:ofObject:change:context:);
            SEL newSEL = @selector(jc_observeValueForKeyPath:ofObject:change:context:);
            
            hasOriObserveValueForKeyPathMethod = [self methodSwizzlingWithOriginalSelector:oriSEL bySwizzledSelector:newSEL] == 2;
        }
        
        //[dealloc]交换，无法实现
//        {
//            SEL oriSEL = @selector(dealloc); //ARC下无法@selector(dealloc)
//            SEL newSEL = @selector(jc_dealloc);
//            
//            hasOriDeallocMethod = [self methodSwizzlingWithOriginalSelector:oriSEL bySwizzledSelector:newSEL] == 2;
//        }
    });
}

- (id)jc_observeValueForKeyPath:(NSString*)keypath{
    
    [self methodSwizzling];
    
    [self addObserver:self forKeyPath:keypath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    return self;
    
}

/**
 KVO监听
 
 @param keyPath 监听的属性名
 @param changedBlock 回调方法
 */
- (void)jc_observeValueForKeyPath:(NSString*)keyPath changed:(void(^)(id newValue,id oldValue))changedBlock{
    
    //1. 执行方法交换
    [self methodSwizzling];
    
    //2. 确保对keypath只添加一次监听
    if (![self.jc_settedKeypaths containsObject:keyPath]) {
        [self.jc_settedKeypaths addObject:keyPath];
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    
    //3. 根据keypath个数来计算新的keyPath
    //   一个keypath可以有多个监听器，索引自动怎增，如：
    //      username_jcobserve_0
    //      username_jcobserve_1
    //      username_jcobserve_2
    //
    NSArray<JCObserveCallback*>* callbacks = [self getCallbacksWithKeyPath:keyPath];
    NSString *keyPathName = [keyPath stringByAppendingFormat:@"_jcobserve_%zd",callbacks.count];
    
    //4. 封装监听器并缓存
    JCObserveCallback *callback = [[JCObserveCallback alloc]initWithObj:self keypath:keyPathName changedBlock:changedBlock];
    [self.jc_callbacks addObject:callback];
}

/**
 KVO监听回调方法
 */
- (void)jc_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    //1. 根据keypath获取所有的监听器,并调用
    NSArray *callbacks = [self getCallbacksWithKeyPath:keyPath];
    if (callbacks.count > 0) {
        
        id newValue = change[@"new"];
        id oldValue = change[@"old"];
        
        for (JCObserveCallback *callback in callbacks) {
            callback.changedBlock(newValue,oldValue);
        }
        
    }
    
    //2. 如果原先有observeValueForKeyPath的实现，则需要调用一下原先的observeValueForKeyPath实现
    if (hasOriObserveValueForKeyPathMethod) {
        [self jc_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/**
 监听器集合
 */
- (NSMutableArray<JCObserveCallback*>*)jc_callbacks{
    
    NSMutableArray<JCObserveCallback*> *array = objc_getAssociatedObject(self, &jc_callbacks_key);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &jc_callbacks_key, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}
/**
 已监听Keypath集合
 */
- (NSMutableArray<NSString*>*)jc_settedKeypaths{
    
    NSMutableArray<NSString*> *array = objc_getAssociatedObject(self, &jc_settedKeypaths_key);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &jc_settedKeypaths_key, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

/**
 根据keypath过滤所有的监听器
 */
- (NSArray<JCObserveCallback*>*)getCallbacksWithKeyPath:(NSString*)keyPath{
    
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(JCObserveCallback  *callback, id obj) {
        return [callback.keypath hasPrefix:[keyPath stringByAppendingString:@"_jcobserve"]];
    }];
    
    return [self.jc_callbacks filteredArrayUsingPredicate:predicate];
}


/**
 释放监听
 */
- (void)jc_dealloc{
    for (NSString *keypath in self.jc_settedKeypaths) {
        [self removeObserver:self forKeyPath:keypath];
    }
}

@end





