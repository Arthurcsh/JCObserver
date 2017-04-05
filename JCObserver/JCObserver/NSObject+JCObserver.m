//
//  NSObject+JCObserve.m
//  JCObserve
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "NSObject+JCObserver.h"
#import <objc/runtime.h>
#import <objc/message.h>

//存储回调数组的Key
const char *jc_callbacks_key;
//Observe子类后缀名
static  NSString * const jc_observer_subclass_suffix = @"_jc_observe_subclass";

#pragma mark - debug

#pragma mark - Helpers
static NSString * getterForSetter(NSString *setter)
{
    if (setter.length <=0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
        return nil;
    }
    
    // remove 'set' at the begining and ':' at the end
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    
    // lower case the first letter
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1)
                                       withString:firstLetter];
    
    return key;
}
static NSString * setterForGetter(NSString *getter)
{
    if (getter.length <= 0) {
        return nil;
    }
    
    // upper case the first letter
    NSString *firstLetter = [[getter substringToIndex:1] uppercaseString];
    NSString *remainingLetters = [getter substringFromIndex:1];
    
    // add 'set' at the begining and ':' at the end
    NSString *setter = [NSString stringWithFormat:@"set%@%@:", firstLetter, remainingLetters];
    
    return setter;
}

#pragma mark - Overridden Methods
static void kvo_setter(id self, SEL _cmd, id newValue)
{
    NSString *setterName = NSStringFromSelector(_cmd);
    NSString *getterName = getterForSetter(setterName);
    
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superclazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    
    // cast our pointer so the compiler won't complain
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    // call super's setter, which is original class's setter method
    objc_msgSendSuperCasted(&superclazz, _cmd, newValue);
    
    // look up observers and call the blocks
    NSMutableArray<JCObserverKeyPath*>* objserverKeyPaths = objc_getAssociatedObject(self, &jc_callbacks_key);
    for (JCObserverKeyPath *objserverKeyPath in objserverKeyPaths) {
        if ([objserverKeyPath.keypath isEqualToString:getterName]) {
            objserverKeyPath.changedBlcok ? objserverKeyPath.changedBlcok(newValue,oldValue) : 0 ;
        }
    }
}
static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}


#pragma mark - NSObject + JCObserve

@implementation NSObject (JCObserver)

- (JCObserverKeyPath*)jc_observeValueForKeyPath:(NSString*)keypath{
    
    SEL setterSelector = NSSelectorFromString(setterForGetter(keypath));
    Method setterMethod = class_getInstanceMethod([self class], setterSelector);
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, keypath];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return nil;
    }
    
    @synchronized (self) {
        
        Class clazz = object_getClass(self);
        NSString *clazzName = NSStringFromClass(clazz);
        
        // if not an KVO class yet
        if (![clazzName hasSuffix:jc_observer_subclass_suffix]) {
            clazz = [self createObserveSubClassWithOriginalClassName:clazzName];
            object_setClass(self, clazz);
        }
        
        // add our kvo setter if this class (not superclasses) doesn't implement the setter?
        if (![self hasSelector:setterSelector]) {
            const char *types = method_getTypeEncoding(setterMethod);
            class_addMethod(clazz, setterSelector, (IMP)kvo_setter, types);
        }
    }
    
    JCObserverKeyPath *observeKeyPath = [[JCObserverKeyPath alloc]initWithKeyPath:keypath];
    [self.jc_observekeypaths addObject:observeKeyPath];
    
    return observeKeyPath;
}

- (Class)createObserveSubClassWithOriginalClassName:(NSString *)originalClazzName
{
    NSString *kvoClazzName = [originalClazzName stringByAppendingString:jc_observer_subclass_suffix];
    Class clazz = NSClassFromString(kvoClazzName);
    
    if (clazz) {
        return clazz;
    }
    
    // class doesn't exist yet, make it
    Class originalClazz = object_getClass(self);
    Class kvoClazz = objc_allocateClassPair(originalClazz, kvoClazzName.UTF8String, 0);
    
    // grab class method's signature so we can borrow it
    Method clazzMethod = class_getInstanceMethod(originalClazz, @selector(class));
    const char *types = method_getTypeEncoding(clazzMethod);
    class_addMethod(kvoClazz, @selector(class), (IMP)kvo_class, types);
    
    objc_registerClassPair(kvoClazz);
    
    return kvoClazz;
}

- (NSMutableArray<JCObserverKeyPath*>*)jc_observekeypaths{
    
    NSMutableArray<JCObserverKeyPath*> *array = objc_getAssociatedObject(self, &jc_callbacks_key);
    if (!array) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, &jc_callbacks_key, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return array;
}

- (BOOL)hasSelector:(SEL)selector
{
    Class clazz = object_getClass(self);
    unsigned int methodCount = 0;
    Method* methodList = class_copyMethodList(clazz, &methodCount);
    for (unsigned int i = 0; i < methodCount; i++) {
        SEL thisSelector = method_getName(methodList[i]);
        if (thisSelector == selector) {
            free(methodList);
            return YES;
        }
    }
    free(methodList);
    return NO;
}

@end





