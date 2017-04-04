//
//  ViewController.m
//  JCObserver
//
//  Created by abc on 17/4/3.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ViewController.h"

#import "JCObserver.h"

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Person *p = [[Person alloc]init];
    p.username = @"wyp";
    
//    [JCObserve(_p, username) changed:^(id newValue, id oldValue) {
//        NSLog(@"--用户名被改变了，newValue = %@ oldValue=%@",newValue,oldValue);
//    }];
    
    [p jc_observeValueForKeyPath:@"username" changed:^(id newValue, id oldValue) {
        NSLog(@"--用户名被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    [p jc_observeValueForKeyPath:@"username" changed:^(id newValue, id oldValue) {
        NSLog(@"--用户名被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    [p jc_observeValueForKeyPath:@"username" changed:^(id newValue, id oldValue) {
        NSLog(@"--用户名被改变了--3，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    
    p.username = @"qlp";
//
//    [p observe:@"username" changed:^(id newValue, id oldValue) {
//        NSLog(@"--用户名被改变了，newValue = %@ oldValue=%@",newValue,oldValue);
//    }];
    
//    [JCObserver(self.view, backgroundColor) changed(^(id newValue,id oldValue){
//        
//    })];
    
//    [self changed:^(id newValue, id oldValue) {
//        
//    }];
//    
//    [self.view changed:^(id newValue, id oldValue) {
//        
//    }];
//    
//    [self.view.backgroundColor changed:^(id newValue, id oldValue) {
//        
//    }];
}

- (void)dealloc{
//    [_p removeObserver:self forKeyPath:@"username"];
}

@end
