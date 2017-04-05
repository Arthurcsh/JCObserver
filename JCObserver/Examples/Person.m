//
//  Person.m
//  JCObserve
//
//  Created by abc on 17/4/4.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc{
    NSLog(@"--p %@ 被释放了",self);
}

@end
