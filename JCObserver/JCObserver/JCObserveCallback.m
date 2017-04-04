//
//  JCObserveCallback.m
//  JCObserver
//
//  Created by abc on 17/4/4.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "JCObserveCallback.h"

@implementation JCObserveCallback

- (instancetype)initWithObj:(id)obj keypath:(NSString*)keypath changedBlock:(void(^)(id newValue,id oldValue))changedBlock{
    self = [super init];
    if (self) {
        self->_obj = obj;
        self->_keypath = keypath;
        self->_changedBlock = changedBlock;
    }
    return self;
}

@end
