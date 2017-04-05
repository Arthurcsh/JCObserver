//
//  JCObserveCallback.h
//  JCObserver
//
//  Created by abc on 17/4/4.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCObserverCallback : NSObject

/**
 *  监听的对象
 **/
@property (nonatomic,weak,readonly) id obj;

/**
 *  监听属性
 **/
@property (nonatomic,copy,readonly) NSString *keypath;

/**
 *  监听回调
 **/
@property (nonatomic,copy,readonly) void(^changedBlock)(id newValue,id oldValue);

- (instancetype)initWithObj:(id)obj keypath:(NSString*)keypath changedBlock:(void(^)(id newValue,id oldValue))changedBlock;

@end
