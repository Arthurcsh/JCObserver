//
//  JCOBserveKeypath.h
//  JCObserve
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCObserverKeyPath : NSObject

/**
 *  <#注释#>
 **/
@property (nonatomic,copy,readonly) NSString *keypath;

/**
 *  <#注释#>
 **/
@property (nonatomic,copy,readonly) void(^changedBlcok)(id newValue,id oldValue);

- (instancetype)initWithKeyPath:(NSString*)keypath;

- (void)changed:(void (^)(id newValue, id oldValue))changedBlock;

@end
