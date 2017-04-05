//
//  NSObject+JCObserver.h
//  JCObserver
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (JCObserver_History_1)

/**
    KVO监听

 @param keyPath 监听的属性名
 @param changedBlock 回调方法
 */
- (void)jc_observeValueForKeyPath:(NSString*)keyPath changed:(void(^)(id newValue,id oldValue))changedBlock;

@end
