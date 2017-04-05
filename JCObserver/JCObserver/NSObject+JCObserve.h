//
//  NSObject+JCObserve.h
//  JCObserve
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JCObserveKeyPath.h"

@interface NSObject (JCObserve)

- (JCObserveKeyPath*)jc_observeValueForKeyPath:(NSString*)keypath;

@end
