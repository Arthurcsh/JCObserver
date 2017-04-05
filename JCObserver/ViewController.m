//
//  ViewController.m
//  JCObserve
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JCObserve Demo";
}

- (NSArray<NSDictionary<NSString *,UIViewController *> *> *)datasource{
    
    return @[
           @{@"title":@"Person-KVO",@"cls":@"ExampleVC1"},
           @{@"title":@"Person-KVO-多线程",@"cls":@"ExampleVC2"},
           @{@"title":@"UIColor-KVO",@"cls":@"ExampleVC3"},
           @{@"title":@"Frame-KVO(暂不支持)",@"cls":@"ExampleVC4"},
           ];
}


@end
