//
//  ExampleVC2.m
//  JCObserver
//
//  Created by abc on 17/4/5.
//  Copyright © 2017年 jackcat. All rights reserved.
//

#import "ExampleVC2.h"
#import "JCObserve.h"
#import "Person.h"

#import <JCFrameLayout/JCFrameLayout.h>

@interface ExampleVC2 ()
/**
 *  <#注释#>
 **/
@property (nonatomic,strong) Person *person;
@end

@implementation ExampleVC2

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
}

- (void)setObserve{
    
    self.person = [Person new];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
            NSLog(@"\n--p.username被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
            NSLog(@"\n--p.username被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
            NSLog(@"\n--p.username被改变了--3，newValue = %@ oldValue=%@",newValue,oldValue);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
            NSLog(@"\n--p.username被改变了--4，newValue = %@ oldValue=%@",newValue,oldValue);
        }];
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
            NSLog(@"\n--p.username被改变了--5，newValue = %@ oldValue=%@",newValue,oldValue);
        }];
    });
}

- (void)changeUsername:(UIButton*)sender{
    NSString *username = [NSString stringWithFormat:@"username_%zd",arc4random_uniform(10)];
    self.person.username = username;
}

- (void)dealloc{
    NSLog(@"---ExampleVC2 dealloc");
}
@end
