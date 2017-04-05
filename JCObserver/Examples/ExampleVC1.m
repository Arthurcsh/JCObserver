//
//  ExampleVC1.m
//  JCObserver
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ExampleVC1.h"
#import "JCObserve.h"
#import "Person.h"

#import <JCFrameLayout/JCFrameLayout.h>

@interface ExampleVC1 ()
/**
 *  <#注释#>
 **/
@property (nonatomic,strong) Person *person;
@end

@implementation ExampleVC1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configView];
    
    [self setObserve];
}

- (void)configView{
    UIButton *usernameBtn = [[UIButton alloc]init];
    usernameBtn.layer.cornerRadius = 8;
    usernameBtn.layer.masksToBounds = YES;
    usernameBtn.layer.borderColor = [UIColor blackColor].CGColor;
    usernameBtn.layer.borderWidth = 1;
    [usernameBtn setTitle:@"修改username" forState:(UIControlStateNormal)];
    [usernameBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [usernameBtn addTarget:self action:@selector(changeUsername:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:usernameBtn];
    [usernameBtn jc_makeLayout:^(JCFrameMake *make) {
        make.centerX.equalTo(self.view);
        make.top.jc_equalTo(50 + 64);
        make.height.jc_equalTo(25);
        make.width.jc_equalTo(200);
    }];
    
    
    UIButton *addressBtn = [[UIButton alloc]init];
    addressBtn.layer.cornerRadius = 8;
    addressBtn.layer.masksToBounds = YES;
    addressBtn.layer.borderColor = [UIColor blackColor].CGColor;
    addressBtn.layer.borderWidth = 1;
    [addressBtn setTitle:@"修改address" forState:(UIControlStateNormal)];
    [addressBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [addressBtn addTarget:self action:@selector(changeAddress:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:addressBtn];
    [addressBtn jc_makeLayout:^(JCFrameMake *make) {
        make.top.equalTo(usernameBtn.jc_bottom).jc_offset(20);
        make.centerX.height.width.equalTo(usernameBtn);
    }];
}

- (void)setObserve{
    
    self.person = [Person new];
    
    [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.username被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
    }];

    [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.username被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    
    [JCObserve(self.person, address) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.address被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    [JCObserve(self.person, address) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.address被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
    
    
    [JCObserve(self.person, age) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.age被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
}

- (void)changeUsername:(UIButton*)sender{
    NSString *username = [NSString stringWithFormat:@"username_%zd",arc4random_uniform(10)];
    self.person.username = username;
}
- (void)changeAddress:(UIButton*)sender{
    NSString *address = [NSString stringWithFormat:@"address_%zd",arc4random_uniform(10)];
    self.person.address = address;
    self.person.age = 10;
}

- (void)dealloc{
    NSLog(@"---ExampleVC1 dealloc");
}
@end
