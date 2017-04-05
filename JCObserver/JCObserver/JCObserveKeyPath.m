//
//  JCOBserveKeypath.m
//  JCObserve
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "JCObserveKeyPath.h"

@implementation JCObserveKeyPath

- (instancetype)initWithKeyPath:(NSString*)keypath{
    self = [super init];
    if (self) {
        self->_keypath = keypath;
    }
    return self;
}

- (void)changed:(void (^)(id newValue, id oldValue))changedBlock{
    self->_changedBlcok = changedBlock;
}

@end
